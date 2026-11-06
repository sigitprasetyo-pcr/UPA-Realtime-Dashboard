-- ================================================================
-- UPA PERPUSTAKAAN DASHBOARD — Supabase Full Migration
-- Jalankan SEMUA query ini di: Supabase → SQL Editor → Run
-- ================================================================

-- ────────────────────────────────────────────
-- 1. TABEL library_stats
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS library_stats (
  id         SERIAL PRIMARY KEY,
  branch     TEXT NOT NULL UNIQUE DEFAULT 'Pusat',
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────
-- 2. TABEL library_settings
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS library_settings (
  id         SERIAL PRIMARY KEY,
  branch     TEXT NOT NULL UNIQUE DEFAULT 'Pusat',
  data       JSONB NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────
-- 3. TABEL profiles (untuk akun admin)
-- ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id          UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email       TEXT NOT NULL,
  full_name   TEXT,
  role        TEXT NOT NULL DEFAULT 'admin',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────
-- 4. TRIGGER: Auto-update updated_at
-- ────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS stats_updated_at ON library_stats;
CREATE TRIGGER stats_updated_at
  BEFORE UPDATE ON library_stats
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS settings_updated_at ON library_settings;
CREATE TRIGGER settings_updated_at
  BEFORE UPDATE ON library_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ────────────────────────────────────────────
-- 5. TRIGGER: Auto-buat profile saat user dibuat
-- ────────────────────────────────────────────
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'full_name', 'Admin'))
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ────────────────────────────────────────────
-- 6. ROW LEVEL SECURITY (RLS)
-- ────────────────────────────────────────────
ALTER TABLE library_stats    ENABLE ROW LEVEL SECURITY;
ALTER TABLE library_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles  ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_stats"     ON library_stats;
DROP POLICY IF EXISTS "public_write_stats"    ON library_stats;
DROP POLICY IF EXISTS "public_read_settings"  ON library_settings;
DROP POLICY IF EXISTS "public_write_settings" ON library_settings;
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;

CREATE POLICY "public_read_stats"     ON library_stats    FOR SELECT USING (true);
CREATE POLICY "public_write_stats"    ON library_stats    FOR ALL    USING (true) WITH CHECK (true);
CREATE POLICY "public_read_settings"  ON library_settings FOR SELECT USING (true);
CREATE POLICY "public_write_settings" ON library_settings FOR ALL    USING (true) WITH CHECK (true);
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);

-- ────────────────────────────────────────────
-- 7. REALTIME
-- ────────────────────────────────────────────
ALTER PUBLICATION supabase_realtime ADD TABLE library_stats;
ALTER PUBLICATION supabase_realtime ADD TABLE library_settings;

-- ────────────────────────────────────────────
-- 8. SEED: Settings default 3 cabang
-- ────────────────────────────────────────────
INSERT INTO library_settings (branch, data) VALUES
(
  'Pusat',
  '{"activeBranch":"Pusat","slideDuration":25000,"showPopups":true,"logoUrl":null,"runningText":"Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.","marqueeSpeed":25,"operationalHours":"Senin - Jumat | 08:00 - 16:00 WIB","emergencyAlert":null}'::jsonb
),
(
  'Cabang A',
  '{"activeBranch":"Cabang A","slideDuration":25000,"showPopups":true,"logoUrl":null,"runningText":"Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.","marqueeSpeed":25,"operationalHours":"Senin - Jumat | 08:00 - 16:00 WIB","emergencyAlert":null}'::jsonb
),
(
  'Cabang B',
  '{"activeBranch":"Cabang B","slideDuration":25000,"showPopups":true,"logoUrl":null,"runningText":"Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.","marqueeSpeed":25,"operationalHours":"Senin - Jumat | 08:00 - 16:00 WIB","emergencyAlert":null}'::jsonb
)
ON CONFLICT (branch) DO NOTHING;

