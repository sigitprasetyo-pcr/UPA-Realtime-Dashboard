-- =====================================================================
-- MASTER DATABASE LENGKAP: UPA PERPUSTAKAAN UNIVERSITAS RIAU
-- Database Name: Dashboard_UPA
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `Dashboard_UPA` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `Dashboard_UPA`;

SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------------
-- 1. TABEL PENGGUNA / ADMIN (users)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT 'Administrator',
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'admin',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`) VALUES
(1, 'Admin Perpustakaan UNRI', 'admin@upa.unri.ac.id', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm', 'admin')
ON DUPLICATE KEY UPDATE `email` = VALUES(`email`);

-- -------------------------------------------------------------
-- 2. MASTER FAKULTAS, JURUSAN & JENIS DOKUMEN (Karya Ilmiah)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `fakultas`;
CREATE TABLE `fakultas` (
  `id_fakultas` int(11) NOT NULL AUTO_INCREMENT,
  `fakultas` varchar(50) NOT NULL,
  `keterangan` varchar(100) NOT NULL,
  PRIMARY KEY (`id_fakultas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `fakultas` (`id_fakultas`, `fakultas`, `keterangan`) VALUES
(1, 'FAKULTAS TEKNIK', 'FT UNRI'),
(2, 'FAKULTAS MIPA', 'FMIPA UNRI'),
(3, 'FAKULTAS EKONOMI DAN BISNIS', 'FEB UNRI'),
(4, 'FAKULTAS HUKUM', 'FH UNRI'),
(5, 'FAKULTAS KEDOKTERAN', 'FK UNRI'),
(6, 'FAKULTAS PERTANIAN', 'FP UNRI'),
(7, 'FAKULTAS KEGURUAN DAN ILMU PENDIDIKAN', 'FKIP UNRI'),
(8, 'FAKULTAS ILMU SOSIAL DAN POLITIK', 'FISIP UNRI');

