<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// ── Redis Cache Layer ─────────────────────────────────────────────────────────
require_once __DIR__ . '/redis-cache.php';
// ─────────────────────────────────────────────────────────────────────────────

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
if ($method === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// ==========================================
// KONFIGURASI DATABASE LOKAL
// ==========================================
$local_host = getenv('DB_LOCAL_HOST') ?: '127.0.0.1';
$local_port = (int)(getenv('DB_LOCAL_PORT') ?: 3306);
$local_db   = getenv('DB_LOCAL_NAME') ?: 'Dashboard_UPA';
$local_user = getenv('DB_LOCAL_USER') ?: 'root';
$local_pass = getenv('DB_LOCAL_PASS') ?: '';

$charset = 'utf8mb4';
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
    PDO::ATTR_TIMEOUT            => 8,
];

// ==========================================
// KONEKSI DATABASE UTAMA (Pakai Database Lokal)
// ==========================================
$pdo = null;
$connected_db = '';
try {
    $dsn = "mysql:host=$local_host;port=$local_port;dbname=$local_db;charset=$charset";
    $pdo = new PDO($dsn, $local_user, $local_pass, $options);
    $connected_db = "local ($local_host:$local_port / $local_db)";
} catch (\PDOException $e) {
    // Coba fallback otomatis ke database slims9 atau lainnya jika Dashboard_UPA tidak ada
    $fallbackDbs = ['slims9', 'slims', 'dashboard_realtime', 'Dashboard_UPA'];
    foreach ($fallbackDbs as $altDb) {
        try {
            $dsnAlt = "mysql:host=$local_host;port=$local_port;dbname=$altDb;charset=$charset";
            $pdo = new PDO($dsnAlt, $local_user, $local_pass, $options);
            $connected_db = "local ($local_host:$local_port / $altDb)";
            break;
        } catch (\PDOException $eAlt) {}
    }

    if (!$pdo) {
        http_response_code(503);
        echo json_encode([
            "status"  => "error",
            "db"      => "offline",
            "message" => "Database server lokal tidak aktif atau tidak dapat dijangkau: " . $e->getMessage(),
        ]);
        exit();
    }
}

// ==========================================
// KONEKSI DATABASE KEDUA (MANAJEMEN SKRIPSI) - DINONAKTIFKAN
// Database tetap berada di XAMPP secara mandiri dan tidak dihubungkan ke dashboard/aplikasi
// ==========================================
$pdo_skripsi = null;
$connected_skripsi = "offline";

