-- ================================================================
-- UPA PERPUSTAKAAN UNRI - SUPABASE SCHEMA FINAL
-- Cocok dengan useLibraryStore.ts (kolom 'data' JSONB)
-- ================================================================
-- Halaman yang dicakup:
--   ✅ Ringkasan Admin       → stats.total_visitors_today, borrowing_today, returning_today
--   ✅ Konfigurasi Layar TV  → library_settings (branch, runningText, marqueeSpeed, dll)
--   ✅ Manajemen Data        → library_stats (override total_visitors_today, borrowing_today)
--   ✅ Sirkulasi & Denda     → stats.late_books[] (memberName, nim, faculty, title, daysLate, fine)
--
-- CARA PAKAI:
--   1. Buka Supabase Dashboard → SQL Editor → New Query
--   2. Copy-paste seluruh isi file ini
--   3. Klik RUN
-- ================================================================


-- ================================================================
-- LANGKAH 1: HAPUS TABEL LAMA (aman jika belum ada)
-- ================================================================
DROP TABLE IF EXISTS public.library_settings CASCADE;
DROP TABLE IF EXISTS public.library_stats CASCADE;


-- ================================================================
-- TABEL 1: library_settings
-- Dipakai oleh: fetchSettings(), saveSettings()
-- Field yang disimpan di kolom 'data':
--   - activeBranch   : "Pusat" | "Cabang A" | "Cabang B"
--   - slideDuration  : number (ms, contoh: 25000)
--   - showPopups     : boolean
--   - logoUrl        : string | null
--   - runningText    : string
--   - marqueeSpeed   : number
--   - operationalHours: string
--   - emergencyAlert : string | null
-- ================================================================
CREATE TABLE public.library_settings (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch     TEXT NOT NULL UNIQUE,      -- 'Pusat', 'Cabang A', 'Cabang B'
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_library_settings_branch ON public.library_settings (branch);


-- ================================================================
-- TABEL 2: library_stats
-- Dipakai oleh: fetchStats(), saveStats(), updateStatsManually()
-- Field utama yang disimpan di kolom 'data' (sesuai useLibraryStore):
--
--   [Ringkasan Admin - Tab Overview]
--   - total_visitors_today   : number  → ditampilkan di card "Total Kunjungan Hari Ini"
--   - borrowing_today        : number  → ditampilkan di card "Buku Dipinjam Hari Ini"
--   - returning_today        : number  → ditampilkan di card "Buku Dikembalikan"
--
--   [Manajemen Data - Tab Override]
--   - total_visitors_today   : (sama dengan di atas, bisa di-override manual)
--   - borrowing_today        : (sama dengan di atas, bisa di-override manual)
--
--   [Sirkulasi & Denda - Tab Circulation]
--   - late_books[]           : array objek { id, memberName, nim, faculty, title, daysLate, fine }
--   - overdue_books          : number (jumlah total tunggakan)
--
--   [Data Tambahan Lengkap]
--   - visit_main_door, visit_circulation_room, visit_thesis_room
--   - member_visitors, reading_card_visitors, general_visitors
--   - validation_today, bebas_pustaka_today, registration_today
--   - fine_payment_today, administration_today, total_transactions_today
--   - total_book_titles, total_copies, available_circulation
--   - availability_percent, total_internal_resources
--   - popular_collections[], academic_works[], admin_transactions[]
--   - membership_by_faculty[], membership_by_gender[]
--   - membership_by_program[], membership_by_age[]
--   - ta_d3, skripsi_s1, tesis_s2, disertasi_s3
--   - hourly_visitors[], hourly_borrowing[], hourly_returning[], hourly_administration[]
--   - collection_by_class: { "Kelas 000": N, ... }
--   - total_borrowing_all, total_returning_all, total_extension_all
--   - books_currently_borrowed, members_currently_borrowing
--   - last_updated, system_status
-- ================================================================
CREATE TABLE public.library_stats (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch     TEXT NOT NULL UNIQUE,      -- 'Pusat', 'Cabang A', 'Cabang B'
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_library_stats_branch ON public.library_stats (branch);
CREATE INDEX idx_library_stats_data   ON public.library_stats USING GIN (data);


-- ================================================================
-- LANGKAH 2: ROW LEVEL SECURITY (RLS)
-- SELECT = publik (layar TV tidak login)
-- ALL    = hanya admin yang sudah login
-- ================================================================
ALTER TABLE public.library_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.library_stats    ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_select_settings" ON public.library_settings
  FOR SELECT USING (true);

CREATE POLICY "public_select_stats" ON public.library_stats
  FOR SELECT USING (true);

CREATE POLICY "auth_all_settings" ON public.library_settings
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "auth_all_stats" ON public.library_stats
  FOR ALL USING (auth.role() = 'authenticated');


-- ================================================================
-- LANGKAH 3: TRIGGER auto-update kolom updated_at
-- ================================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_settings_updated_at
  BEFORE UPDATE ON public.library_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trg_stats_updated_at
  BEFORE UPDATE ON public.library_stats
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- ================================================================
-- LANGKAH 4: DATA AWAL (SEED)
-- Settings 3 Branch → sesuai Tab "Konfigurasi Layar TV"
-- ================================================================
INSERT INTO public.library_settings (branch, data) VALUES

('Pusat', '{
  "activeBranch": "Pusat",
  "slideDuration": 25000,
  "showPopups": true,
  "logoUrl": null,
  "runningText": "Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.",
  "marqueeSpeed": 25,
  "operationalHours": "Senin - Jumat | 08:00 - 16:00 WIB",
  "emergencyAlert": null
}'::jsonb),

('Cabang A', '{
  "activeBranch": "Cabang A",
  "slideDuration": 25000,
  "showPopups": true,
  "logoUrl": null,
  "runningText": "Selamat datang di Perpustakaan Cabang A Universitas Riau.",
  "marqueeSpeed": 25,
  "operationalHours": "Senin - Jumat | 08:00 - 16:00 WIB",
  "emergencyAlert": null
}'::jsonb),

('Cabang B', '{
  "activeBranch": "Cabang B",
  "slideDuration": 25000,
  "showPopups": true,
  "logoUrl": null,
  "runningText": "Selamat datang di Perpustakaan Cabang B Universitas Riau.",
  "marqueeSpeed": 25,
  "operationalHours": "Senin - Jumat | 08:00 - 16:00 WIB",
  "emergencyAlert": null
}'::jsonb);


-- ================================================================
-- LANGKAH 5: DATA AWAL (SEED)
-- Stats Branch Pusat → sesuai semua Tab CMS + TV Dashboard
-- ================================================================
INSERT INTO public.library_stats (branch, data) VALUES

('Pusat', '{
  "total_visitors_today": 416,
  "visit_main_door": 0,
  "visit_circulation_room": 0,
  "visit_thesis_room": 0,
  "member_visitors": 396,
  "reading_card_visitors": 0,
  "general_visitors": 1,

  "borrowing_today": 140,
  "returning_today": 158,
  "validation_today": 12,
  "bebas_pustaka_today": 8,
  "registration_today": 5,
  "fine_payment_today": 15,
  "administration_today": 115,
  "total_transactions_today": 413,

  "total_book_titles": 39815,
  "total_copies": 134668,
  "available_circulation": 133977,
  "availability_percent": 99.5,
  "total_internal_resources": 2456,

  "popular_collections": [
    {"id": "1", "title": "Pemrograman Web Modern",     "author": "Adi Nugroho",      "borrowCount": 245, "class": "Kelas 000"},
    {"id": "2", "title": "Database Design",            "author": "C.J. Date",        "borrowCount": 198, "class": "Kelas 000"},
    {"id": "3", "title": "Algoritma & Struktur Data",  "author": "Sedgewick",        "borrowCount": 187, "class": "Kelas 300"},
    {"id": "4", "title": "Clean Code",                 "author": "Robert C. Martin", "borrowCount": 156, "class": "Kelas 600"},
    {"id": "5", "title": "Desain Basis Data",          "author": "Connolly",         "borrowCount": 142, "class": "Kelas 000"},
    {"id": "6", "title": "Jaringan Komputer",          "author": "Kurose",           "borrowCount": 130, "class": "Kelas 000"},
    {"id": "7", "title": "Rekayasa Perangkat Lunak",   "author": "Pressman",         "borrowCount": 115, "class": "Kelas 600"}
  ],

  "total_borrowing_all": 392605,
  "total_returning_all": 391916,
  "total_extension_all": 14502,
  "books_currently_borrowed": 689,
  "members_currently_borrowing": 396,
  "overdue_books": 12,

  "late_books": [
    {"id": "lb-001", "memberName": "Mido Herdiansyah",  "nim": "147382341", "faculty": "HUKUM",   "title": "FISIKA",                    "daysLate": 4,  "fine": 2000000},
    {"id": "lb-002", "memberName": "Budi Santoso",      "nim": "21102001",  "faculty": "FMIPA",   "title": "Pemrograman Java",           "daysLate": 7,  "fine": 700000},
    {"id": "lb-003", "memberName": "Siti Nurhaliza",    "nim": "21102002",  "faculty": "TEKNIK",  "title": "Statistika Terapan",         "daysLate": 3,  "fine": 300000},
    {"id": "lb-004", "memberName": "Ahmad Fauzan",      "nim": "21102003",  "faculty": "FMIPA",   "title": "Struktur Data",              "daysLate": 10, "fine": 1000000},
    {"id": "lb-005", "memberName": "Gilang Ramadhan",   "nim": "21102005",  "faculty": "TEKNIK",  "title": "Kecerdasan Buatan",          "daysLate": 5,  "fine": 500000},
    {"id": "lb-006", "memberName": "Dewi Lestari",      "nim": "21102006",  "faculty": "FMIPA",   "title": "Kalkulus Lanjut",            "daysLate": 2,  "fine": 200000},
    {"id": "lb-007", "memberName": "Andi Pratama",      "nim": "21103001",  "faculty": "FE",      "title": "Ekonomi Makro",              "daysLate": 8,  "fine": 800000},
    {"id": "lb-008", "memberName": "Nadia Vega",        "nim": "21104001",  "faculty": "FKIP",    "title": "Metodologi Penelitian",      "daysLate": 1,  "fine": 100000},
    {"id": "lb-009", "memberName": "Reza Rahadian",     "nim": "21105001",  "faculty": "FISIP",   "title": "Psikologi Komunikasi",       "daysLate": 6,  "fine": 600000},
    {"id": "lb-010", "memberName": "Maya Safira",       "nim": "21106001",  "faculty": "HUKUM",   "title": "Hukum Internasional",        "daysLate": 9,  "fine": 900000},
    {"id": "lb-011", "memberName": "Hendra Wijaya",     "nim": "21107001",  "faculty": "FMIPA",   "title": "Agroekoteknologi",           "daysLate": 12, "fine": 1200000},
    {"id": "lb-012", "memberName": "Indah Permatasari", "nim": "21108001",  "faculty": "TEKNIK",  "title": "Dasar Jaringan Komputer",    "daysLate": 3,  "fine": 300000}
  ],

  "membership_by_faculty": [
    {"faculty": "FAPERTA", "count": 145},
    {"faculty": "FMIPA",   "count": 132},
    {"faculty": "FE",      "count": 98},
    {"faculty": "FH",      "count": 87},
    {"faculty": "FKIP",    "count": 156}
  ],
  "membership_by_gender": [
    {"category": "Laki-laki", "count": 298},
    {"category": "Perempuan", "count": 420}
  ],
  "membership_by_program": [
    {"category": "S1", "count": 485},
    {"category": "S2", "count": 156},
    {"category": "S3", "count": 45},
    {"category": "D3", "count": 32}
  ],
  "membership_by_age": [
    {"category": "18-22", "count": 245},
    {"category": "23-27", "count": 312},
    {"category": "28-32", "count": 124},
    {"category": "33+",   "count": 37}
  ],

  "ta_d3": 2,
  "skripsi_s1": 15,
  "tesis_s2": 3,
  "disertasi_s3": 1,
  "academic_works": [
    {"id": "1", "title": "Pengaruh Algoritma Machine Learning pada Prediksi Cuaca",  "author": "Budi Santoso",      "nim": "21102001", "type": "skripsi_s1",   "submissionDate": "2024-09-01T08:15:00", "faculty": "FMIPA"},
    {"id": "2", "title": "Sistem Informasi Manajemen Perpustakaan",                  "author": "Siti Nurhaliza",    "nim": "21102002", "type": "ta_d3",        "submissionDate": "2024-09-01T09:30:00", "faculty": "TEKNIK"},
    {"id": "3", "title": "Analisis Sentimen Menggunakan NLP",                        "author": "Ahmad Fauzan",      "nim": "21102003", "type": "tesis_s2",     "submissionDate": "2024-09-01T10:45:00", "faculty": "FMIPA"},
    {"id": "4", "title": "Pengembangan Model Deep Learning untuk Diagnosa Medis",    "author": "Dr. Hendra Wijaya", "nim": "21102004", "type": "disertasi_s3", "submissionDate": "2024-09-01T11:20:00", "faculty": "KEDOKTERAN"},
    {"id": "5", "title": "Rancang Bangun Jaringan Sensor Nirkabel",                  "author": "Gilang Ramadhan",   "nim": "21102005", "type": "skripsi_s1",   "submissionDate": "2024-09-01T13:10:00", "faculty": "TEKNIK"},
    {"id": "6", "title": "Optimasi Query pada Database Terdistribusi",               "author": "Dewi Lestari",      "nim": "21102006", "type": "skripsi_s1",   "submissionDate": "2024-09-01T14:05:00", "faculty": "FMIPA"}
  ],

  "admin_transactions": [
    {"type": "peminjaman",       "count": 140},
    {"type": "pengembalian",     "count": 158},
    {"type": "validasi",         "count": 12},
    {"type": "bebas_pustaka",    "count": 8},
    {"type": "pendaftaran",      "count": 5},
    {"type": "pembayaran_denda", "count": 15}
  ],

  "hourly_visitors":       [15, 35, 48, 42, 20, 40, 30, 22, 18],
  "hourly_borrowing":      [8,  18, 25, 20, 10, 18, 15, 12, 10],
  "hourly_returning":      [10, 22, 28, 22, 12, 20, 16, 14, 12],
  "hourly_administration": [5,  12, 18, 15,  8, 14, 12, 10,  8],

  "collection_by_class": {
    "Kelas 000": 6008,
    "Kelas 100": 1152,
    "Kelas 200": 1025,
    "Kelas 300": 12061,
    "Kelas 400": 1167,
    "Kelas 500": 4539,
    "Kelas 600": 10946,
    "Kelas 700": 535,
    "Kelas 800": 1303,
    "Kelas 900": 1073
  },

  "last_updated": "2026-10-20T00:00:00Z",
  "system_status": "online"
}'::jsonb),


-- ================================================================
-- Stats Branch Cabang A (data awal kosong)
-- ================================================================
('Cabang A', '{
  "total_visitors_today": 0,
  "borrowing_today": 0,
  "returning_today": 0,
  "visit_main_door": 0,
  "visit_circulation_room": 0,
  "visit_thesis_room": 0,
  "member_visitors": 0,
  "reading_card_visitors": 0,
  "general_visitors": 0,
  "validation_today": 0,
  "bebas_pustaka_today": 0,
  "registration_today": 0,
  "fine_payment_today": 0,
  "administration_today": 0,
  "total_transactions_today": 0,
  "total_book_titles": 5000,
  "total_copies": 15000,
  "available_circulation": 14900,
  "availability_percent": 99.3,
  "total_internal_resources": 500,
  "popular_collections": [],
  "total_borrowing_all": 0,
  "total_returning_all": 0,
  "total_extension_all": 0,
  "books_currently_borrowed": 0,
  "members_currently_borrowing": 0,
  "overdue_books": 0,
  "late_books": [],
  "membership_by_faculty": [
    {"faculty": "FAPERTA", "count": 50},
    {"faculty": "FMIPA",   "count": 45},
    {"faculty": "FE",      "count": 30}
  ],
  "membership_by_gender": [
    {"category": "Laki-laki", "count": 0},
    {"category": "Perempuan", "count": 0}
  ],
  "membership_by_program": [
    {"category": "S1", "count": 0},
    {"category": "S2", "count": 0},
    {"category": "S3", "count": 0},
    {"category": "D3", "count": 0}
  ],
  "membership_by_age": [
    {"category": "18-22", "count": 0},
    {"category": "23-27", "count": 0},
    {"category": "28-32", "count": 0},
    {"category": "33+",   "count": 0}
  ],
  "ta_d3": 0, "skripsi_s1": 0, "tesis_s2": 0, "disertasi_s3": 0,
  "academic_works": [],
  "admin_transactions": [
    {"type": "peminjaman",       "count": 0},
    {"type": "pengembalian",     "count": 0},
    {"type": "validasi",         "count": 0},
    {"type": "bebas_pustaka",    "count": 0},
    {"type": "pendaftaran",      "count": 0},
    {"type": "pembayaran_denda", "count": 0}
  ],
  "hourly_visitors":       [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_borrowing":      [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_returning":      [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_administration": [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "collection_by_class": {
    "Kelas 000": 800, "Kelas 100": 200, "Kelas 200": 180,
    "Kelas 300": 1500, "Kelas 400": 250, "Kelas 500": 700,
    "Kelas 600": 1200, "Kelas 700": 100, "Kelas 800": 200, "Kelas 900": 150
  },
  "last_updated": "2026-10-20T00:00:00Z",
  "system_status": "online"
}'::jsonb),


-- ================================================================
-- Stats Branch Cabang B (data awal kosong)
-- ================================================================
('Cabang B', '{
  "total_visitors_today": 0,
  "borrowing_today": 0,
  "returning_today": 0,
  "visit_main_door": 0,
  "visit_circulation_room": 0,
  "visit_thesis_room": 0,
  "member_visitors": 0,
  "reading_card_visitors": 0,
  "general_visitors": 0,
  "validation_today": 0,
  "bebas_pustaka_today": 0,
  "registration_today": 0,
  "fine_payment_today": 0,
  "administration_today": 0,
  "total_transactions_today": 0,
  "total_book_titles": 3000,
  "total_copies": 8000,
  "available_circulation": 7950,
  "availability_percent": 99.4,
  "total_internal_resources": 300,
  "popular_collections": [],
  "total_borrowing_all": 0,
  "total_returning_all": 0,
  "total_extension_all": 0,
  "books_currently_borrowed": 0,
  "members_currently_borrowing": 0,
  "overdue_books": 0,
  "late_books": [],
  "membership_by_faculty": [
    {"faculty": "TEKNIK", "count": 60},
    {"faculty": "FISIP",  "count": 40}
  ],
  "membership_by_gender": [
    {"category": "Laki-laki", "count": 0},
    {"category": "Perempuan", "count": 0}
  ],
  "membership_by_program": [
    {"category": "S1", "count": 0},
    {"category": "S2", "count": 0},
    {"category": "S3", "count": 0},
    {"category": "D3", "count": 0}
  ],
  "membership_by_age": [
    {"category": "18-22", "count": 0},
    {"category": "23-27", "count": 0},
    {"category": "28-32", "count": 0},
    {"category": "33+",   "count": 0}
  ],
  "ta_d3": 0, "skripsi_s1": 0, "tesis_s2": 0, "disertasi_s3": 0,
  "academic_works": [],
  "admin_transactions": [
    {"type": "peminjaman",       "count": 0},
    {"type": "pengembalian",     "count": 0},
    {"type": "validasi",         "count": 0},
    {"type": "bebas_pustaka",    "count": 0},
    {"type": "pendaftaran",      "count": 0},
    {"type": "pembayaran_denda", "count": 0}
  ],
  "hourly_visitors":       [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_borrowing":      [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_returning":      [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "hourly_administration": [0, 0, 0, 0, 0, 0, 0, 0, 0],
  "collection_by_class": {
    "Kelas 000": 500, "Kelas 100": 120, "Kelas 200": 100,
    "Kelas 300": 900, "Kelas 400": 150, "Kelas 500": 400,
    "Kelas 600": 700, "Kelas 700": 80, "Kelas 800": 120, "Kelas 900": 100
  },
  "last_updated": "2026-10-20T00:00:00Z",
  "system_status": "online"
}'::jsonb);


-- ================================================================
-- VERIFIKASI (jalankan setelah insert untuk cek hasilnya)
-- ================================================================
-- SELECT branch, updated_at FROM public.library_settings;
-- SELECT branch, updated_at FROM public.library_stats;
-- SELECT branch, jsonb_array_length(data->'late_books') AS jumlah_tunggakan FROM public.library_stats;