DROP TABLE IF EXISTS `jenis_dokumen`;
CREATE TABLE `jenis_dokumen` (
  `id_jenis_dokumen` int(11) NOT NULL AUTO_INCREMENT,
  `jenis_dokumen` varchar(30) NOT NULL,
  `keterangan_jenis_dokumen` varchar(150) NOT NULL,
  PRIMARY KEY (`id_jenis_dokumen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `jenis_dokumen` (`id_jenis_dokumen`, `jenis_dokumen`, `keterangan_jenis_dokumen`) VALUES
(1, 'Tugas Akhir', 'Tugas Akhir Program Diploma (D3)'),
(2, 'Skripsi', 'Skripsi Program Sarjana (S1)'),
(3, 'Tesis', 'Tesis Program Magister (S2)'),
(4, 'Disertasi', 'Disertasi Program Doktoral (S3)');

DROP TABLE IF EXISTS `jurusan`;
CREATE TABLE `jurusan` (
  `id_jurusan` int(11) NOT NULL AUTO_INCREMENT,
  `id_fakultas` int(11) NOT NULL,
  `jurusan` varchar(150) NOT NULL,
  `keterangan` varchar(150) NOT NULL,
  PRIMARY KEY (`id_jurusan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `jurusan` (`id_jurusan`, `id_fakultas`, `jurusan`, `keterangan`) VALUES
(1, 1, 'Teknik Informatika', 'S1 Teknik Informatika'),
(2, 1, 'Teknik Sipil', 'S1 Teknik Sipil'),
(3, 2, 'Sistem Informasi', 'S1 Sistem Informasi'),
(4, 2, 'Ilmu Komputer', 'D3 Manajemen Informatika'),
(5, 3, 'Manajemen', 'S1 Manajemen'),
(6, 4, 'Ilmu Hukum', 'S1 Ilmu Hukum'),
(7, 5, 'Pendidikan Dokter', 'S2 Biomedis'),
(8, 6, 'Agroteknologi', 'S3 Ilmu Pertanian');

-- -------------------------------------------------------------
-- 3. TABEL SKRIPSI & KARYA ILMIAH
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `skripsi`;
CREATE TABLE `skripsi` (
  `id_skripsi` int(11) NOT NULL AUTO_INCREMENT,
  `id_jenis_dokumen` int(11) NOT NULL,
  `no_surat` varchar(50) DEFAULT NULL,
  `nama` varchar(50) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `id_fakultas` int(11) NOT NULL,
  `id_jurusan` int(11) NOT NULL,
  `judul` text NOT NULL,
  `hard_copy` int(11) NOT NULL DEFAULT 1,
  `soft_copy` int(11) NOT NULL DEFAULT 1,
  `tanggal` varchar(20) NOT NULL,
  PRIMARY KEY (`id_skripsi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `skripsi` (`id_skripsi`, `id_jenis_dokumen`, `no_surat`, `nama`, `nim`, `id_fakultas`, `id_jurusan`, `judul`, `hard_copy`, `soft_copy`, `tanggal`) VALUES
(1, 2, 'SRT/001/2026', 'Rian Hidayat', '2107112001', 1, 1, 'Penerapan Machine Learning untuk Deteksi Kerusakan Jalan di Kota Pekanbaru', 1, 1, '2026-11-08'),
(2, 2, 'SRT/002/2026', 'Nadia Salsabila', '2107113045', 1, 1, 'Rancang Bangun Sistem Informasi Dashboard Perpustakaan Realtime Berbasis React dan Docker', 1, 1, '2026-11-07'),
(3, 1, 'SRT/003/2026', 'Budi Santoso', '2207011022', 2, 4, 'Rancang Bangun Aplikasi Pengarsipan Surat Digital Menggunakan Framework CodeIgniter', 1, 1, '2026-11-06'),
(4, 2, 'SRT/004/2026', 'Putri Ayu Wandira', '2103112089', 2, 3, 'Analisis Sentimen Pengguna Twitter Terhadap Layanan Publik Provinsi Riau Menggunakan Algoritma Naive Bayes', 1, 1, '2026-11-05'),
(5, 3, 'SRT/005/2026', 'dr. Hendra Kurniawan', '1908214002', 5, 7, 'Analisis Faktor Risiko Komplikasi Pasien Diabetes Melitus Tipe 2 di RSUD Arifin Achmad', 1, 1, '2026-11-04'),
(6, 2, 'SRT/006/2026', 'Fajar Pratama', '2102114012', 3, 5, 'Pengaruh Literasi Keuangan dan Digital Payment Terhadap Perilaku Konsumtif Mahasiswa Universitas Riau', 1, 1, '2026-11-03'),
(7, 1, 'SRT/007/2026', 'Dimas Anggara', '2207012015', 2, 4, 'Sistem Monitoring Suhu dan Kelembaban Ruang Server Berbasis Internet of Things (IoT)', 1, 1, '2026-11-02'),
(8, 2, 'SRT/008/2026', 'Siti Rahmawati', '2104113018', 4, 6, 'Perlindungan Hukum Hak Cipta Karya Digital Terhadap Pembajakan di Media Sosial', 1, 1, '2026-11-01'),
(9, 3, 'SRT/009/2026', 'Ir. Wahyu Setiawan, M.T.', '1907212005', 1, 2, 'Model Numerik Perkuatan Struktur Pondasi Jembatan Terhadap Beban Dinamis Gempa', 1, 1, '2026-10-30'),
(10, 4, 'SRT/010/2026', 'Dr. Ir. Ahmad Syahril', '1806311001', 6, 8, 'Optimasi Genetik Tanaman Kelapa Sawit Terhadap Resistensi Penyakit Busuk Pangkal Batang di Lahan Gambut Riau', 1, 1, '2026-10-28');

DROP VIEW IF EXISTS `view_skripsi`;
CREATE VIEW `view_skripsi` AS 
SELECT 
  `s`.`id_skripsi` AS `id_skripsi`,
  `s`.`id_jenis_dokumen` AS `id_jenis_dokumen`,
  `s`.`nama` AS `nama`,
  `s`.`nim` AS `nim`,
  `s`.`id_fakultas` AS `id_fakultas`,
  `s`.`id_jurusan` AS `id_jurusan`,
  `s`.`judul` AS `judul`,
  `s`.`hard_copy` AS `hard_copy`,
  `s`.`soft_copy` AS `soft_copy`,
  `s`.`tanggal` AS `tanggal`,
  `j`.`jurusan` AS `jurusan`,
  `j`.`keterangan` AS `ket_jurusan`,
  `f`.`fakultas` AS `fakultas`,
  `f`.`keterangan` AS `ket_fakultas`,
  `jd`.`jenis_dokumen` AS `jenis_dokumen`
FROM (((`jurusan` `j` join `fakultas` `f` on(`j`.`id_fakultas` = `f`.`id_fakultas`)) 
join `skripsi` `s` on((`s`.`id_fakultas` = `f`.`id_fakultas` and `s`.`id_jurusan` = `j`.`id_jurusan`))) 
join `jenis_dokumen` `jd` on(`s`.`id_jenis_dokumen` = `jd`.`id_jenis_dokumen`));

-- -------------------------------------------------------------
-- 4. TABEL PENGARANG (mst_author & biblio_author)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `mst_author`;
CREATE TABLE `mst_author` (
  `author_id` int(11) NOT NULL AUTO_INCREMENT,
  `author_name` varchar(100) NOT NULL,
  PRIMARY KEY (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `mst_author` (`author_id`, `author_name`) VALUES
(1, 'Prof. Dr. Yusmar Yusuf, M.Phil.'),
(2, 'Dr. H. Hasnah Faizah, M.Hum.'),
(3, 'Ir. H. Syahril, M.S., Ph.D.'),
(4, 'Robert C. Martin'),
(5, 'Andrew S. Tanenbaum'),
(6, 'Donald E. Knuth');

-- -------------------------------------------------------------
-- 5. TABEL KATALOG BUKU (biblio)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `biblio`;
CREATE TABLE `biblio` (
  `biblio_id` int(11) NOT NULL AUTO_INCREMENT,
  `gmd_id` int(11) DEFAULT 1,
  `title` text NOT NULL,
  `classification` varchar(40) DEFAULT NULL,
  `call_number` varchar(50) DEFAULT NULL,
  `publish_year` varchar(20) DEFAULT '2022',
  `language_id` varchar(10) DEFAULT 'id',
  `input_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`biblio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `biblio` (`biblio_id`, `title`, `classification`, `call_number`) VALUES
(1, 'Metodologi Penelitian & Penulisan Ilmiah', '001.42', '001.42 Yus m'),
(2, 'Filsafat Ilmu dan Logika Berpikir', '100', '100 Faiz f'),
(3, 'Pendidikan Karakter & Nilai Moral Islam', '297.7', '297.7 Syah p'),
(4, 'Sosiologi Masyarakat Pesisir dan Perkebunan Riau', '301', '301 Yus s'),
(5, 'Tata Bahasa Baku Bahasa Indonesia', '415', '415 Alw t'),
(6, 'Matematika Diskrit dan Teori Graf', '511', '511 Rinal m'),
(7, 'Teknologi Informasi & Rekayasa Perangkat Lunak', '600', '600 Mart t'),
(8, 'Seni Ukir Tradisional Melayu Riau', '700', '700 Yus s'),
(9, 'Antologi Puisi dan Sastra Melayu Klasik', '899.2', '899.2 Ten a'),
(10, 'Sejarah dan Peradaban Kerajaan Siak Sri Indrapura', '959.8', '959.8 Siak s'),
(11, 'Algoritma Pemrograman Lanjut dengan Python', '005.1', '005.1 Rinal a'),
(12, 'Manajemen Keuangan Syariah Modern', '332', '332 Karim m');

DROP TABLE IF EXISTS `biblio_author`;
CREATE TABLE `biblio_author` (
  `biblio_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL,
  PRIMARY KEY (`biblio_id`, `author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `biblio_author` (`biblio_id`, `author_id`) VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 2), (6, 6), (7, 4), (8, 1), (9, 2), (10, 1), (11, 5), (12, 3);

-- -------------------------------------------------------------
-- 6. TABEL EKSEMPLAR BUKU (item)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `item_code` varchar(50) NOT NULL,
  `biblio_id` int(11) NOT NULL,
  `coll_type_id` int(11) DEFAULT 1,
  `location_id` varchar(20) DEFAULT 'SL',
  `item_status_id` varchar(10) DEFAULT '0',
  `price` int(11) DEFAULT 100000,
  `received_date` date DEFAULT NULL,
  `input_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `item` (`item_code`, `biblio_id`, `received_date`) VALUES
('ITM001', 1, CURDATE()), ('ITM002', 1, CURDATE()),
('ITM003', 2, CURDATE()), ('ITM004', 3, CURDATE()),
('ITM005', 4, CURDATE()), ('ITM006', 5, CURDATE()),
('ITM007', 6, CURDATE()), ('ITM008', 7, CURDATE()),
('ITM009', 8, CURDATE()), ('ITM010', 9, CURDATE()),
('ITM011', 10, CURDATE()), ('ITM012', 11, CURDATE()),
('ITM013', 12, CURDATE());

-- -------------------------------------------------------------
-- 7. TABEL ANGGOTA PERPUSTAKAAN (mst_member_type & member)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `mst_member_type`;
CREATE TABLE `mst_member_type` (
  `member_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_type_name` varchar(50) NOT NULL,
  PRIMARY KEY (`member_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `mst_member_type` (`member_type_id`, `member_type_name`) VALUES
(1, 'S1'), (2, 'S2'), (3, 'S3'), (4, 'D3');

DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `member_id` varchar(50) NOT NULL,
  `member_name` varchar(100) NOT NULL,
  `gender` int(11) NOT NULL DEFAULT 1,
  `birth_date` date DEFAULT NULL,
  `member_type_id` int(11) DEFAULT 1,
  `inst_name` varchar(100) DEFAULT 'FAKULTAS TEKNIK',
  `is_pending` int(11) DEFAULT 0,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `member` (`member_id`, `member_name`, `gender`, `birth_date`, `member_type_id`, `inst_name`) VALUES
('2107112001', 'Rian Hidayat', 1, '2003-05-12', 1, 'FAKULTAS TEKNIK'),
('2107113045', 'Nadia Salsabila', 0, '2003-08-20', 1, 'FAKULTAS TEKNIK'),
('2207011022', 'Budi Santoso', 1, '2004-01-15', 4, 'FAKULTAS MIPA'),
('2103112089', 'Putri Ayu Wandira', 0, '2003-11-28', 1, 'FAKULTAS MIPA'),
('1908214002', 'dr. Hendra Kurniawan', 1, '1995-04-10', 2, 'FAKULTAS KEDOKTERAN'),
('2102114012', 'Fajar Pratama', 1, '2003-07-09', 1, 'FAKULTAS EKONOMI DAN BISNIS'),
('2104113018', 'Siti Rahmawati', 0, '2003-03-22', 1, 'FAKULTAS HUKUM'),
('1806311001', 'Dr. Ir. Ahmad Syahril', 1, '1985-09-17', 3, 'FAKULTAS PERTANIAN');

-- -------------------------------------------------------------
-- 8. TABEL KUNJUNGAN HARI INI (visitor_count)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `visitor_count`;
CREATE TABLE `visitor_count` (
  `visitor_id` int(11) NOT NULL AUTO_INCREMENT,
  `checkin_date` datetime NOT NULL,
  `member_id` varchar(50) DEFAULT NULL,
  `member_name` varchar(100) DEFAULT NULL,
  `institution` varchar(100) DEFAULT 'UNIVERSITAS RIAU',
  PRIMARY KEY (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `visitor_count` (`checkin_date`, `member_id`, `member_name`) VALUES
(CONCAT(CURDATE(), ' 08:15:00'), '2107112001', 'Rian Hidayat'),
(CONCAT(CURDATE(), ' 08:45:00'), '2107113045', 'Nadia Salsabila'),
(CONCAT(CURDATE(), ' 09:10:00'), '2207011022', 'Budi Santoso'),
(CONCAT(CURDATE(), ' 09:30:00'), '2103112089', 'Putri Ayu Wandira'),
(CONCAT(CURDATE(), ' 10:15:00'), '2102114012', 'Fajar Pratama'),
(CONCAT(CURDATE(), ' 10:45:00'), '2104113018', 'Siti Rahmawati'),
(CONCAT(CURDATE(), ' 11:10:00'), 'KB-00124', 'Pengunjung Kartu Baca'),
(CONCAT(CURDATE(), ' 13:20:00'), '2107112001', 'Rian Hidayat'),
(CONCAT(CURDATE(), ' 14:05:00'), '', 'Tamu Umum'),
(CONCAT(CURDATE(), ' 14:40:00'), '2207011022', 'Budi Santoso');

-- -------------------------------------------------------------
-- 9. TABEL PEMINJAMAN & KETERLAMBATAN (loan)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `loan`;
CREATE TABLE `loan` (
  `loan_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(50) NOT NULL,
  `member_id` varchar(50) NOT NULL,
  `loan_date` date NOT NULL,
  `due_date` date NOT NULL,
  `renewed` int(11) DEFAULT 0,
  `is_return` int(11) DEFAULT 0,
  `return_date` date DEFAULT NULL,
  PRIMARY KEY (`loan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_return`) VALUES
('ITM001', '2107112001', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 0),
('ITM002', '2107113045', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 0),
('ITM003', '2207011022', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 0),
('ITM004', '2103112089', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 0);

DROP TABLE IF EXISTS `loan_history`;
CREATE TABLE `loan_history` (
  `loan_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_code` varchar(50) NOT NULL,
  `member_id` varchar(50) NOT NULL,
  `loan_date` date NOT NULL,
  `due_date` date NOT NULL,
  `return_date` date NOT NULL,
  `renewed` int(11) DEFAULT 0,
  PRIMARY KEY (`loan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `loan_history` (`item_code`, `member_id`, `loan_date`, `due_date`, `return_date`) VALUES
('ITM005', '2102114012', DATE_SUB(CURDATE(), INTERVAL 7 DAY), CURDATE(), CURDATE()),
('ITM006', '2104113018', DATE_SUB(CURDATE(), INTERVAL 6 DAY), CURDATE(), CURDATE());

-- -------------------------------------------------------------
-- 10. TABEL DENDA & RESOURCE INTERNAL (fines & files)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `fines`;
CREATE TABLE `fines` (
  `fines_id` int(11) NOT NULL AUTO_INCREMENT,
  `fines_date` date NOT NULL,
  `fines_amount` int(11) NOT NULL DEFAULT 5000,
  `member_id` varchar(50) NOT NULL,
  `description` varchar(200) DEFAULT 'Denda keterlambatan buku',
  PRIMARY KEY (`fines_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `fines` (`fines_date`, `fines_amount`, `member_id`) VALUES
(CURDATE(), 10000, '2207011022'),
(CURDATE(), 5000, '2103112089');

DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `file_title` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  PRIMARY KEY (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `files` (`file_title`, `file_name`) VALUES
('E-Book Statistika Dasar', 'statistika.pdf'),
('Modul Pemrograman Web', 'pemrograman_web.pdf'),
('Jurnal Ilmiah UNRI Vol 1', 'jurnal_vol1.pdf'),
('Pedoman Penulisan Skripsi UNRI', 'pedoman_skripsi.pdf');

SET FOREIGN_KEY_CHECKS = 1;