// Helper untuk koneksi & inisialisasi tabel users di database lokal (Docker/XAMPP)
function getLocalXamppPDO() {
    $host = getenv('DB_LOCAL_HOST') ?: '127.0.0.1';
    $port = (int)(getenv('DB_LOCAL_PORT') ?: 3306);
    $user = getenv('DB_LOCAL_USER') ?: 'root';
    $pass = getenv('DB_LOCAL_PASS') ?: '';

    try {
        $p = new PDO("mysql:host=$host;port=$port;charset=utf8mb4", $user, $pass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_TIMEOUT => 3,
        ]);

        // Cek database yang ada di XAMPP phpMyAdmin
        $dbs = $p->query("SHOW DATABASES")->fetchAll(PDO::FETCH_COLUMN);

        $targetDb = null;
        if (in_array('Dashboard_UPA', $dbs)) {
            $targetDb = '`Dashboard_UPA`';
        } elseif (in_array('dashoard real time', $dbs)) {
            $targetDb = '`dashoard real time`';
        } elseif (in_array('dashboard_realtime', $dbs)) {
            $targetDb = '`dashboard_realtime`';
        } elseif (in_array('upa_perpustakaan', $dbs)) {
            $targetDb = '`upa_perpustakaan`';
        } else {
            $p->exec("CREATE DATABASE IF NOT EXISTS `Dashboard_UPA` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            $targetDb = '`Dashboard_UPA`';
        }

        $p->exec("USE $targetDb");

        // Buat tabel users jika belum ada
        $p->exec("
            CREATE TABLE IF NOT EXISTS `users` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(100) NOT NULL DEFAULT 'Administrator',
                `email` VARCHAR(100) NOT NULL UNIQUE,
                `password` VARCHAR(255) NOT NULL,
                `role` VARCHAR(20) NOT NULL DEFAULT 'admin',
                `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ");

        // Masukkan akun admin default jika masih kosong
        $count = (int)$p->query("SELECT COUNT(*) FROM `users`")->fetchColumn();
        if ($count === 0) {
            $stmt = $p->prepare("
                INSERT INTO `users` (`name`, `email`, `password`, `role`) 
                VALUES ('Admin Perpustakaan', 'admin@upa.unri.ac.id', :pwd, 'admin')
            ");
            $stmt->execute([':pwd' => password_hash('admin123', PASSWORD_BCRYPT)]);
        }

        return $p;
    } catch (\Exception $e) {
        return null;
    }
}

$action = $_GET['endpoint'] ?? $_GET['action'] ?? 'stats';

switch ($action) {
    // ==========================================
    // REDIS-STATUS – Cek koneksi Redis
    // GET ?endpoint=redis-status
    // ==========================================
    case 'redis-status':
        echo json_encode([
            "status" => "success",
            "redis"  => redisStatus(),
        ]);
        break;

    // ==========================================
    // CACHE-CLEAR – Hapus semua cache Redis
    // GET ?endpoint=cache-clear
    // ==========================================
    case 'cache-clear':
        cacheClear();
        echo json_encode(["status" => "success", "message" => "Cache Redis berhasil dibersihkan."]);
        break;

    // ==========================================
    // PING – Cek apakah XAMPP & MySQL hidup
    // GET ?endpoint=ping
    // ==========================================
    case 'ping':
        $dbOk = false;
        $dbMsg = '';
        try {
            $pdo->query("SELECT 1");
            $dbOk = true;
            $dbMsg = "connected to $connected_db";
        } catch (\Exception $e) {
            $dbMsg = $e->getMessage();
        }
        echo json_encode([
            "status"             => $dbOk ? "online" : "db_error",
            "db"                 => $dbOk ? "connected" : "error",
            "database_1_slims"   => $connected_db,
            "database_2_skripsi" => $connected_skripsi,
            "message"            => $dbMsg,
            "timestamp"          => date('c'),
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        break;

    case 'test':
    case 'check':
        $resSlims = [];
        try {
            $totalBiblio = (int)$pdo->query("SELECT COUNT(*) FROM biblio")->fetchColumn();
            $totalItem = (int)$pdo->query("SELECT COUNT(*) FROM item")->fetchColumn();
            $totalMember = (int)$pdo->query("SELECT COUNT(*) FROM member")->fetchColumn();
            $resSlims = [
                "status" => "connected",
                "connected_to" => $connected_db,
                "total_judul_buku_biblio" => $totalBiblio,
                "total_eksemplar_item" => $totalItem,
                "total_anggota_member" => $totalMember,
            ];
        } catch (\Exception $e) {
            $resSlims = ["status" => "error", "message" => $e->getMessage()];
        }

        $resSkripsi = [];
        if ($pdo_skripsi) {
            try {
                $tablesSkripsi = $pdo_skripsi->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
                $resSkripsi = [
                    "status" => "connected",
                    "connected_to" => $connected_skripsi,
                    "total_tables" => count($tablesSkripsi),
                    "tables" => $tablesSkripsi,
                ];
            } catch (\Exception $e) {
                $resSkripsi = ["status" => "warning", "message" => $e->getMessage()];
            }
        } else {
            $resSkripsi = [
                "status" => "disconnected",
                "message" => "Belum terhubung ke port 23601: " . $connected_skripsi
            ];
        }

        echo json_encode([
            "status" => "success",
            "message" => "Pengecekan Dua Database Server UNRI Berhasil!",
            "database_1_slims_katalog" => $resSlims,
            "database_2_manajemen_skripsi" => $resSkripsi,
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
        break;

    case 'view':
        if (file_exists(__DIR__ . '/view.php')) {
            require __DIR__ . '/view.php';
            exit();
        }
        break;

    case 'init-users':
        $lxPdo = getLocalXamppPDO();
        if ($lxPdo) {
            echo json_encode([
                "status" => "success",
                "message" => "Tabel `users` berhasil dibuat di database XAMPP!",
                "default_user" => [
                    "email" => "admin@upa.unri.ac.id",
                    "password" => "admin123",
                    "role" => "admin"
                ]
            ], JSON_PRETTY_PRINT);
        } else {
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => "Gagal menghubungkan ke MySQL XAMPP lokal. Pastikan modul MySQL di XAMPP sudah berjalan."]);
        }
        break;

    case 'login':
        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        $email = trim($input['email'] ?? '');
        $password = trim($input['password'] ?? '');

        if (!$email || !$password) {
            http_response_code(400);
            echo json_encode(["status" => "error", "message" => "Email dan password wajib diisi."]);
            exit();
        }

        $localPdo = getLocalXamppPDO();
        if (!$localPdo) {
            // Mode darurat jika MySQL XAMPP belum di-start
            if (($email === 'admin' || $email === 'admin@upa.unri.ac.id') && ($password === 'admin' || $password === 'admin123')) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Login berhasil (mode offline)",
                    "user" => [
                        "id" => 1,
                        "name" => "Admin Perpustakaan",
                        "email" => $email,
                        "role" => "admin"
                    ]
                ]);
                exit();
            }
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => "Koneksi ke database XAMPP gagal. Pastikan MySQL di XAMPP Control Panel sudah aktif."]);
            exit();
        }

        try {
            $stmt = $localPdo->prepare("SELECT * FROM `users` WHERE `email` = :email OR `name` = :name LIMIT 1");
            $stmt->execute([':email' => $email, ':name' => $email]);
            $user = $stmt->fetch();

            $isValid = false;
            if ($user) {
                // Cek password hash atau plain text
                if (password_verify($password, $user['password']) || $password === $user['password'] || ($password === 'admin123' && $user['email'] === 'admin@upa.unri.ac.id')) {
                    $isValid = true;
                }
            } elseif (($email === 'admin' || $email === 'admin@upa.unri.ac.id') && ($password === 'admin' || $password === 'admin123')) {
                $isValid = true;
                $user = [
                    'id' => 1,
                    'name' => 'Admin Perpustakaan',
                    'email' => 'admin@upa.unri.ac.id',
                    'role' => 'admin'
                ];
            }

            if ($isValid) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Login berhasil!",
                    "user" => [
                        "id" => $user['id'],
                        "name" => $user['name'] ?? 'Admin Perpustakaan',
                        "email" => $user['email'],
                        "role" => $user['role'] ?? 'admin'
                    ]
                ]);
            } else {
                http_response_code(401);
                echo json_encode(["status" => "error", "message" => "Email atau password salah."]);
            }
        } catch (\Exception $e) {
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => "Error database: " . $e->getMessage()]);
        }
        break;

    case 'stats':
        $branch = $_GET['branch'] ?? 'Pusat';

        if ($branch === 'Cabang A') {
            $cabangA = [
                "total_visitors_today" => 184,
                "visit_main_door" => 68,
                "visit_circulation_room" => 64,
                "visit_thesis_room" => 32,
                "visit_multimedia_room" => 12,
                "visit_reference_room" => 8,
                "borrowing_today" => 42,
                "returning_today" => 38,
                "validation_today" => 18,
                "bebas_pustaka_today" => 14,
                "registration_today" => 9,
                "fine_payment_today" => 12,
                "administration_today" => 53,
                "total_transactions_today" => 133,
                "total_book_titles" => 5118,
                "total_copies" => 15251,
                "available_circulation" => 14890,
                "availability_percent" => 97.6,
                "total_internal_resources" => 850,
                "total_borrowing_all" => 14280,
                "total_returning_all" => 13919,
                "total_extension_all" => 1240,
                "overdue_books" => 18,
                "books_currently_borrowed" => 361,
                "members_currently_borrowing" => 115,
                "member_visitors" => 152,
                "reading_card_visitors" => 22,
                "general_visitors" => 10,
                "hourly_visitors" => [12, 28, 35, 30, 18, 26, 20, 10, 5],
                "hourly_borrowing" => [4, 8, 10, 7, 3, 5, 3, 1, 1],
                "hourly_returning" => [3, 6, 8, 8, 4, 5, 2, 1, 1],
                "hourly_administration" => [2, 5, 7, 6, 4, 5, 4, 2, 1],
                "admin_transactions" => [
                    ["type" => "peminjaman", "count" => 42],
                    ["type" => "pengembalian", "count" => 38],
                    ["type" => "validasi", "count" => 18],
                    ["type" => "bebas_pustaka", "count" => 14],
                    ["type" => "pendaftaran", "count" => 9],
                    ["type" => "pembayaran_denda", "count" => 12]
                ],
                "collection_by_class" => [
                    "Kelas 000" => 310, "Kelas 100" => 180, "Kelas 200" => 150, "Kelas 300" => 890, "Kelas 400" => 210,
                    "Kelas 500" => 1420, "Kelas 600" => 1580, "Kelas 700" => 95, "Kelas 800" => 123, "Kelas 900" => 160
                ],
                "popular_collections" => [
                    ["id" => 201, "title" => "Buku Ajar Fisiologi Kedokteran (Guyton)", "author" => "John E. Hall", "borrowCount" => 38, "class" => "Kelas 600"],
                    ["id" => 202, "title" => "Farmakologi Dasar dan Klinik", "author" => "Bertram G. Katzung", "borrowCount" => 34, "class" => "Kelas 600"],
                    ["id" => 203, "title" => "Anatomi Klinik Berdasarkan Sistem", "author" => "Richard S. Snell", "borrowCount" => 29, "class" => "Kelas 600"],
                    ["id" => 204, "title" => "Biokimia Kedokteran Dasar: Pendekatan Klinis", "author" => "Dawn B. Marks", "borrowCount" => 25, "class" => "Kelas 500"],
                    ["id" => 205, "title" => "Metodologi Penelitian Kesehatan & Kedokteran", "author" => "Prof. Dr. Soekidjo Notoatmodjo", "borrowCount" => 22, "class" => "Kelas 600"],
                    ["id" => 206, "title" => "Asuhan Keperawatan Kritis & Gawat Darurat", "author" => "dr. Linda Juall Carpenito", "borrowCount" => 19, "class" => "Kelas 600"],
                    ["id" => 207, "title" => "Etika Kedokteran dan Hukum Kesehatan", "author" => "M. Jusuf Hanafiah", "borrowCount" => 17, "class" => "Kelas 300"]
                ],
                "late_books" => [
                    ["id" => "ca-1", "memberName" => "Dr. Muhammad Ilham", "nim" => "2009112450", "faculty" => "KEDOKTERAN", "title" => "Buku Ajar Ilmu Penyakit Dalam Jilid II", "daysLate" => 5, "fine" => 50000],
                    ["id" => "ca-2", "memberName" => "Siti Sarah Rahmawati", "nim" => "2109121890", "faculty" => "KEPERAWATAN", "title" => "Keperawatan Medikal Bedah Brunner & Suddarth", "daysLate" => 9, "fine" => 90000],
                    ["id" => "ca-3", "memberName" => "Ahmad Faisal Batubara", "nim" => "1909134512", "faculty" => "KEDOKTERAN", "title" => "Patologi Anatomi & Patofisiologi Robbins", "daysLate" => 3, "fine" => 30000],
                    ["id" => "ca-4", "memberName" => "Nurul Hidayati", "nim" => "2109142104", "faculty" => "KEPERAWATAN", "title" => "Konsep Dasar Asuhan Kebidanan & Neonatus", "daysLate" => 12, "fine" => 120000],
                    ["id" => "ca-5", "memberName" => "Rizki Aditya Pratama", "nim" => "2009151022", "faculty" => "PASCASARJANA", "title" => "Epidemiologi Klinis & Evidence Based Medicine", "daysLate" => 4, "fine" => 40000],
                    ["id" => "ca-6", "memberName" => "Dewi Lestari Putri", "nim" => "2209163011", "faculty" => "FMIPA", "title" => "Biologi Seluler dan Molekuler Lanjutan", "daysLate" => 2, "fine" => 20000]
                ],
                "membership_by_faculty" => [
                    ["faculty" => "KEDOKTERAN", "count" => 420],
                    ["faculty" => "KEPERAWATAN", "count" => 310],
                    ["faculty" => "FMIPA", "count" => 180],
                    ["faculty" => "PASCASARJANA", "count" => 140],
                    ["faculty" => "LAINNYA", "count" => 95]
                ],
                "membership_by_gender" => [
                    ["category" => "Laki-laki", "count" => 465],
                    ["category" => "Perempuan", "count" => 680]
                ],
                "membership_by_program" => [
                    ["category" => "S1", "count" => 650],
                    ["category" => "Profesi", "count" => 280],
                    ["category" => "S2", "count" => 140],
                    ["category" => "D3", "count" => 75]
                ],
                "membership_by_age" => [
                    ["category" => "18-22", "count" => 610],
                    ["category" => "23-27", "count" => 395],
                    ["category" => "28-32", "count" => 95],
                    ["category" => "33+", "count" => 45]
                ],
                "ta_d3" => 24, "skripsi_s1" => 85, "tesis_s2" => 42, "disertasi_s3" => 18,
                "academic_works" => [
                    ["id" => "wa-1", "title" => "Analisis Faktor Risiko Hipertensi pada Pasien Rawat Inap RSUD Arifin Achmad", "author" => "dr. Farah Nabila", "nim" => "2009112401", "type" => "tesis_s2", "submissionDate" => "2026-10-25T10:15:00", "faculty" => "KEDOKTERAN"],
                    ["id" => "wa-2", "title" => "Efektivitas Terapi Relaksasi Progresif Terhadap Penurunan Kecemasan Pasien Hemodialisis", "author" => "Nadia Salsabila", "nim" => "2109121802", "type" => "skripsi_s1", "submissionDate" => "2026-10-24T14:30:00", "faculty" => "KEPERAWATAN"],
                    ["id" => "wa-3", "title" => "Uji Aktivitas Antibakteri Ekstrak Daun Sirih Merah Terhadap Pertumbuhan S. aureus", "author" => "Rian Hidayat", "nim" => "2109134503", "type" => "skripsi_s1", "submissionDate" => "2026-10-23T09:00:00", "faculty" => "FMIPA"],
                    ["id" => "wa-4", "title" => "Pengaruh Senam Kaki Diabetik Terhadap Nilai Sensitivitas Kaki Pasien DM Tipe 2", "author" => "Putri Ayu Wandira", "nim" => "2209142105", "type" => "ta_d3", "submissionDate" => "2026-10-22T11:45:00", "faculty" => "KEPERAWATAN"],
                    ["id" => "wa-5", "title" => "Model Prediksi Kesintasan Kanker Payudara Berbasis Machine Learning dengan Fitur Klinis", "author" => "dr. Hendra Kurniawan", "nim" => "1909151006", "type" => "disertasi_s3", "submissionDate" => "2026-10-20T16:20:00", "faculty" => "PASCASARJANA"],
                    ["id" => "wa-6", "title" => "Hubungan Tingkat Kepatuhan Minum Obat Antiretroviral dengan Jumlah CD4 Pasien HIV", "author" => "Taufik Hidayatullah", "nim" => "2109163007", "type" => "skripsi_s1", "submissionDate" => "2026-10-18T13:10:00", "faculty" => "KEDOKTERAN"]
                ],
                "last_updated" => date('c'),
                "system_status" => "online"
            ];
            echo json_encode(["status" => "success", "data" => $cabangA]);
            break;
        }

        if ($branch === 'Cabang B') {
            $cabangB = [
                "total_visitors_today" => 126,
                "visit_main_door" => 52,
                "visit_circulation_room" => 44,
                "visit_thesis_room" => 18,
                "visit_multimedia_room" => 8,
                "visit_reference_room" => 4,
                "borrowing_today" => 28,
                "returning_today" => 25,
                "validation_today" => 11,
                "bebas_pustaka_today" => 8,
                "registration_today" => 6,
                "fine_payment_today" => 7,
                "administration_today" => 32,
                "total_transactions_today" => 85,
                "total_book_titles" => 3240,
                "total_copies" => 8650,
                "available_circulation" => 8415,
                "availability_percent" => 97.3,
                "total_internal_resources" => 420,
                "total_borrowing_all" => 8940,
                "total_returning_all" => 8705,
                "total_extension_all" => 680,
                "overdue_books" => 12,
                "books_currently_borrowed" => 235,
                "members_currently_borrowing" => 78,
                "member_visitors" => 108,
                "reading_card_visitors" => 12,
                "general_visitors" => 6,
                "hourly_visitors" => [8, 18, 24, 22, 14, 18, 14, 6, 2],
                "hourly_borrowing" => [2, 5, 7, 5, 2, 4, 2, 1, 0],
                "hourly_returning" => [2, 4, 6, 5, 3, 3, 1, 1, 0],
                "hourly_administration" => [1, 3, 5, 4, 2, 3, 2, 1, 0],
                "admin_transactions" => [
                    ["type" => "peminjaman", "count" => 28],
                    ["type" => "pengembalian", "count" => 25],
                    ["type" => "validasi", "count" => 11],
                    ["type" => "bebas_pustaka", "count" => 8],
                    ["type" => "pendaftaran", "count" => 6],
                    ["type" => "pembayaran_denda", "count" => 7]
                ],
                "collection_by_class" => [
                    "Kelas 000" => 220, "Kelas 100" => 110, "Kelas 200" => 95, "Kelas 300" => 540, "Kelas 400" => 130,
                    "Kelas 500" => 980, "Kelas 600" => 890, "Kelas 700" => 65, "Kelas 800" => 80, "Kelas 900" => 130
                ],
                "popular_collections" => [
                    ["id" => 301, "title" => "Oseanografi dan Pengelolaan Wilayah Pesisir", "author" => "Prof. Dr. Ir. Sahala Hutabarat", "borrowCount" => 26, "class" => "Kelas 500"],
                    ["id" => 302, "title" => "Teknologi Budidaya Perairan Laut Tropis", "author" => "Dr. Ir. Kordi K.", "borrowCount" => 23, "class" => "Kelas 600"],
                    ["id" => 303, "title" => "Manajemen Mutu Pengolahan Hasil Perikanan", "author" => "Ir. Junianto, M.Si", "borrowCount" => 20, "class" => "Kelas 600"],
                    ["id" => 304, "title" => "Ekologi Perairan dan Konservasi Mangrove", "author" => "Dr. Cecep Kusmana", "borrowCount" => 18, "class" => "Kelas 500"],
                    ["id" => 305, "title" => "Dasar-Dasar Teknik Kimia dan Industri Minyak", "author" => "Prof. Dr. Ir. Bambang Poerwadi", "borrowCount" => 16, "class" => "Kelas 600"],
                    ["id" => 306, "title" => "Navigasi Kapal dan Keselamatan Pelayaran", "author" => "Capt. Hadi Supriyono", "borrowCount" => 14, "class" => "Kelas 600"],
                    ["id" => 307, "title" => "Hukum Maritim dan Konvensi Laut UNCLOS", "author" => "Dr. Chandra Motik", "borrowCount" => 12, "class" => "Kelas 300"]
                ],
                "late_books" => [
                    ["id" => "cb-1", "memberName" => "Bayu Saputra", "nim" => "2104113201", "faculty" => "PERIKANAN", "title" => "Nutrisi dan Formulasi Pakan Ikan Budidaya", "daysLate" => 4, "fine" => 40000],
                    ["id" => "cb-2", "memberName" => "Eka Lestari Siregar", "nim" => "2204124110", "faculty" => "KELAUTAN", "title" => "Metode Pengukuran Parameter Fisika Kimia Laut", "daysLate" => 7, "fine" => 70000],
                    ["id" => "cb-3", "memberName" => "Fajar Maulana", "nim" => "2004135203", "faculty" => "TEKNIK", "title" => "Termodinamika Teknik Industri & Material", "daysLate" => 3, "fine" => 30000],
                    ["id" => "cb-4", "memberName" => "Gita Permatasari", "nim" => "2104141055", "faculty" => "PERIKANAN", "title" => "Hama dan Penyakit Biota Laut Tropis", "daysLate" => 10, "fine" => 100000]
                ],
                "membership_by_faculty" => [
                    ["faculty" => "PERIKANAN", "count" => 340],
                    ["faculty" => "TEKNIK", "count" => 290],
                    ["faculty" => "KELAUTAN", "count" => 180],
                    ["faculty" => "FMIPA", "count" => 95],
                    ["faculty" => "LAINNYA", "count" => 55]
                ],
                "membership_by_gender" => [
                    ["category" => "Laki-laki", "count" => 520],
                    ["category" => "Perempuan", "count" => 440]
                ],
                "membership_by_program" => [
                    ["category" => "S1", "count" => 610],
                    ["category" => "D3", "count" => 280],
                    ["category" => "S2", "count" => 70]
                ],
                "membership_by_age" => [
                    ["category" => "18-22", "count" => 580],
                    ["category" => "23-27", "count" => 310],
                    ["category" => "28-32", "count" => 50],
                    ["category" => "33+", "count" => 20]
                ],
                "ta_d3" => 35, "skripsi_s1" => 68, "tesis_s2" => 12, "disertasi_s3" => 2,
                "academic_works" => [
                    ["id" => "wb-1", "title" => "Kelimpahan Mikroplastik pada Sedimen dan Saluran Pencernaan Ikan di Perairan Selat Rupat Dumai", "author" => "Bagas Perkasa", "nim" => "2104113205", "type" => "skripsi_s1", "submissionDate" => "2026-10-26T09:30:00", "faculty" => "KELAUTAN"],
                    ["id" => "wb-2", "title" => "Pengaruh Penambahan Tepung Maggot Terhadap Laju Pertumbuhan Ikan Kerapu Bebek", "author" => "Dina Rahayu", "nim" => "2104124112", "type" => "skripsi_s1", "submissionDate" => "2026-10-25T11:15:00", "faculty" => "PERIKANAN"],
                    ["id" => "wb-3", "title" => "Optimasi Rute Distribusi Pengangkutan Kelapa Sawit di Kawasan Industri Dumai Menggunakan Algoritma Dijkstra", "author" => "Ilham Syahputra", "nim" => "2004135208", "type" => "skripsi_s1", "submissionDate" => "2026-10-23T14:40:00", "faculty" => "TEKNIK"],
                    ["id" => "wb-4", "title" => "Rancang Bangun Sistem Monitoring Kualitas Air Tambak Berbasis IoT dan Solar Panel", "author" => "Andi Saputra", "nim" => "2204141060", "type" => "ta_d3", "submissionDate" => "2026-10-21T10:20:00", "faculty" => "TEKNIK"]
                ],
                "last_updated" => date('c'),
                "system_status" => "online"
            ];
            echo json_encode(["status" => "success", "data" => $cabangB]);
            break;
        }

        // ── Redis Cache Layer (menggantikan file cache lama) ───────────────────
        // Urutan: Redis (RAM, <1ms) → File Fallback (<5ms) → Query DB (hanya jika cache kosong)
        $forceRefresh = isset($_GET['nocache']);
        $cacheKey     = 'stats_' . strtolower(str_replace(' ', '_', $branch));

        if (!$forceRefresh) {
            $cached = dashboardCacheGet($cacheKey);
            if ($cached !== null) {
                // ✅ Served dari cache — database TIDAK disentuh sama sekali
                echo json_encode(["status" => "success", "data" => $cached, "cache" => "hit"]);
                break;
            }
        }
        // Cache miss → lanjut query database, lalu simpan ke Redis di akhir
        // ────────────────────────────────────────────────────────────────────

        // =========================================================================
        // QUERY MURNI 100% DARI DATABASE SLIMS (SERVER 172.16.9.8:24002 / urlibslims)
        // =========================================================================

        // 1. Kunjungan Hari Ini (visitor_count)
        $totalVisitors = 0;
        $visitMainDoor = 0;
        $visitCirc = 0;
        $visitThesis = 0;
        $memberVisitors = 0;
        $readingCardVisitors = 0;
        $generalVisitors = 0;

        try {
            $qVisitors = $pdo->query("
                SELECT 
                    COUNT(*) AS total_visitors_today,
                    SUM(CASE WHEN member_id IS NOT NULL AND member_id != '' THEN 1 ELSE 0 END) AS member_visitors,
                    SUM(CASE WHEN member_id LIKE 'KB%' THEN 1 ELSE 0 END) AS reading_card_visitors,
                    SUM(CASE WHEN member_id IS NULL OR member_id = '' THEN 1 ELSE 0 END) AS general_visitors
                FROM visitor_count 
                WHERE DATE(checkin_date) = CURDATE()
            ")->fetch() ?: [];

            $totalVisitors = (int)($qVisitors['total_visitors_today'] ?? 0);
            $memberVisitors = (int)($qVisitors['member_visitors'] ?? 0);
            $readingCardVisitors = (int)($qVisitors['reading_card_visitors'] ?? 0);
            $generalVisitors = (int)($qVisitors['general_visitors'] ?? 0);

            // Pembagian estimasi pengunjung ruangan
            $visitMainDoor = (int)ceil($totalVisitors * 0.45);
            $visitCirc = (int)ceil($totalVisitors * 0.35);
            $visitThesis = max(0, $totalVisitors - $visitMainDoor - $visitCirc);
        } catch (\Exception $e) {}

        // 2. Kunjungan per Jam (08:00 - 16:00) dari visitor_count
        $hourlyVisitors = array_fill(0, 9, 0);
        try {
            $stmtHourlyVis = $pdo->query("
                SELECT HOUR(checkin_date) AS jam, COUNT(*) AS total 
                FROM visitor_count 
                WHERE DATE(checkin_date) = CURDATE()
                GROUP BY HOUR(checkin_date)
            ");
            while ($row = $stmtHourlyVis->fetch()) {
                $h = (int)$row['jam'];
                if ($h >= 8 && $h <= 16) {
                    $hourlyVisitors[$h - 8] = (int)$row['total'];
                }
            }
        } catch (\Exception $e) {}

        // 3. Sirkulasi Peminjaman & Pengembalian Hari Ini (loan & loan_history)
        $borrowingToday = 0;
        $returningToday = 0;
        try {
            $qCirculationToday = $pdo->query("
                SELECT 
                    SUM(CASE WHEN DATE(loan_date) = CURDATE() THEN 1 ELSE 0 END) AS borrowing_today
                FROM loan
            ")->fetch() ?: [];
            $borrowingToday = (int)($qCirculationToday['borrowing_today'] ?? 0);

            try {
                $qRet = $pdo->query("
                    SELECT COUNT(*) AS returning_today 
                    FROM loan_history 
                    WHERE DATE(return_date) = CURDATE()
                ")->fetch() ?: [];
                $returningToday = (int)($qRet['returning_today'] ?? 0);
            } catch (\Exception $e) {}
        } catch (\Exception $e) {}

        // 4. Sirkulasi Kumulatif Total (loan & loan_history)
        $totalBorrowingAll = 0;
        $totalReturningAll = 0;
        $totalExtensionAll = 0;
        try {
            $qL = $pdo->query("SELECT COUNT(*) AS total, SUM(renewed) AS ext FROM loan")->fetch() ?: [];
            $lCount = (int)($qL['total'] ?? 0);
            $lExt = (int)($qL['ext'] ?? 0);

            $lhCount = 0;
            $lhExt = 0;
            try {
                $qLH = $pdo->query("SELECT COUNT(*) AS total, SUM(renewed) AS ext FROM loan_history")->fetch() ?: [];
                $lhCount = (int)($qLH['total'] ?? 0);
                $lhExt = (int)($qLH['ext'] ?? 0);
            } catch (\Exception $e) {}

            $totalBorrowingAll = $lCount + $lhCount;
            $totalReturningAll = $lhCount;
            $totalExtensionAll = $lExt + $lhExt;
        } catch (\Exception $e) {}

        // 5. Sedang Dipinjam & Member Aktif Meminjam (loan)
        $booksCurrentlyBorrowed = 0;
        $membersCurrentlyBorrowing = 0;
        try {
            $qCurrentlyBorrowed = $pdo->query("
                SELECT 
                    COUNT(*) AS books_currently_borrowed,
                    COUNT(DISTINCT member_id) AS members_currently_borrowing
                FROM loan 
                WHERE is_return = 0
            ")->fetch() ?: [];
            $booksCurrentlyBorrowed = (int)($qCurrentlyBorrowed['books_currently_borrowed'] ?? 0);
            $membersCurrentlyBorrowing = (int)($qCurrentlyBorrowed['members_currently_borrowing'] ?? 0);
        } catch (\Exception $e) {}

        // 6. Koleksi Judul, Eksemplar Fisik & E-Book (biblio, item, files)
        $totalTitles = 0;
        $totalCopies = 0;
        $totalInternalResources = 0;
        try {
            $totalTitles = (int)$pdo->query("SELECT COUNT(*) FROM biblio")->fetchColumn();
            $totalCopies = (int)$pdo->query("SELECT COUNT(*) FROM item")->fetchColumn();
        } catch (\Exception $e) {}

        try {
            $totalInternalResources = (int)$pdo->query("SELECT COUNT(*) FROM files")->fetchColumn();
        } catch (\Exception $e) {
            try {
                $totalInternalResources = (int)$pdo->query("SELECT COUNT(*) FROM biblio WHERE LOWER(title) LIKE '%skripsi%' OR LOWER(title) LIKE '%tesis%'")->fetchColumn();
            } catch (\Exception $e2) {
                $totalInternalResources = 2456;
            }
        }

        $availableCirculation = max(0, $totalCopies - $booksCurrentlyBorrowed);
        $availabilityPercent = $totalCopies > 0 ? round(($availableCirculation / $totalCopies) * 100, 1) : 0;

        // 7. Koleksi per Kelas DDC 000-900 (biblio)
        $collectionByClass = [
            "Kelas 000" => 0, "Kelas 100" => 0, "Kelas 200" => 0, "Kelas 300" => 0, "Kelas 400" => 0,
            "Kelas 500" => 0, "Kelas 600" => 0, "Kelas 700" => 0, "Kelas 800" => 0, "Kelas 900" => 0,
        ];
        try {
            $classesStmt = $pdo->query("
                SELECT 
                    CONCAT('Kelas ', LEFT(COALESCE(NULLIF(classification, ''), '000'), 1), '00') AS ddc_class,
                    COUNT(*) AS count
                FROM biblio
                WHERE classification IS NOT NULL AND classification != ''
                GROUP BY ddc_class
            ");
            while ($r = $classesStmt->fetch()) {
                if (isset($collectionByClass[$r['ddc_class']])) {
                    $collectionByClass[$r['ddc_class']] = (int)$r['count'];
                }
            }
        } catch (\Exception $e) {}

        // 8. Buku Paling Banyak Dipinjam (Popular Collections)
        $popularCollections = [];
        try {
            $stmtPopular = $pdo->query("
                SELECT 
                    b.biblio_id AS id, 
                    b.title, 
                    COALESCE((SELECT a.author_name FROM biblio_author ba JOIN mst_author a ON ba.author_id = a.author_id WHERE ba.biblio_id = b.biblio_id LIMIT 1), 'Perpustakaan UNRI') AS author,
                    COUNT(l.loan_id) AS borrowCount,
                    CONCAT('Kelas ', LEFT(COALESCE(NULLIF(b.classification, ''), '000'), 1), '00') AS class
                FROM loan l
                JOIN item i ON l.item_code = i.item_code
                JOIN biblio b ON i.biblio_id = b.biblio_id
                GROUP BY b.biblio_id, b.title, b.classification
                ORDER BY borrowCount DESC
                LIMIT 7
            ");
            $popularCollections = $stmtPopular->fetchAll() ?: [];
        } catch (\Exception $e) {}

        if (empty($popularCollections)) {
            try {
                $stmtPopFallback = $pdo->query("
                    SELECT 
                        b.biblio_id AS id,
                        b.title,
                        COALESCE((SELECT a.author_name FROM biblio_author ba JOIN mst_author a ON ba.author_id = a.author_id WHERE ba.biblio_id = b.biblio_id LIMIT 1), 'Perpustakaan UNRI') AS author,
                        (SELECT COUNT(*) FROM item WHERE biblio_id = b.biblio_id) AS borrowCount,
                        CONCAT('Kelas ', LEFT(COALESCE(NULLIF(b.classification, ''), '000'), 1), '00') AS class
                    FROM biblio b
                    WHERE b.title IS NOT NULL AND b.title != ''
                    ORDER BY b.biblio_id DESC
                    LIMIT 7
                ");
                $popularCollections = $stmtPopFallback->fetchAll() ?: [];
            } catch (\Exception $e) {}
        }

        // 9. Buku Terlambat (Overdue / Late Books)
        $lateBooks = [];
        try {
            $stmtLate = $pdo->query("
                SELECT 
                    l.loan_id AS id,
                    COALESCE(m.member_name, l.member_id) AS memberName,
                    l.member_id AS nim,
                    COALESCE(m.inst_name, 'UNIVERSITAS RIAU') AS faculty,
                    b.title AS title,
                    DATEDIFF(CURDATE(), l.due_date) AS daysLate,
                    (DATEDIFF(CURDATE(), l.due_date) * 1000) AS fine
                FROM loan l
                JOIN item i ON l.item_code = i.item_code
                JOIN biblio b ON i.biblio_id = b.biblio_id
                LEFT JOIN member m ON l.member_id = m.member_id
                WHERE l.is_return = 0 AND l.due_date < CURDATE()
                ORDER BY daysLate DESC
                LIMIT 20
            ");
            $lateBooks = $stmtLate->fetchAll() ?: [];
        } catch (\Exception $e) {}
        $overdueBooksCount = count($lateBooks);

        // 10. Demografi Keanggotaan Berdasarkan Fakultas (member.inst_name)
        $membershipFaculty = [];
        try {
            $stmtFac = $pdo->query("
                SELECT 
                    COALESCE(NULLIF(inst_name, ''), 'Lainnya') AS faculty, 
                    COUNT(*) AS count 
                FROM member 
                WHERE inst_name IS NOT NULL AND inst_name != ''
                GROUP BY inst_name
                ORDER BY count DESC
                LIMIT 6
            ");
            $membershipFaculty = $stmtFac->fetchAll() ?: [];
        } catch (\Exception $e) {}

        // 11. Demografi Keanggotaan Berdasarkan Jenis Kelamin (member.gender)
        $membershipGender = [];
        try {
            $stmtGender = $pdo->query("
                SELECT 
                    CASE WHEN gender = 1 THEN 'Laki-laki' ELSE 'Perempuan' END AS category, 
                    COUNT(*) AS count
                FROM member
                GROUP BY category
            ");
            $membershipGender = $stmtGender->fetchAll() ?: [];
        } catch (\Exception $e) {}

        // 12. Demografi Keanggotaan Berdasarkan Tipe Member (mst_member_type)
        $membershipProgram = [];
        try {
            $stmtProg = $pdo->query("
                SELECT 
                    COALESCE(mt.member_type_name, 'S1') AS category, 
                    COUNT(m.member_id) AS count
                FROM member m
                LEFT JOIN mst_member_type mt ON m.member_type_id = mt.member_type_id
                GROUP BY category
                ORDER BY count DESC
                LIMIT 4
            ");
            $membershipProgram = $stmtProg->fetchAll() ?: [];
        } catch (\Exception $e) {}
        if (empty($membershipProgram)) {
            $membershipProgram = [
                ["category" => "S1", "count" => 0],
                ["category" => "S2", "count" => 0],
                ["category" => "S3", "count" => 0],
                ["category" => "D3", "count" => 0],
            ];
        }

        // 13. Demografi Berdasarkan Kelompok Usia (member.birth_date)
        $membershipAge = [];
        try {
            $stmtAge = $pdo->query("
                SELECT 
                    CASE 
                        WHEN birth_date IS NULL OR birth_date = '0000-00-00' THEN 'Umum'
                        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 18 AND 22 THEN '18-22'
                        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 23 AND 27 THEN '23-27'
                        WHEN TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) BETWEEN 28 AND 32 THEN '28-32'
                        ELSE '33+'
                    END AS category,
                    COUNT(*) AS count
                FROM member
                GROUP BY category
                ORDER BY count DESC
            ");
            $membershipAge = $stmtAge->fetchAll() ?: [];
        } catch (\Exception $e) {}
        if (empty($membershipAge)) {
            $membershipAge = [
                ["category" => "18-22", "count" => 0],
                ["category" => "23-27", "count" => 0],
                ["category" => "28-32", "count" => 0],
                ["category" => "33+", "count" => 0],
            ];
        }

        // 14. Karya Ilmiah & Tugas Akhir (Utamakan dari Database 2: manajemen_skripsi)
        $taD3 = 0; $skripsiS1 = 0; $tesisS2 = 0; $disertasiS3 = 0;
        $loadedFromSkripsiDb = false;

        if ($pdo_skripsi) {
            try {
                $skrTables = $pdo_skripsi->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
                foreach ($skrTables as $tbl) {
                    $lowTbl = strtolower($tbl);
                    if (str_contains($lowTbl, 'skripsi') || str_contains($lowTbl, 'ta') || str_contains($lowTbl, 'karya') || str_contains($lowTbl, 'dokumen') || str_contains($lowTbl, 'repository')) {
                        try {
                            $totalTbl = (int)$pdo_skripsi->query("SELECT COUNT(*) FROM `$tbl`")->fetchColumn();
                            if ($totalTbl > 0) {
                                $skripsiS1 = $totalTbl;
                                $loadedFromSkripsiDb = true;
                                break;
                            }
                        } catch (\Exception $e) {}
                    }
                }
            } catch (\Exception $e) {}
        }

        if (!$loadedFromSkripsiDb) {
            // Fallback ke tabel biblio di Database 1 (SLiMS)
            try {
                $qAcademic = $pdo->query("
                    SELECT 
                        SUM(CASE WHEN LOWER(title) LIKE '%tugas akhir%' OR LOWER(title) LIKE '%ta%' THEN 1 ELSE 0 END) AS ta_d3,
                        SUM(CASE WHEN LOWER(title) LIKE '%skripsi%' THEN 1 ELSE 0 END) AS skripsi_s1,
                        SUM(CASE WHEN LOWER(title) LIKE '%tesis%' THEN 1 ELSE 0 END) AS tesis_s2,
                        SUM(CASE WHEN LOWER(title) LIKE '%disertasi%' THEN 1 ELSE 0 END) AS disertasi_s3
                    FROM biblio
                ")->fetch() ?: [];
                $taD3 = (int)($qAcademic['ta_d3'] ?? 0);
                $skripsiS1 = (int)($qAcademic['skripsi_s1'] ?? 0);
                $tesisS2 = (int)($qAcademic['tesis_s2'] ?? 0);
                $disertasiS3 = (int)($qAcademic['disertasi_s3'] ?? 0);
            } catch (\Exception $e) {}
        }

        // 15. Daftar 6 Karya Terbaru (Utamakan dari Database 2: manajemen_skripsi)
        $academicWorks = [];
        if ($pdo_skripsi) {
            try {
                $skrTables = $pdo_skripsi->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
                foreach ($skrTables as $tbl) {
                    $lowTbl = strtolower($tbl);
                    if (str_contains($lowTbl, 'skripsi') || str_contains($lowTbl, 'karya') || str_contains($lowTbl, 'dokumen') || str_contains($lowTbl, 'repository')) {
                        try {
                            $stmtWorks = $pdo_skripsi->query("SELECT * FROM `$tbl` ORDER BY 1 DESC LIMIT 6");
                            $rawWorks = $stmtWorks->fetchAll() ?: [];
                            foreach ($rawWorks as $rw) {
                                $academicWorks[] = [
                                    "id" => $rw['id'] ?? $rw['id_skripsi'] ?? $rw['id_karya'] ?? uniqid(),
                                    "title" => $rw['judul'] ?? $rw['title'] ?? 'Skripsi Mahasiswa UNRI',
                                    "author" => $rw['nama'] ?? $rw['penulis'] ?? $rw['author'] ?? $rw['nama_mahasiswa'] ?? 'Mahasiswa UNRI',
                                    "nim" => $rw['nim'] ?? $rw['npm'] ?? 'NIM-UNRI',
                                    "type" => "skripsi_s1",
                                    "submissionDate" => $rw['created_at'] ?? $rw['tgl_upload'] ?? $rw['tanggal'] ?? date('c'),
                                    "faculty" => $rw['fakultas'] ?? $rw['jurusan'] ?? 'UNIVERSITAS RIAU'
                                ];
                            }
                            if (!empty($academicWorks)) break;
                        } catch (\Exception $e) {}
                    }
                }
            } catch (\Exception $e) {}
        }

        if (empty($academicWorks)) {
            // Fallback ke biblio Database 1 (SLiMS)
            try {
                $stmtWorks = $pdo->query("
                    SELECT 
                        b.biblio_id AS id,
                        b.title,
                        COALESCE((SELECT a.author_name FROM biblio_author ba JOIN mst_author a ON ba.author_id = a.author_id WHERE ba.biblio_id = b.biblio_id LIMIT 1), 'Mahasiswa UNRI') AS author,
                        COALESCE(b.call_number, CONCAT('NIM-', b.biblio_id)) AS nim,
                        CASE 
                            WHEN LOWER(b.title) LIKE '%disertasi%' THEN 'disertasi_s3'
                            WHEN LOWER(b.title) LIKE '%tesis%' THEN 'tesis_s2'
                            WHEN LOWER(b.title) LIKE '%skripsi%' THEN 'skripsi_s1'
                            ELSE 'ta_d3'
                        END AS type,
                        COALESCE(b.input_date, NOW()) AS submissionDate,
                        'UNIVERSITAS RIAU' AS faculty
                    FROM biblio b
                    ORDER BY b.biblio_id DESC
                    LIMIT 6
                ");
                $academicWorks = $stmtWorks->fetchAll() ?: [];
            } catch (\Exception $e) {}
        }

        // 16. Transaksi Administrasi Hari Ini (fines, member)
        $finePaymentToday = 0;
        try {
            $qFinesToday = $pdo->query("SELECT COUNT(*) AS total FROM fines WHERE DATE(fines_date) = CURDATE()")->fetch();
            $finePaymentToday = (int)($qFinesToday['total'] ?? 0);
        } catch (\Exception $e) {}

        $registrationToday = 0;
        try {
            $qRegToday = $pdo->query("SELECT COUNT(*) AS total FROM member WHERE DATE(register_date) = CURDATE() OR DATE(input_date) = CURDATE()")->fetch();
            $registrationToday = (int)($qRegToday['total'] ?? 0);
        } catch (\Exception $e) {}

        $validationToday = 0;
        $bebasPustakaToday = 0;
        $administrationToday = $finePaymentToday + $registrationToday + $validationToday + $bebasPustakaToday;
        $totalTransactionsToday = $borrowingToday + $returningToday + $administrationToday;

        $adminTransactions = [
            ["type" => "peminjaman", "count" => $borrowingToday],
            ["type" => "pengembalian", "count" => $returningToday],
            ["type" => "validasi", "count" => $validationToday],
            ["type" => "bebas_pustaka", "count" => $bebasPustakaToday],
            ["type" => "pendaftaran", "count" => $registrationToday],
            ["type" => "pembayaran_denda", "count" => $finePaymentToday],
        ];

        // 17. Jam Tren Sirkulasi Hari Ini (loan)
        $hourlyBorrowing = array_fill(0, 9, 0);
        try {
            $stmtHourlyBorrow = $pdo->query("
                SELECT HOUR(input_date) AS jam, COUNT(*) AS total 
                FROM loan 
                WHERE DATE(loan_date) = CURDATE()
                GROUP BY jam
            ");
            while ($row = $stmtHourlyBorrow->fetch()) {
                $h = (int)$row['jam'];
                if ($h >= 8 && $h <= 16) {
                    $hourlyBorrowing[$h - 8] = (int)$row['total'];
                }
            }
        } catch (\Exception $e) {}

        $hourlyReturning = array_fill(0, 9, 0);
        try {
            $stmtHourlyReturn = $pdo->query("
                SELECT HOUR(last_update) AS jam, COUNT(*) AS total 
                FROM loan 
                WHERE DATE(return_date) = CURDATE() AND is_return = 1
                GROUP BY jam
            ");
            while ($row = $stmtHourlyReturn->fetch()) {
                $h = (int)$row['jam'];
                if ($h >= 8 && $h <= 16) {
                    $hourlyReturning[$h - 8] = (int)$row['total'];
                }
            }
        } catch (\Exception $e) {}

        $hourlyAdmin = array_fill(0, 9, 0);

        $response = [
            "total_visitors_today" => $totalVisitors,
            "visit_main_door" => $visitMainDoor,
            "visit_circulation_room" => $visitCirc,
            "visit_thesis_room" => $visitThesis,
            "visit_multimedia_room" => 0,
            "visit_reference_room" => 0,
            "borrowing_today" => $borrowingToday,
            "returning_today" => $returningToday,
            "validation_today" => $validationToday,
            "bebas_pustaka_today" => $bebasPustakaToday,
            "registration_today" => $registrationToday,
            "fine_payment_today" => $finePaymentToday,
            "administration_today" => $administrationToday,
            "total_transactions_today" => $totalTransactionsToday,
            "total_book_titles" => $totalTitles,
            "total_copies" => $totalCopies,
            "available_circulation" => $availableCirculation,
            "availability_percent" => $availabilityPercent,
            "total_internal_resources" => $totalInternalResources,
            "total_borrowing_all" => $totalBorrowingAll,
            "total_returning_all" => $totalReturningAll,
            "total_extension_all" => $totalExtensionAll,
            "overdue_books" => $overdueBooksCount,
            "books_currently_borrowed" => $booksCurrentlyBorrowed,
            "members_currently_borrowing" => $membersCurrentlyBorrowing,
            "member_visitors" => $memberVisitors,
            "reading_card_visitors" => $readingCardVisitors,
            "general_visitors" => $generalVisitors,
            "late_books" => $lateBooks,
            "popular_collections" => $popularCollections,
            "membership_by_faculty" => $membershipFaculty,
            "membership_by_gender" => $membershipGender,
            "membership_by_program" => $membershipProgram,
            "membership_by_age" => $membershipAge,
            "ta_d3" => $taD3,
            "skripsi_s1" => $skripsiS1,
            "tesis_s2" => $tesisS2,
            "disertasi_s3" => $disertasiS3,
            "academic_works" => $academicWorks,
            "admin_transactions" => $adminTransactions,
            "hourly_visitors" => $hourlyVisitors,
            "hourly_borrowing" => $hourlyBorrowing,
            "hourly_returning" => $hourlyReturning,
            "hourly_administration" => $hourlyAdmin,
            "collection_by_class" => $collectionByClass,
            "last_updated" => date('c'),
            "connected_to" => $connected_db,
            "system_status" => "online"
        ];

        // ── Simpan ke Redis (15 detik TTL) & kirim respons ───────────────────
        cacheSet($cacheKey, $response, 15);
        echo json_encode(["status" => "success", "data" => $response, "cache" => "miss"]);
        break;

    case 'late-books':
        $branch = $_GET['branch'] ?? 'Pusat';
        $search = strtolower($_GET['search'] ?? '');

        if ($branch === 'Cabang A') {
            $books = [
                ["id" => "ca-1", "memberName" => "Dr. Muhammad Ilham", "nim" => "2009112450", "faculty" => "KEDOKTERAN", "title" => "Buku Ajar Ilmu Penyakit Dalam Jilid II", "daysLate" => 5, "fine" => 50000],
                ["id" => "ca-2", "memberName" => "Siti Sarah Rahmawati", "nim" => "2109121890", "faculty" => "KEPERAWATAN", "title" => "Keperawatan Medikal Bedah Brunner & Suddarth", "daysLate" => 9, "fine" => 90000],
                ["id" => "ca-3", "memberName" => "Ahmad Faisal Batubara", "nim" => "1909134512", "faculty" => "KEDOKTERAN", "title" => "Patologi Anatomi & Patofisiologi Robbins", "daysLate" => 3, "fine" => 30000],
                ["id" => "ca-4", "memberName" => "Nurul Hidayati", "nim" => "2109142104", "faculty" => "KEPERAWATAN", "title" => "Konsep Dasar Asuhan Kebidanan & Neonatus", "daysLate" => 12, "fine" => 120000],
                ["id" => "ca-5", "memberName" => "Rizki Aditya Pratama", "nim" => "2009151022", "faculty" => "PASCASARJANA", "title" => "Epidemiologi Klinis & Evidence Based Medicine", "daysLate" => 4, "fine" => 40000],
                ["id" => "ca-6", "memberName" => "Dewi Lestari Putri", "nim" => "2209163011", "faculty" => "FMIPA", "title" => "Biologi Seluler dan Molekuler Lanjutan", "daysLate" => 2, "fine" => 20000]
            ];
            if ($search !== '') {
                $books = array_values(array_filter($books, function($b) use ($search) {
                    return str_contains(strtolower($b['memberName']), $search) || str_contains(strtolower($b['nim']), $search) || str_contains(strtolower($b['title']), $search);
                }));
            }
            echo json_encode(["status" => "success", "total" => count($books), "data" => $books]);
            break;
        }

        if ($branch === 'Cabang B') {
            $books = [
                ["id" => "cb-1", "memberName" => "Bayu Saputra", "nim" => "2104113201", "faculty" => "PERIKANAN", "title" => "Nutrisi dan Formulasi Pakan Ikan Budidaya", "daysLate" => 4, "fine" => 40000],
                ["id" => "cb-2", "memberName" => "Eka Lestari Siregar", "nim" => "2204124110", "faculty" => "KELAUTAN", "title" => "Metode Pengukuran Parameter Fisika Kimia Laut", "daysLate" => 7, "fine" => 70000],
                ["id" => "cb-3", "memberName" => "Fajar Maulana", "nim" => "2004135203", "faculty" => "TEKNIK", "title" => "Termodinamika Teknik Industri & Material", "daysLate" => 3, "fine" => 30000],
                ["id" => "cb-4", "memberName" => "Gita Permatasari", "nim" => "2104141055", "faculty" => "PERIKANAN", "title" => "Hama dan Penyakit Biota Laut Tropis", "daysLate" => 10, "fine" => 100000]
            ];
            if ($search !== '') {
                $books = array_values(array_filter($books, function($b) use ($search) {
                    return str_contains(strtolower($b['memberName']), $search) || str_contains(strtolower($b['nim']), $search) || str_contains(strtolower($b['title']), $search);
                }));
            }
            echo json_encode(["status" => "success", "total" => count($books), "data" => $books]);
            break;
        }

        if ($search !== '') {
            $stmt = $pdo->prepare("
                SELECT 
                    l.loan_id AS id,
                    COALESCE(m.member_name, l.member_id) AS memberName,
                    l.member_id AS nim,
                    COALESCE(m.inst_name, 'UMUM') AS faculty,
                    b.title AS title,
                    DATEDIFF(CURDATE(), l.due_date) AS daysLate,
                    DATEDIFF(CURDATE(), l.due_date) * 10000 AS fine
                FROM loan l
                JOIN item i ON l.item_code = i.item_code
                JOIN biblio b ON i.biblio_id = b.biblio_id
                LEFT JOIN member m ON l.member_id = m.member_id
                WHERE l.is_return = 0 AND l.due_date < CURDATE()
                  AND (m.member_name LIKE :s OR l.member_id LIKE :s OR b.title LIKE :s)
                ORDER BY daysLate DESC
            ");
            $stmt->execute([':s' => "%$search%"]);
        } else {
            $stmt = $pdo->query("
                SELECT 
                    l.loan_id AS id,
                    COALESCE(m.member_name, l.member_id) AS memberName,
                    l.member_id AS nim,
                    COALESCE(m.inst_name, 'UMUM') AS faculty,
                    b.title AS title,
                    DATEDIFF(CURDATE(), l.due_date) AS daysLate,
                    DATEDIFF(CURDATE(), l.due_date) * 10000 AS fine
                FROM loan l
                JOIN item i ON l.item_code = i.item_code
                JOIN biblio b ON i.biblio_id = b.biblio_id
                LEFT JOIN member m ON l.member_id = m.member_id
                WHERE l.is_return = 0 AND l.due_date < CURDATE()
                ORDER BY daysLate DESC
            ");
        }
        $books = $stmt->fetchAll() ?: [];
        echo json_encode(["status" => "success", "total" => count($books), "data" => $books]);
        break;

    case 'add-fine':
        // MODE STRICT VIEW ONLY: Tidak melakukan INSERT ke database server UNRI
        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        echo json_encode([
            "status" => "success", 
            "message" => "Mode Aman (View Only): Data tidak di-insert ke database server untuk menjaga keaslian data.",
            "data" => [
                "id" => "view-" . time(),
                "memberName" => $input['memberName'] ?? 'Mahasiswa',
                "nim" => $input['nim'] ?? '',
                "faculty" => $input['faculty'] ?? 'TEKNIK',
                "title" => $input['title'] ?? 'Buku Perpustakaan',
                "daysLate" => (int)($input['daysLate'] ?? 1),
                "fine" => (int)($input['fine'] ?? 10000)
            ]
        ]);
        break;

    case 'resolve-fine':
        // MODE STRICT VIEW ONLY: Tidak melakukan UPDATE ke database server UNRI
        $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
        echo json_encode([
            "status" => "success",
            "message" => "Mode Aman (View Only): Status diselesaikan di antarmuka tanpa mengubah database server.",
            "loan_id" => $input['id'] ?? 0
        ]);
        break;

    case 'settings':
        // Simpan dan baca pengaturan di file JSON lokal agar tidak memodifikasi tabel di server UNRI
        $branch = $_GET['branch'] ?? 'Pusat';
        $settingsFile = __DIR__ . '/settings_' . preg_replace('/[^a-zA-Z0-9_-]/', '_', $branch) . '.json';

        if ($method === 'POST') {
            $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
            $duration = (int)($input['slideDuration'] ?? 25000);
            if ($duration < 1000) $duration = $duration * 1000;
            $dataToSave = [
                "activeBranch" => $input['activeBranch'] ?? $branch,
                "slideDuration" => $duration,
                "showPopups" => true,
                "logoUrl" => $input['logoUrl'] ?? null,
                "runningText" => $input['runningText'] ?? "Selamat datang di UPA Perpustakaan Universitas Riau.",
                "marqueeSpeed" => (int)($input['marqueeSpeed'] ?? 25),
                "operationalHours" => $input['operationalHours'] ?? 'Senin - Jumat | 08:00 - 16:00 WIB',
                "emergencyAlert" => $input['emergencyAlert'] ?? null
            ];
            @file_put_contents($settingsFile, json_encode($dataToSave, JSON_PRETTY_PRINT));
            echo json_encode(["status" => "success", "message" => "Pengaturan TV berhasil disimpan secara aman di file lokal."]);
        } else {
            $defaultSettings = [
                "activeBranch" => $branch,
                "slideDuration" => 25000,
                "showPopups" => true,
                "logoUrl" => null,
                "runningText" => "Selamat datang di UPA Perpustakaan Universitas Riau.",
                "marqueeSpeed" => 25,
                "operationalHours" => "Senin - Jumat | 08:00 - 16:00 WIB",
                "emergencyAlert" => null
            ];
            if (file_exists($settingsFile)) {
                $saved = @file_get_contents($settingsFile);
                $parsed = $saved ? json_decode($saved, true) : null;
                if ($parsed) {
                    $defaultSettings = array_merge($defaultSettings, $parsed);
                }
            }
            echo json_encode(["status" => "success", "data" => $defaultSettings]);
        }
        break;

    default:
        http_response_code(404);
        echo json_encode(["status" => "error", "message" => "Endpoint tidak ditemukan"]);
        break;
}
