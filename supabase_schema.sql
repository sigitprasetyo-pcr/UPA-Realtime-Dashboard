-- ================================================================
-- UPA PERPUSTAKAAN UNRI - SUPABASE SCHEMA
-- Jalankan di: https://supabase.com/dashboard/project/kkjyxjcsrqvxnylqfebv/sql/new
-- ================================================================

-- HAPUS TABEL LAMA (aman jika belum ada)
DROP TABLE IF EXISTS public.membership_by_faculty CASCADE;
DROP TABLE IF EXISTS public.popular_collections CASCADE;
DROP TABLE IF EXISTS public.academic_works CASCADE;
DROP TABLE IF EXISTS public.late_books CASCADE;
DROP TABLE IF EXISTS public.library_stats CASCADE;
DROP TABLE IF EXISTS public.library_settings CASCADE;

-- ================================================================
-- TABEL 1: library_settings
-- Konfigurasi tampilan TV (running text, jam operasional, dll)
-- ================================================================
CREATE TABLE public.library_settings (
  id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch            TEXT NOT NULL UNIQUE,       -- 'Pusat', 'Cabang A', 'Cabang B'
  running_text      TEXT DEFAULT 'Selamat datang di UPA Perpustakaan Universitas Riau.',
  marquee_speed     INT DEFAULT 25,             -- Kecepatan teks berjalan
  operational_hours TEXT DEFAULT 'Senin - Jumat | 08:00 - 16:00 WIB',
  slide_duration    INT DEFAULT 25000,          -- Durasi slide dalam ms
  show_popups       BOOLEAN DEFAULT TRUE,
  logo_url          TEXT,                       -- URL logo (base64 atau URL)
  emergency_alert   TEXT,                       -- Pesan darurat (null = tidak aktif)
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- TABEL 2: library_stats
-- Statistik harian perpustakaan - semua angka yang ditampilkan di TV
-- ================================================================
CREATE TABLE public.library_stats (
  id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch                      TEXT NOT NULL UNIQUE,
  -- Kunjungan harian
  visit_main_door             INT DEFAULT 0,
  visit_circulation_room      INT DEFAULT 0,
  visit_thesis_room           INT DEFAULT 0,
  total_visitors_today        INT DEFAULT 0,
  member_visitors             INT DEFAULT 0,
  reading_card_visitors       INT DEFAULT 0,
  general_visitors            INT DEFAULT 0,
  -- Transaksi harian
  borrowing_today             INT DEFAULT 0,
  returning_today             INT DEFAULT 0,
  validation_today            INT DEFAULT 0,
  bebas_pustaka_today         INT DEFAULT 0,
  registration_today          INT DEFAULT 0,
  fine_payment_today          INT DEFAULT 0,
  administration_today        INT DEFAULT 0,
  total_transactions_today    INT DEFAULT 0,
  -- Koleksi perpustakaan
  total_book_titles           INT DEFAULT 0,
  total_copies                INT DEFAULT 0,
  available_circulation       INT DEFAULT 0,
  availability_percent        NUMERIC(5,2) DEFAULT 0,
  total_internal_resources    INT DEFAULT 0,
  -- Akumulasi historis
  total_borrowing_all         INT DEFAULT 0,
  total_returning_all         INT DEFAULT 0,
  total_extension_all         INT DEFAULT 0,
  books_currently_borrowed    INT DEFAULT 0,
  members_currently_borrowing INT DEFAULT 0,
  overdue_books               INT DEFAULT 0,
  -- Tugas Akhir
  ta_d3                       INT DEFAULT 0,
  skripsi_s1                  INT DEFAULT 0,
  tesis_s2                    INT DEFAULT 0,
  disertasi_s3                INT DEFAULT 0,
  -- Keanggotaan per gender
  member_male                 INT DEFAULT 0,
  member_female               INT DEFAULT 0,
  -- Keanggotaan per program studi
  member_s1                   INT DEFAULT 0,
  member_s2                   INT DEFAULT 0,
  member_s3                   INT DEFAULT 0,
  member_d3                   INT DEFAULT 0,
  -- Keanggotaan per usia
  member_age_18_22            INT DEFAULT 0,
  member_age_23_27            INT DEFAULT 0,
  member_age_28_32            INT DEFAULT 0,
  member_age_33_plus          INT DEFAULT 0,
  -- Koleksi per kelas DDC (000 - 900)
  collection_000              INT DEFAULT 0,
  collection_100              INT DEFAULT 0,
  collection_200              INT DEFAULT 0,
  collection_300              INT DEFAULT 0,
  collection_400              INT DEFAULT 0,
  collection_500              INT DEFAULT 0,
  collection_600              INT DEFAULT 0,
  collection_700              INT DEFAULT 0,
  collection_800              INT DEFAULT 0,
  collection_900              INT DEFAULT 0,
  -- Data aktivitas per jam (9 elemen = jam 08:00-16:00)
  hourly_visitors             INT[] DEFAULT ARRAY[0,0,0,0,0,0,0,0,0],
  hourly_borrowing            INT[] DEFAULT ARRAY[0,0,0,0,0,0,0,0,0],
  hourly_returning            INT[] DEFAULT ARRAY[0,0,0,0,0,0,0,0,0],
  hourly_administration       INT[] DEFAULT ARRAY[0,0,0,0,0,0,0,0,0],
  updated_at                  TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- TABEL 3: late_books
-- Daftar buku terlambat + denda mahasiswa
-- ================================================================
CREATE TABLE public.late_books (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch      TEXT NOT NULL DEFAULT 'Pusat',
  member_name TEXT NOT NULL,
  nim         TEXT NOT NULL,
  faculty     TEXT NOT NULL,
  title       TEXT NOT NULL,
  days_late   INT NOT NULL DEFAULT 1,
  fine        INT NOT NULL DEFAULT 0,   -- Rupiah
  photo_url   TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- TABEL 4: academic_works
-- Karya ilmiah: Skripsi, Tesis, Disertasi, TA D3
-- ================================================================
CREATE TABLE public.academic_works (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch          TEXT NOT NULL DEFAULT 'Pusat',
  title           TEXT NOT NULL,
  author          TEXT NOT NULL,
  nim             TEXT NOT NULL,
  work_type       TEXT NOT NULL CHECK (work_type IN ('ta_d3','skripsi_s1','tesis_s2','disertasi_s3')),
  faculty         TEXT NOT NULL,
  supervisor      TEXT,
  submission_date TIMESTAMPTZ DEFAULT NOW(),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- TABEL 5: popular_collections
-- Koleksi buku terpopuler berdasarkan jumlah peminjaman
-- ================================================================
CREATE TABLE public.popular_collections (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch       TEXT NOT NULL DEFAULT 'Pusat',
  title        TEXT NOT NULL,
  author       TEXT NOT NULL,
  borrow_count INT DEFAULT 0,
  ddc_class    TEXT NOT NULL,   -- 'Kelas 000', 'Kelas 100', dst.
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================================
-- TABEL 6: membership_by_faculty
-- Data keanggotaan per fakultas
-- ================================================================
CREATE TABLE public.membership_by_faculty (
  id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  branch  TEXT NOT NULL DEFAULT 'Pusat',
  faculty TEXT NOT NULL,
  count   INT DEFAULT 0,
  UNIQUE (branch, faculty)
);

-- ================================================================
-- ROW LEVEL SECURITY (RLS)
-- SELECT = publik (untuk TV dashboard)
-- INSERT/UPDATE/DELETE = hanya user terautentikasi (admin)
-- ================================================================
ALTER TABLE public.library_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.library_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.late_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_works ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.popular_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.membership_by_faculty ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_select" ON public.library_settings FOR SELECT USING (true);
CREATE POLICY "public_select" ON public.library_stats FOR SELECT USING (true);
CREATE POLICY "public_select" ON public.late_books FOR SELECT USING (true);
CREATE POLICY "public_select" ON public.academic_works FOR SELECT USING (true);
CREATE POLICY "public_select" ON public.popular_collections FOR SELECT USING (true);
CREATE POLICY "public_select" ON public.membership_by_faculty FOR SELECT USING (true);

CREATE POLICY "auth_all" ON public.library_settings FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "auth_all" ON public.library_stats FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "auth_all" ON public.late_books FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "auth_all" ON public.academic_works FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "auth_all" ON public.popular_collections FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "auth_all" ON public.membership_by_faculty FOR ALL USING (auth.role() = 'authenticated');

-- ================================================================
-- DATA AWAL (SEED)
-- ================================================================

-- Settings untuk 3 branch
INSERT INTO public.library_settings (branch, running_text, marquee_speed, operational_hours, slide_duration, show_popups)
VALUES
  ('Pusat',    'Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.', 25, 'Senin - Jumat | 08:00 - 16:00 WIB', 25000, TRUE),
  ('Cabang A', 'Selamat datang di Perpustakaan Cabang A Universitas Riau.', 25, 'Senin - Jumat | 08:00 - 16:00 WIB', 25000, TRUE),
  ('Cabang B', 'Selamat datang di Perpustakaan Cabang B Universitas Riau.', 25, 'Senin - Jumat | 08:00 - 16:00 WIB', 25000, TRUE);

-- Stats awal untuk branch Pusat
INSERT INTO public.library_stats (
  branch,
  total_book_titles, total_copies, available_circulation, availability_percent, total_internal_resources,
  total_borrowing_all, total_returning_all, total_extension_all,
  books_currently_borrowed, members_currently_borrowing,
  ta_d3, skripsi_s1, tesis_s2, disertasi_s3,
  member_male, member_female,
  member_s1, member_s2, member_s3, member_d3,
  member_age_18_22, member_age_23_27, member_age_28_32, member_age_33_plus,
  collection_000, collection_100, collection_200, collection_300, collection_400,
  collection_500, collection_600, collection_700, collection_800, collection_900
) VALUES
  ('Pusat',
   39815, 134668, 133977, 99.5, 2456,
   392605, 391916, 14502, 689, 396,
   2, 15, 3, 1,
   298, 420, 485, 156, 45, 32,
   245, 312, 124, 37,
   6008, 1152, 1025, 12061, 1167, 4539, 10946, 535, 1303, 1073
  ),
  ('Cabang A',
   5000, 15000, 14900, 99.3, 500,
   0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   800, 200, 180, 1500, 250, 700, 1200, 100, 200, 150
  ),
  ('Cabang B',
   3000, 8000, 7950, 99.4, 300,
   0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   500, 120, 100, 900, 150, 400, 700, 80, 120, 100
  );

-- Koleksi populer
INSERT INTO public.popular_collections (branch, title, author, borrow_count, ddc_class) VALUES
  ('Pusat', 'Pemrograman Web Modern', 'Adi Nugroho', 245, 'Kelas 000'),
  ('Pusat', 'Database Design', 'C.J. Date', 198, 'Kelas 000'),
  ('Pusat', 'Algoritma & Struktur Data', 'Sedgewick', 187, 'Kelas 300'),
  ('Pusat', 'Clean Code', 'Robert C. Martin', 156, 'Kelas 600'),
  ('Pusat', 'Desain Basis Data', 'Connolly', 142, 'Kelas 000'),
  ('Pusat', 'Jaringan Komputer', 'Kurose', 130, 'Kelas 000'),
  ('Pusat', 'Rekayasa Perangkat Lunak', 'Pressman', 115, 'Kelas 600');

-- Keanggotaan per fakultas
INSERT INTO public.membership_by_faculty (branch, faculty, count) VALUES
  ('Pusat', 'FAPERTA', 145), ('Pusat', 'FMIPA', 132), ('Pusat', 'FE', 98),
  ('Pusat', 'FH', 87),       ('Pusat', 'FKIP', 156),  ('Pusat', 'TEKNIK', 110),
  ('Pusat', 'FISIP', 90),
  ('Cabang A', 'FAPERTA', 50), ('Cabang A', 'FMIPA', 45), ('Cabang A', 'FE', 30),
  ('Cabang B', 'TEKNIK', 60),  ('Cabang B', 'FISIP', 40);

-- Karya ilmiah contoh
INSERT INTO public.academic_works (branch, title, author, nim, work_type, faculty, supervisor, submission_date) VALUES
  ('Pusat', 'Pengaruh Algoritma Machine Learning pada Prediksi Cuaca', 'Budi Santoso', '21102001', 'skripsi_s1', 'FMIPA', 'Prof. Dr. Irwan', '2024-09-01T08:15:00Z'),
  ('Pusat', 'Sistem Informasi Manajemen Perpustakaan', 'Siti Nurhaliza', '21102002', 'ta_d3', 'TEKNIK', 'Dr. Budi Santoso', '2024-09-01T09:30:00Z'),
  ('Pusat', 'Analisis Sentimen Menggunakan NLP', 'Ahmad Fauzan', '21102003', 'tesis_s2', 'FMIPA', 'Dr. Siti Aminah', '2024-09-01T10:45:00Z'),
  ('Pusat', 'Pengembangan Model Deep Learning untuk Diagnosa Medis', 'Dr. Hendra Wijaya', '21102004', 'disertasi_s3', 'KEDOKTERAN', 'Prof. Yudi', '2024-09-01T11:20:00Z'),
  ('Pusat', 'Rancang Bangun Jaringan Sensor Nirkabel', 'Gilang Ramadhan', '21102005', 'skripsi_s1', 'TEKNIK', 'Dr. Rina', '2024-09-01T13:10:00Z'),
  ('Pusat', 'Optimasi Query pada Database Terdistribusi', 'Dewi Lestari', '21102006', 'skripsi_s1', 'FMIPA', 'Prof. Dr. Hasan', '2024-09-01T14:05:00Z');