-- ────────────────────────────────────────────
-- 9. SEED: Stats awal untuk semua cabang
--    Data ini akan langsung tersambung ke Admin
-- ────────────────────────────────────────────
INSERT INTO library_stats (branch, data) VALUES
(
  'Pusat',
  '{
    "total_visitors_today": 416,
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
      {"id":"1","title":"Pemrograman Web Modern","author":"Adi Nugroho","borrowCount":245,"class":"Kelas 000"},
      {"id":"2","title":"Database Design","author":"C.J. Date","borrowCount":198,"class":"Kelas 100"},
      {"id":"3","title":"Algoritma & Struktur Data","author":"Sedgewick","borrowCount":187,"class":"Kelas 300"},
      {"id":"4","title":"Clean Code","author":"Robert C. Martin","borrowCount":156,"class":"Kelas 600"},
      {"id":"5","title":"Desain Basis Data","author":"Connolly","borrowCount":142,"class":"Kelas 000"},
      {"id":"6","title":"Jaringan Komputer","author":"Kurose","borrowCount":130,"class":"Kelas 000"},
      {"id":"7","title":"Rekayasa Perangkat Lunak","author":"Pressman","borrowCount":115,"class":"Kelas 600"}
    ],
    "total_borrowing_all": 392605,
    "total_returning_all": 391916,
    "total_extension_all": 14502,
    "books_currently_borrowed": 689,
    "members_currently_borrowing": 396,
    "overdue_books": 10,
    "late_books": [
      {"id":"init-0","memberName":"Putri Anggraini","nim":"214119","title":"Statistika Terapan","daysLate":3,"fine":50000,"faculty":"HUKUM"},
      {"id":"init-1","memberName":"Ernest Prakasa","nim":"214210","title":"Struktur Data","daysLate":1,"fine":90000,"faculty":"FISIP"},
      {"id":"init-2","memberName":"Yuni Shara","nim":"218009","title":"Struktur Data","daysLate":11,"fine":80000,"faculty":"FISIP"},
      {"id":"init-3","memberName":"Eza Gionino","nim":"211093","title":"Struktur Data","daysLate":1,"fine":70000,"faculty":"TEKNIK"},
      {"id":"init-4","memberName":"Herjunot Ali","nim":"211347","title":"Kalkulus Lanjut","daysLate":7,"fine":140000,"faculty":"FE"},
      {"id":"init-5","memberName":"Raffi Ahmad","nim":"213411","title":"Ekonomi Makro","daysLate":10,"fine":30000,"faculty":"FE"},
      {"id":"init-6","memberName":"Vino G. Bastian","nim":"215667","title":"Manajemen Keuangan","daysLate":14,"fine":140000,"faculty":"FKIP"},
      {"id":"init-7","memberName":"Umay Shahab","nim":"215143","title":"Psikologi Komunikasi","daysLate":7,"fine":50000,"faculty":"FMIPA"},
      {"id":"init-8","memberName":"Citra Kirana","nim":"212513","title":"Kalkulus Lanjut","daysLate":11,"fine":110000,"faculty":"FKIP"},
      {"id":"init-9","memberName":"Ariel Noah","nim":"219112","title":"Pemrograman Java","daysLate":1,"fine":70000,"faculty":"FAPERTA"}
    ],
    "member_visitors": 396,
    "reading_card_visitors": 0,
    "general_visitors": 1,
    "membership_by_faculty": [
      {"faculty":"FAPERTA","count":145},
      {"faculty":"FMIPA","count":132},
      {"faculty":"FE","count":98},
      {"faculty":"FH","count":87},
      {"faculty":"FKIP","count":156}
    ],
    "membership_by_gender": [
      {"category":"Laki-laki","count":298},
      {"category":"Perempuan","count":420}
    ],
    "membership_by_program": [
      {"category":"S1","count":485},
      {"category":"S2","count":156},
      {"category":"S3","count":45},
      {"category":"D3","count":32}
    ],
    "membership_by_age": [
      {"category":"18-22","count":245},
      {"category":"23-27","count":312},
      {"category":"28-32","count":124},
      {"category":"33+","count":37}
    ],
    "ta_d3": 2,
    "skripsi_s1": 15,
    "tesis_s2": 3,
    "disertasi_s3": 1,
    "academic_works": [
      {"id":"1","title":"Pengaruh Algoritma Machine Learning pada Prediksi Cuaca","author":"Budi Santoso","nim":"21102001","type":"skripsi_s1","submissionDate":"2024-09-01T08:15:00","faculty":"FMIPA"},
      {"id":"2","title":"Sistem Informasi Manajemen Perpustakaan","author":"Siti Nurhaliza","nim":"21102002","type":"ta_d3","submissionDate":"2024-09-01T09:30:00","faculty":"TEKNIK"},
      {"id":"3","title":"Analisis Sentimen Menggunakan NLP","author":"Ahmad Fauzan","nim":"21102003","type":"tesis_s2","submissionDate":"2024-09-01T10:45:00","faculty":"FMIPA"},
      {"id":"4","title":"Pengembangan Model Deep Learning untuk Diagnosa Medis","author":"Dr. Hendra Wijaya","nim":"21102004","type":"disertasi_s3","submissionDate":"2024-09-01T11:20:00","faculty":"KEDOKTERAN"},
      {"id":"5","title":"Rancang Bangun Jaringan Sensor Nirkabel","author":"Gilang Ramadhan","nim":"21102005","type":"skripsi_s1","submissionDate":"2024-09-01T13:10:00","faculty":"TEKNIK"},
      {"id":"6","title":"Optimasi Query pada Database Terdistribusi","author":"Dewi Lestari","nim":"21102006","type":"skripsi_s1","submissionDate":"2024-09-01T14:05:00","faculty":"FMIPA"}
    ],
    "admin_transactions": [
      {"type":"peminjaman","count":140},
      {"type":"pengembalian","count":158},
      {"type":"validasi","count":12},
      {"type":"bebas_pustaka","count":8},
      {"type":"pendaftaran","count":5},
      {"type":"pembayaran_denda","count":15}
    ],
    "hourly_visitors":      [15,35,48,42,20,40,30,22,18],
    "hourly_borrowing":     [8,18,25,20,10,18,15,12,10],
    "hourly_returning":     [10,22,28,22,12,20,16,14,12],
    "hourly_administration":[5,12,18,15,8,14,12,10,8],
    "collection_by_class": {
      "Kelas 000":6008,"Kelas 100":1152,"Kelas 200":1025,
      "Kelas 300":12061,"Kelas 400":1167,"Kelas 500":4539,
      "Kelas 600":10946,"Kelas 700":535,"Kelas 800":1303,"Kelas 900":1073
    },
    "visit_main_door": 100,
    "visit_circulation_room": 300,
    "visit_thesis_room": 16,
    "last_updated": "2026-10-19T00:00:00.000Z",
    "system_status": "online"
  }'::jsonb
),
(
  'Cabang A',
  '{
    "total_visitors_today": 85,
    "borrowing_today": 42,
    "returning_today": 38,
    "validation_today": 5,
    "bebas_pustaka_today": 2,
    "registration_today": 1,
    "fine_payment_today": 4,
    "administration_today": 30,
    "total_transactions_today": 115,
    "total_book_titles": 12500,
    "total_copies": 38000,
    "available_circulation": 37800,
    "availability_percent": 99.5,
    "total_internal_resources": 800,
    "popular_collections": [
      {"id":"1","title":"Pemrograman Web Modern","author":"Adi Nugroho","borrowCount":80,"class":"Kelas 000"},
      {"id":"2","title":"Database Design","author":"C.J. Date","borrowCount":65,"class":"Kelas 100"}
    ],
    "total_borrowing_all": 120000,
    "total_returning_all": 119800,
    "total_extension_all": 4500,
    "books_currently_borrowed": 200,
    "members_currently_borrowing": 120,
    "overdue_books": 5,
    "late_books": [
      {"id":"ca-0","memberName":"Budi Santoso","nim":"214001","title":"Algoritma & Struktur Data","daysLate":3,"fine":30000,"faculty":"TEKNIK"},
      {"id":"ca-1","memberName":"Dewi Lestari","nim":"214002","title":"Ekonomi Makro","daysLate":5,"fine":50000,"faculty":"FE"},
      {"id":"ca-2","memberName":"Gilang Ramadhan","nim":"214003","title":"Hukum Internasional","daysLate":2,"fine":20000,"faculty":"HUKUM"},
      {"id":"ca-3","memberName":"Anisa Rahmawati","nim":"214004","title":"Metodologi Penelitian","daysLate":7,"fine":70000,"faculty":"FMIPA"},
      {"id":"ca-4","memberName":"Rudi Hermawan","nim":"214005","title":"Kecerdasan Buatan","daysLate":4,"fine":40000,"faculty":"TEKNIK"}
    ],
    "member_visitors": 75,
    "reading_card_visitors": 5,
    "general_visitors": 5,
    "membership_by_faculty": [
      {"faculty":"FAPERTA","count":40},{"faculty":"FMIPA","count":35},
      {"faculty":"FE","count":28},{"faculty":"FH","count":20},{"faculty":"FKIP","count":45}
    ],
    "membership_by_gender": [{"category":"Laki-laki","count":85},{"category":"Perempuan","count":120}],
    "membership_by_program": [
      {"category":"S1","count":150},{"category":"S2","count":45},{"category":"S3","count":10},{"category":"D3","count":8}
    ],
    "membership_by_age": [
      {"category":"18-22","count":80},{"category":"23-27","count":90},{"category":"28-32","count":35},{"category":"33+","count":10}
    ],
    "ta_d3": 1, "skripsi_s1": 5, "tesis_s2": 1, "disertasi_s3": 0,
    "academic_works": [
      {"id":"1","title":"Analisis Data Perpustakaan Digital","author":"Rudi Hermawan","nim":"21202001","type":"skripsi_s1","submissionDate":"2024-09-01T08:15:00","faculty":"TEKNIK"}
    ],
    "admin_transactions": [
      {"type":"peminjaman","count":42},{"type":"pengembalian","count":38},
      {"type":"validasi","count":5},{"type":"bebas_pustaka","count":2},
      {"type":"pendaftaran","count":1},{"type":"pembayaran_denda","count":4}
    ],
    "hourly_visitors":      [5,12,18,15,8,12,8,5,2],
    "hourly_borrowing":     [3,8,10,8,4,6,5,4,2],
    "hourly_returning":     [4,9,10,7,3,5,4,3,2],
    "hourly_administration":[2,4,6,5,2,4,3,2,1],
    "collection_by_class": {
      "Kelas 000":2000,"Kelas 100":500,"Kelas 200":400,
      "Kelas 300":3500,"Kelas 400":450,"Kelas 500":1500,
      "Kelas 600":3200,"Kelas 700":200,"Kelas 800":450,"Kelas 900":300
    },
    "visit_main_door": 30,
    "visit_circulation_room": 50,
    "visit_thesis_room": 5,
    "last_updated": "2026-10-19T00:00:00.000Z",
    "system_status": "online"
  }'::jsonb
),
(
  'Cabang B',
  '{
    "total_visitors_today": 62,
    "borrowing_today": 28,
    "returning_today": 25,
    "validation_today": 3,
    "bebas_pustaka_today": 1,
    "registration_today": 1,
    "fine_payment_today": 2,
    "administration_today": 18,
    "total_transactions_today": 75,
    "total_book_titles": 8200,
    "total_copies": 24000,
    "available_circulation": 23880,
    "availability_percent": 99.5,
    "total_internal_resources": 500,
    "popular_collections": [
      {"id":"1","title":"Kalkulus Lanjut","author":"Purcell","borrowCount":55,"class":"Kelas 500"},
      {"id":"2","title":"Statistika Terapan","author":"Walpole","borrowCount":48,"class":"Kelas 500"}
    ],
    "total_borrowing_all": 80000,
    "total_returning_all": 79900,
    "total_extension_all": 3000,
    "books_currently_borrowed": 120,
    "members_currently_borrowing": 80,
    "overdue_books": 3,
    "late_books": [
      {"id":"cb-0","memberName":"Luna Maya","nim":"213001","title":"Statistika Terapan","daysLate":4,"fine":40000,"faculty":"FMIPA"},
      {"id":"cb-1","memberName":"Raditya Dika","nim":"213002","title":"Psikologi Komunikasi","daysLate":6,"fine":60000,"faculty":"FISIP"},
      {"id":"cb-2","memberName":"Nikita Willy","nim":"213003","title":"Manajemen Keuangan","daysLate":2,"fine":20000,"faculty":"FE"}
    ],
    "member_visitors": 55,
    "reading_card_visitors": 4,
    "general_visitors": 3,
    "membership_by_faculty": [
      {"faculty":"FAPERTA","count":25},{"faculty":"FMIPA","count":20},
      {"faculty":"FE","count":15},{"faculty":"FH","count":12},{"faculty":"FKIP","count":30}
    ],
    "membership_by_gender": [{"category":"Laki-laki","count":52},{"category":"Perempuan","count":78}],
    "membership_by_program": [
      {"category":"S1","count":95},{"category":"S2","count":28},{"category":"S3","count":5},{"category":"D3","count":4}
    ],
    "membership_by_age": [
      {"category":"18-22","count":55},{"category":"23-27","count":58},{"category":"28-32","count":18},{"category":"33+","count":5}
    ],
    "ta_d3": 0, "skripsi_s1": 3, "tesis_s2": 1, "disertasi_s3": 0,
    "academic_works": [
      {"id":"1","title":"Sistem Manajemen Aset Kampus","author":"Luna Maya","nim":"21302001","type":"skripsi_s1","submissionDate":"2024-09-01T10:00:00","faculty":"FMIPA"}
    ],
    "admin_transactions": [
      {"type":"peminjaman","count":28},{"type":"pengembalian","count":25},
      {"type":"validasi","count":3},{"type":"bebas_pustaka","count":1},
      {"type":"pendaftaran","count":1},{"type":"pembayaran_denda","count":2}
    ],
    "hourly_visitors":      [3,8,12,10,5,8,6,4,2],
    "hourly_borrowing":     [2,5,7,5,3,4,3,2,1],
    "hourly_returning":     [2,5,7,5,3,4,3,2,1],
    "hourly_administration":[1,2,4,3,2,3,2,1,0],
    "collection_by_class": {
      "Kelas 000":1200,"Kelas 100":300,"Kelas 200":250,
      "Kelas 300":2500,"Kelas 400":280,"Kelas 500":900,
      "Kelas 600":2000,"Kelas 700":120,"Kelas 800":350,"Kelas 900":300
    },
    "visit_main_door": 20,
    "visit_circulation_room": 38,
    "visit_thesis_room": 4,
    "last_updated": "2026-10-19T00:00:00.000Z",
    "system_status": "online"
  }'::jsonb
)
ON CONFLICT (branch) DO UPDATE SET
  data = EXCLUDED.data,
  updated_at = NOW();
