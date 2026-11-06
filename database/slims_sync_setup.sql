-- =====================================================================
-- SCRIPT PENYESUAIAN & SINKRONISASI DATABASE SLIMS DENGAN UPA DASHBOARD
-- Database: UPA_PERPUSTAKAAN (SLiMS 9 Bulian)
-- Tanggal: 2026-10-26
-- =====================================================================

USE `upa_perpustakaan`;

-- 1. PASTIKAN MASTER RUANGAN KUNJUNGAN TERDAFTAR (mst_visitor_room)
INSERT INTO `mst_visitor_room` (`name`, `unique_code`, `created_at`, `updated_at`)
VALUES 
  ('Pintu Utama', 'MAIN', NOW(), NOW()),
  ('Ruang Sirkulasi', 'CIRC', NOW(), NOW()),
  ('Ruang Skripsi & Tugas Akhir', 'THES', NOW(), NOW()),
  ('Ruang Multimedia', 'MULTI', NOW(), NOW()),
  ('Ruang Referensi', 'REF', NOW(), NOW())
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = NOW();

-- 2. UPDATE ATURAN DENDA PADA TIPE ANGGOTA (mst_member_type)
UPDATE `mst_member_type` 
SET `fine_each_day` = 10000, `loan_limit` = 5, `loan_periode` = 7
WHERE `member_type_id` = 1;

-- 3. INSERT MASTER BUKU (biblio) SESUAI DAFTAR DASHBOARD
INSERT INTO `biblio` (`biblio_id`, `gmd_id`, `title`, `classification`, `call_number`, `publish_year`, `language_id`, `input_date`, `last_update`)
VALUES
  (101, 1, 'Statistika Terapan', '519.5', '519.5 Wal s', '2022', 'id', NOW(), NOW()),
  (102, 1, 'Struktur Data dan Algoritma', '005.1', '005.1 Sed s', '2021', 'id', NOW(), NOW()),
  (103, 1, 'Kalkulus Lanjut', '515', '515 Pur k', '2020', 'id', NOW(), NOW()),
  (104, 1, 'Ekonomi Makro', '339', '339 Man e', '2021', 'id', NOW(), NOW()),
  (105, 1, 'Manajemen Keuangan', '658.15', '658.15 Bri m', '2022', 'id', NOW(), NOW()),
  (106, 1, 'Psikologi Komunikasi', '153.6', '153.6 Rah p', '2020', 'id', NOW(), NOW()),
  (107, 1, 'Pemrograman Java Fundamental', '005.133', '005.133 Sia p', '2023', 'id', NOW(), NOW()),
  (108, 1, 'Metodologi Penelitian Ilmiah', '001.42', '001.42 Sug m', '2021', 'id', NOW(), NOW()),
  (109, 1, 'Hukum Internasional Kontemporer', '341', '341 Kus h', '2020', 'id', NOW(), NOW()),
  (110, 1, 'Dasar Jaringan Komputer', '004.6', '004.6 Tan d', '2022', 'id', NOW(), NOW()),
  (111, 1, 'Kecerdasan Buatan & Machine Learning', '006.3', '006.3 Rus k', '2023', 'id', NOW(), NOW()),
  (112, 1, 'Agroekoteknologi Berkelanjutan', '630', '630 Sar a', '2021', 'id', NOW(), NOW()),
  (113, 1, 'Pemrograman Web Modern', '006.7', '006.7 Nug p', '2023', 'id', NOW(), NOW()),
  (114, 1, 'Database Design & Implementation', '005.74', '005.74 Dat d', '2022', 'id', NOW(), NOW()),
  (115, 1, 'Clean Code: A Handbook of Agile Software', '005.1', '005.1 Mar c', '2020', 'en', NOW(), NOW()),
  (116, 1, 'Desain Basis Data Relasional', '005.74', '005.74 Con d', '2021', 'id', NOW(), NOW()),
  (117, 1, 'Jaringan Komputer Lanjut', '004.6', '004.6 Kur j', '2022', 'id', NOW(), NOW()),
  (118, 1, 'Rekayasa Perangkat Lunak Praktis', '005.1', '005.1 Pre r', '2023', 'id', NOW(), NOW())
ON DUPLICATE KEY UPDATE `title` = VALUES(`title`), `classification` = VALUES(`classification`);

-- 4. INSERT EKSEMPLAR BUKU (item)
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00011', 'INV/B00011', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00012', 'INV/B00012', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00013', 'INV/B00013', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00014', 'INV/B00014', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00015', 'INV/B00015', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00016', 'INV/B00016', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00017', 'INV/B00017', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00018', 'INV/B00018', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00019', 'INV/B00019', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (101, 'B00020', 'INV/B00020', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00021', 'INV/B00021', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00022', 'INV/B00022', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00023', 'INV/B00023', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00024', 'INV/B00024', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00025', 'INV/B00025', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00026', 'INV/B00026', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00027', 'INV/B00027', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00028', 'INV/B00028', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00029', 'INV/B00029', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (102, 'B00030', 'INV/B00030', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00031', 'INV/B00031', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00032', 'INV/B00032', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00033', 'INV/B00033', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00034', 'INV/B00034', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00035', 'INV/B00035', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00036', 'INV/B00036', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00037', 'INV/B00037', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00038', 'INV/B00038', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00039', 'INV/B00039', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (103, 'B00040', 'INV/B00040', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00041', 'INV/B00041', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00042', 'INV/B00042', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00043', 'INV/B00043', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00044', 'INV/B00044', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00045', 'INV/B00045', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00046', 'INV/B00046', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00047', 'INV/B00047', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00048', 'INV/B00048', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00049', 'INV/B00049', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (104, 'B00050', 'INV/B00050', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00051', 'INV/B00051', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00052', 'INV/B00052', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00053', 'INV/B00053', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00054', 'INV/B00054', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00055', 'INV/B00055', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00056', 'INV/B00056', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00057', 'INV/B00057', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00058', 'INV/B00058', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00059', 'INV/B00059', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (105, 'B00060', 'INV/B00060', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00061', 'INV/B00061', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00062', 'INV/B00062', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00063', 'INV/B00063', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00064', 'INV/B00064', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00065', 'INV/B00065', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00066', 'INV/B00066', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00067', 'INV/B00067', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00068', 'INV/B00068', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00069', 'INV/B00069', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (106, 'B00070', 'INV/B00070', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00071', 'INV/B00071', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00072', 'INV/B00072', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00073', 'INV/B00073', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00074', 'INV/B00074', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00075', 'INV/B00075', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00076', 'INV/B00076', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00077', 'INV/B00077', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00078', 'INV/B00078', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00079', 'INV/B00079', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (107, 'B00080', 'INV/B00080', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00081', 'INV/B00081', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00082', 'INV/B00082', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00083', 'INV/B00083', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00084', 'INV/B00084', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00085', 'INV/B00085', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00086', 'INV/B00086', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00087', 'INV/B00087', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00088', 'INV/B00088', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00089', 'INV/B00089', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (108, 'B00090', 'INV/B00090', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00091', 'INV/B00091', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00092', 'INV/B00092', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00093', 'INV/B00093', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00094', 'INV/B00094', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00095', 'INV/B00095', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00096', 'INV/B00096', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00097', 'INV/B00097', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00098', 'INV/B00098', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00099', 'INV/B00099', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (109, 'B00100', 'INV/B00100', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00101', 'INV/B00101', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00102', 'INV/B00102', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00103', 'INV/B00103', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00104', 'INV/B00104', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00105', 'INV/B00105', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00106', 'INV/B00106', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00107', 'INV/B00107', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00108', 'INV/B00108', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00109', 'INV/B00109', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (110, 'B00110', 'INV/B00110', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00111', 'INV/B00111', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00112', 'INV/B00112', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00113', 'INV/B00113', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00114', 'INV/B00114', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00115', 'INV/B00115', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00116', 'INV/B00116', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00117', 'INV/B00117', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00118', 'INV/B00118', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00119', 'INV/B00119', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (111, 'B00120', 'INV/B00120', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00121', 'INV/B00121', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00122', 'INV/B00122', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00123', 'INV/B00123', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00124', 'INV/B00124', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00125', 'INV/B00125', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00126', 'INV/B00126', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00127', 'INV/B00127', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00128', 'INV/B00128', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00129', 'INV/B00129', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (112, 'B00130', 'INV/B00130', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00131', 'INV/B00131', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00132', 'INV/B00132', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00133', 'INV/B00133', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00134', 'INV/B00134', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00135', 'INV/B00135', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00136', 'INV/B00136', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00137', 'INV/B00137', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00138', 'INV/B00138', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00139', 'INV/B00139', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (113, 'B00140', 'INV/B00140', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00141', 'INV/B00141', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00142', 'INV/B00142', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00143', 'INV/B00143', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00144', 'INV/B00144', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00145', 'INV/B00145', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00146', 'INV/B00146', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00147', 'INV/B00147', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00148', 'INV/B00148', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00149', 'INV/B00149', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (114, 'B00150', 'INV/B00150', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00151', 'INV/B00151', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00152', 'INV/B00152', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00153', 'INV/B00153', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00154', 'INV/B00154', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00155', 'INV/B00155', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00156', 'INV/B00156', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00157', 'INV/B00157', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00158', 'INV/B00158', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00159', 'INV/B00159', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (115, 'B00160', 'INV/B00160', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00161', 'INV/B00161', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00162', 'INV/B00162', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00163', 'INV/B00163', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00164', 'INV/B00164', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00165', 'INV/B00165', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00166', 'INV/B00166', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00167', 'INV/B00167', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00168', 'INV/B00168', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00169', 'INV/B00169', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (116, 'B00170', 'INV/B00170', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00171', 'INV/B00171', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00172', 'INV/B00172', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00173', 'INV/B00173', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00174', 'INV/B00174', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00175', 'INV/B00175', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00176', 'INV/B00176', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00177', 'INV/B00177', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00178', 'INV/B00178', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00179', 'INV/B00179', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (117, 'B00180', 'INV/B00180', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00181', 'INV/B00181', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00182', 'INV/B00182', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00183', 'INV/B00183', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00184', 'INV/B00184', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00185', 'INV/B00185', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00186', 'INV/B00186', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00187', 'INV/B00187', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00188', 'INV/B00188', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00189', 'INV/B00189', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);
INSERT INTO `item` (`biblio_id`, `item_code`, `inventory_code`, `coll_type_id`, `location_id`, `item_status_id`, `price`, `received_date`, `input_date`)
VALUES (118, 'B00190', 'INV/B00190', 1, 'SL', '0', 150000, CURDATE(), NOW())
ON DUPLICATE KEY UPDATE `biblio_id` = VALUES(`biblio_id`);

-- 5. INSERT DATA MAHASISWA (member)
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212754', 'Deddy Corbuzier', 1, 1, 'FISIP', 0, '212754@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214119', 'Putri Anggraini', 0, 1, 'HUKUM', 0, '214119@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214210', 'Ernest Prakasa', 1, 1, 'FISIP', 0, '214210@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('218009', 'Yuni Shara', 0, 1, 'FISIP', 0, '218009@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211093', 'Eza Gionino', 0, 1, 'TEKNIK', 0, '211093@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211347', 'Herjunot Ali', 0, 1, 'FE', 0, '211347@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213411', 'Raffi Ahmad', 1, 1, 'FE', 0, '213411@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215667', 'Vino G. Bastian', 0, 1, 'FKIP', 0, '215667@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215143', 'Umay Shahab', 1, 1, 'FMIPA', 0, '215143@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212513', 'Citra Kirana', 0, 1, 'FKIP', 0, '212513@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219112', 'Ariel Noah', 1, 1, 'FAPERTA', 0, '219112@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('217781', 'Tara Basro', 1, 1, 'TEKNIK', 0, '217781@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216424', 'Iko Uwais', 0, 1, 'FISIP', 0, '216424@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214757', 'Hesti Purwadinata', 1, 1, 'TEKNIK', 0, '214757@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211755', 'Gisella Anastasia', 0, 1, 'FISIP', 0, '211755@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211081', 'Dimas Anggara', 0, 1, 'FISIP', 0, '211081@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210319', 'Jefri Nichol', 1, 1, 'TEKNIK', 0, '210319@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214053', 'Farid Aja', 0, 1, 'TEKNIK', 0, '214053@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216559', 'Darius Sinathrya', 0, 1, 'FKIP', 0, '216559@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213976', 'Cinta Laura', 0, 1, 'FISIP', 0, '213976@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('217509', 'Tukul Arwana', 1, 1, 'FKIP', 0, '217509@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210457', 'Hasan Basri', 1, 1, 'TEKNIK', 0, '210457@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219347', 'Syifa Hadju', 1, 1, 'FISIP', 0, '219347@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212066', 'Marcel Chandrawinata', 0, 1, 'FMIPA', 0, '212066@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212647', 'Nadine Chandrawinata', 1, 1, 'FMIPA', 0, '212647@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216862', 'Yayan Ruhian', 1, 1, 'FAPERTA', 0, '216862@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214999', 'Elly Sugigi', 1, 1, 'TEKNIK', 0, '214999@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213967', 'Luna Maya', 0, 1, 'FMIPA', 0, '213967@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212211', 'Raditya Dika', 1, 1, 'FKIP', 0, '212211@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211012', 'Omesh', 0, 1, 'FMIPA', 0, '211012@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215255', 'Abimana Aryasatya', 1, 1, 'FKIP', 0, '215255@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213701', 'Rudi Hermawan', 0, 1, 'FKIP', 0, '213701@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211852', 'Ahmad Fauzan', 0, 1, 'TEKNIK', 0, '211852@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219168', 'Sule', 0, 1, 'FMIPA', 0, '219168@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219150', 'Vanesha Prescilla', 0, 1, 'FMIPA', 0, '219150@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212849', 'Nadine Chandrawinata', 1, 1, 'HUKUM', 0, '212849@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219859', 'Hesti Purwadinata', 0, 1, 'FISIP', 0, '219859@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212588', 'Oka Antara', 0, 1, 'FKIP', 0, '212588@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210887', 'Yayan Ruhian', 0, 1, 'HUKUM', 0, '210887@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219664', 'Kunto Aji', 0, 1, 'FMIPA', 0, '219664@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216446', 'Fina Melati', 1, 1, 'TEKNIK', 0, '216446@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212383', 'Lesti Kejora', 1, 1, 'FE', 0, '212383@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219752', 'Bisma Karisma', 1, 1, 'FAPERTA', 0, '219752@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211342', 'Chelsea Islan', 0, 1, 'HUKUM', 0, '211342@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211988', 'Iqbal Ramadhan', 0, 1, 'HUKUM', 0, '211988@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214798', 'Hasan Basri', 1, 1, 'FE', 0, '214798@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('217009', 'Fauzi Baadilla', 0, 1, 'FAPERTA', 0, '217009@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213311', 'Pamela Bowie', 0, 1, 'FE', 0, '213311@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213757', 'Dimas Anggara', 1, 1, 'FKIP', 0, '213757@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214896', 'Jessica Mila', 0, 1, 'FE', 0, '214896@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219909', 'Raline Shah', 0, 1, 'FAPERTA', 0, '219909@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219006', 'Yuki Kato', 0, 1, 'FKIP', 0, '219006@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213932', 'Marcel Chandrawinata', 1, 1, 'FKIP', 0, '213932@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215666', 'Andi Pratama', 0, 1, 'FKIP', 0, '215666@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212304', 'Wafda Saifan', 0, 1, 'FE', 0, '212304@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('217823', 'Siti Nurhaliza', 0, 1, 'FISIP', 0, '217823@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211654', 'Nadine Chandrawinata', 1, 1, 'TEKNIK', 0, '211654@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215626', 'Umay Shahab', 0, 1, 'FAPERTA', 0, '215626@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212330', 'Andi Pratama', 0, 1, 'FMIPA', 0, '212330@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214291', 'Lesti Kejora', 1, 1, 'FKIP', 0, '214291@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('218362', 'Kiki Fatmala', 0, 1, 'HUKUM', 0, '218362@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213393', 'Kaesang Pangarep', 1, 1, 'FAPERTA', 0, '213393@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210686', 'Anisa Rahmawati', 0, 1, 'FAPERTA', 0, '210686@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212625', 'Fajar Nugraha', 0, 1, 'FKIP', 0, '212625@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212686', 'Umay Shahab', 0, 1, 'FAPERTA', 0, '212686@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219345', 'Anisa Rahmawati', 1, 1, 'FKIP', 0, '219345@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214910', 'Marthino Lio', 1, 1, 'FMIPA', 0, '214910@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210100', 'Wafda Saifan', 1, 1, 'FE', 0, '210100@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('218719', 'Darius Sinathrya', 1, 1, 'FMIPA', 0, '218719@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210910', 'Vanesha Prescilla', 1, 1, 'FKIP', 0, '210910@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('214768', 'Yuni Shara', 0, 1, 'HUKUM', 0, '214768@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210590', 'Wendi Cagur', 0, 1, 'FE', 0, '210590@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210402', 'Gading Marten', 0, 1, 'TEKNIK', 0, '210402@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211166', 'Raditya Dika', 1, 1, 'TEKNIK', 0, '211166@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212608', 'Zaskia Sungkar', 0, 1, 'TEKNIK', 0, '212608@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210872', 'Kaesang Pangarep', 1, 1, 'TEKNIK', 0, '210872@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215510', 'Ahmad Fauzan', 1, 1, 'FISIP', 0, '215510@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211937', 'Fedi Nuril', 1, 1, 'TEKNIK', 0, '211937@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219669', 'Vidi Aldiano', 1, 1, 'HUKUM', 0, '219669@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210979', 'Fauzi Baadilla', 1, 1, 'HUKUM', 0, '210979@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219965', 'Rina Nose', 0, 1, 'FISIP', 0, '219965@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213654', 'Qory Sandioriva', 0, 1, 'FAPERTA', 0, '213654@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210865', 'Tatjana Saphira', 0, 1, 'TEKNIK', 0, '210865@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210806', 'Agung Hercules', 1, 1, 'TEKNIK', 0, '210806@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216256', 'Bayu Saputra', 0, 1, 'FE', 0, '216256@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211431', 'Farid Aja', 0, 1, 'HUKUM', 0, '211431@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216924', 'Andi Pratama', 0, 1, 'FKIP', 0, '216924@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216725', 'Fauzi Baadilla', 0, 1, 'FISIP', 0, '216725@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211337', 'Bunga Citra', 0, 1, 'FAPERTA', 0, '211337@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219455', 'Rini Wulandari', 0, 1, 'FMIPA', 0, '219455@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216530', 'Umay Shahab', 1, 1, 'FMIPA', 0, '216530@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('218818', 'Qomar', 1, 1, 'FE', 0, '218818@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215681', 'Fauzi Baadilla', 0, 1, 'FISIP', 0, '215681@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216430', 'Andi Pratama', 0, 1, 'FMIPA', 0, '216430@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213755', 'Umay Shahab', 1, 1, 'TEKNIK', 0, '213755@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('215269', 'Rini Wulandari', 0, 1, 'TEKNIK', 0, '215269@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('216426', 'Naufal Abiyyu', 1, 1, 'HUKUM', 0, '216426@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('210511', 'Hendra Wijaya', 1, 1, 'FMIPA', 0, '210511@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213248', 'Giring Ganesha', 1, 1, 'TEKNIK', 0, '213248@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213089', 'Gisella Anastasia', 1, 1, 'FE', 0, '213089@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('218484', 'Zacky Winter', 1, 1, 'FISIP', 0, '218484@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('213597', 'Lukman Sardi', 1, 1, 'FAPERTA', 0, '213597@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('212633', 'Uus', 0, 1, 'TEKNIK', 0, '212633@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('219372', 'Uus', 1, 1, 'FMIPA', 0, '219372@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);
INSERT INTO `member` (`member_id`, `member_name`, `gender`, `member_type_id`, `inst_name`, `is_new`, `member_email`, `register_date`, `expire_date`, `input_date`)
VALUES ('211442', 'Gisella Anastasia', 1, 1, 'FMIPA', 0, '211442@student.unri.ac.id', '2023-09-01', '2027-08-31', CURDATE())
ON DUPLICATE KEY UPDATE `member_name` = VALUES(`member_name`), `inst_name` = VALUES(`inst_name`);

-- 6. INSERT PINJAMAN TERLAMBAT (loan) - 104 TUNGGAKAN
DELETE FROM `loan`;
DELETE FROM `fines`;
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00011', '212754', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212754', 70000, 0, 'Denda terlambat 7 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00014', '214119', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214119', 50000, 0, 'Denda terlambat 3 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00017', '214210', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214210', 90000, 0, 'Denda terlambat 1 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00020', '218009', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '218009', 80000, 0, 'Denda terlambat 11 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00023', '211093', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211093', 70000, 0, 'Denda terlambat 1 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00026', '211347', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211347', 140000, 0, 'Denda terlambat 7 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00029', '213411', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213411', 30000, 0, 'Denda terlambat 10 hari: Ekonomi Makro');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00032', '215667', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215667', 140000, 0, 'Denda terlambat 14 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00035', '215143', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215143', 50000, 0, 'Denda terlambat 7 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00038', '212513', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212513', 110000, 0, 'Denda terlambat 11 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00041', '219112', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219112', 70000, 0, 'Denda terlambat 1 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00044', '217781', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '217781', 60000, 0, 'Denda terlambat 10 hari: Metodologi Penelitian');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00047', '216424', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216424', 90000, 0, 'Denda terlambat 5 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00050', '214757', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214757', 140000, 0, 'Denda terlambat 2 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00053', '211755', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211755', 10000, 0, 'Denda terlambat 2 hari: Ekonomi Makro');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00056', '211081', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211081', 110000, 0, 'Denda terlambat 3 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00059', '210319', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210319', 40000, 0, 'Denda terlambat 5 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00062', '214053', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214053', 40000, 0, 'Denda terlambat 7 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00065', '216559', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216559', 100000, 0, 'Denda terlambat 3 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00068', '213976', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213976', 60000, 0, 'Denda terlambat 6 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00071', '217509', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '217509', 140000, 0, 'Denda terlambat 3 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00074', '210457', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210457', 80000, 0, 'Denda terlambat 10 hari: Metodologi Penelitian');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00077', '219347', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219347', 10000, 0, 'Denda terlambat 2 hari: Ekonomi Makro');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00080', '212066', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212066', 30000, 0, 'Denda terlambat 12 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00083', '212647', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212647', 90000, 0, 'Denda terlambat 7 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00086', '216862', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216862', 90000, 0, 'Denda terlambat 3 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00089', '214999', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214999', 110000, 0, 'Denda terlambat 11 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00092', '213967', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213967', 50000, 0, 'Denda terlambat 9 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00095', '212211', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212211', 120000, 0, 'Denda terlambat 12 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00098', '211012', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211012', 80000, 0, 'Denda terlambat 6 hari: Metodologi Penelitian');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00101', '215255', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215255', 80000, 0, 'Denda terlambat 4 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00104', '213701', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213701', 130000, 0, 'Denda terlambat 7 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00107', '211852', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211852', 90000, 0, 'Denda terlambat 4 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00110', '219168', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219168', 120000, 0, 'Denda terlambat 5 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00113', '219150', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219150', 80000, 0, 'Denda terlambat 2 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00116', '212849', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212849', 90000, 0, 'Denda terlambat 7 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00119', '219859', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219859', 110000, 0, 'Denda terlambat 2 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00122', '212588', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212588', 90000, 0, 'Denda terlambat 5 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00125', '210887', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210887', 110000, 0, 'Denda terlambat 14 hari: Metodologi Penelitian');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00128', '219664', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219664', 70000, 0, 'Denda terlambat 3 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00131', '216446', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216446', 140000, 0, 'Denda terlambat 1 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00134', '212383', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212383', 120000, 0, 'Denda terlambat 12 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00137', '219752', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219752', 40000, 0, 'Denda terlambat 5 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00140', '211342', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211342', 80000, 0, 'Denda terlambat 12 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00143', '211988', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211988', 80000, 0, 'Denda terlambat 7 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00146', '214798', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214798', 60000, 0, 'Denda terlambat 2 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00149', '217009', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '217009', 70000, 0, 'Denda terlambat 14 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00152', '213311', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213311', 40000, 0, 'Denda terlambat 6 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00155', '213757', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213757', 40000, 0, 'Denda terlambat 6 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00158', '214896', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214896', 10000, 0, 'Denda terlambat 4 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00161', '219909', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219909', 40000, 0, 'Denda terlambat 1 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00164', '219006', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219006', 130000, 0, 'Denda terlambat 11 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00167', '213932', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213932', 30000, 0, 'Denda terlambat 2 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00170', '215666', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215666', 100000, 0, 'Denda terlambat 8 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00173', '212304', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212304', 10000, 0, 'Denda terlambat 8 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00176', '217823', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '217823', 10000, 0, 'Denda terlambat 14 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00179', '211654', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211654', 50000, 0, 'Denda terlambat 5 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00012', '215626', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215626', 140000, 0, 'Denda terlambat 8 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00015', '212330', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212330', 30000, 0, 'Denda terlambat 7 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00018', '214291', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214291', 30000, 0, 'Denda terlambat 12 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00021', '218362', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '218362', 130000, 0, 'Denda terlambat 11 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00024', '213393', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213393', 120000, 0, 'Denda terlambat 6 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00027', '210686', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210686', 60000, 0, 'Denda terlambat 9 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00030', '212625', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212625', 80000, 0, 'Denda terlambat 3 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00033', '212686', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212686', 110000, 0, 'Denda terlambat 9 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00036', '219345', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219345', 110000, 0, 'Denda terlambat 9 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00039', '214910', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214910', 40000, 0, 'Denda terlambat 4 hari: Ekonomi Makro');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00042', '210100', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210100', 80000, 0, 'Denda terlambat 8 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00045', '218719', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '218719', 60000, 0, 'Denda terlambat 12 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00048', '210910', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210910', 110000, 0, 'Denda terlambat 14 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00051', '214768', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '214768', 100000, 0, 'Denda terlambat 3 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00054', '210590', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210590', 20000, 0, 'Denda terlambat 5 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00057', '210402', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210402', 140000, 0, 'Denda terlambat 14 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00060', '211166', DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211166', 10000, 0, 'Denda terlambat 1 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00063', '212608', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212608', 100000, 0, 'Denda terlambat 10 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00066', '210872', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210872', 70000, 0, 'Denda terlambat 11 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00069', '215510', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215510', 10000, 0, 'Denda terlambat 10 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00072', '211937', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211937', 60000, 0, 'Denda terlambat 14 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00075', '219669', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219669', 80000, 0, 'Denda terlambat 3 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00078', '210979', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210979', 130000, 0, 'Denda terlambat 9 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00081', '219965', DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219965', 30000, 0, 'Denda terlambat 11 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00084', '213654', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213654', 110000, 0, 'Denda terlambat 4 hari: Ekonomi Makro');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00087', '210865', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210865', 130000, 0, 'Denda terlambat 4 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00090', '210806', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210806', 120000, 0, 'Denda terlambat 4 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00093', '216256', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216256', 70000, 0, 'Denda terlambat 2 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00096', '211431', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211431', 100000, 0, 'Denda terlambat 10 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00099', '216924', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216924', 70000, 0, 'Denda terlambat 5 hari: Manajemen Keuangan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00102', '216725', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216725', 140000, 0, 'Denda terlambat 10 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00105', '211337', DATE_SUB(CURDATE(), INTERVAL 11 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '211337', 90000, 0, 'Denda terlambat 4 hari: Agroekoteknologi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00108', '219455', DATE_SUB(CURDATE(), INTERVAL 10 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219455', 120000, 0, 'Denda terlambat 3 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00111', '216530', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216530', 140000, 0, 'Denda terlambat 12 hari: Struktur Data');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00114', '218818', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '218818', 120000, 0, 'Denda terlambat 7 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00117', '215681', DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 7 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215681', 60000, 0, 'Denda terlambat 7 hari: Pemrograman Java');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00120', '216430', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216430', 110000, 0, 'Denda terlambat 8 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00123', '213755', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213755', 130000, 0, 'Denda terlambat 14 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00126', '215269', DATE_SUB(CURDATE(), INTERVAL 17 DAY), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '215269', 30000, 0, 'Denda terlambat 10 hari: Kecerdasan Buatan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00129', '216426', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '216426', 70000, 0, 'Denda terlambat 8 hari: Hukum Internasional');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00132', '210511', DATE_SUB(CURDATE(), INTERVAL 13 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '210511', 120000, 0, 'Denda terlambat 6 hari: Psikologi Komunikasi');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00135', '213248', DATE_SUB(CURDATE(), INTERVAL 21 DAY), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213248', 50000, 0, 'Denda terlambat 14 hari: Dasar Jaringan Komputer');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00138', '213089', DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213089', 100000, 0, 'Denda terlambat 12 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00141', '218484', DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '218484', 40000, 0, 'Denda terlambat 5 hari: Kalkulus Lanjut');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00144', '213597', DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_SUB(CURDATE(), INTERVAL 8 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '213597', 90000, 0, 'Denda terlambat 8 hari: Metodologi Penelitian');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00147', '212633', DATE_SUB(CURDATE(), INTERVAL 9 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '212633', 30000, 0, 'Denda terlambat 2 hari: Statistika Terapan');
INSERT INTO `loan` (`item_code`, `member_id`, `loan_date`, `due_date`, `is_lent`, `is_return`, `input_date`)
VALUES ('B00150', '219372', DATE_SUB(CURDATE(), INTERVAL 16 DAY), DATE_SUB(CURDATE(), INTERVAL 9 DAY), 1, 0, NOW());
INSERT INTO `fines` (`fines_date`, `member_id`, `debet`, `credit`, `description`)
VALUES (CURDATE(), '219372', 50000, 0, 'Denda terlambat 9 hari: Agroekoteknologi');

-- 7. INSERT DATA KUNJUNGAN HARI INI (visitor_count)
DELETE FROM `visitor_count`;
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 08:56:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 08:24:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 08:27:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 08:31:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 08:43:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 08:35:10'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 08:40:48'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 08:02:12'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 08:50:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 08:04:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 08:32:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 08:43:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 08:29:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 08:44:05'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 08:50:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 08:24:04'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 08:49:16'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 08:28:55'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 08:45:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 08:17:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 08:14:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 08:59:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 08:41:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 08:04:36'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 08:37:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 09:31:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 09:26:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 09:20:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 09:59:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 09:39:53'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 09:52:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 09:01:38'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 09:31:09'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 09:22:49'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 09:25:38'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 09:04:48'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 09:46:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 09:03:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 09:44:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 09:24:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 09:36:00'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 09:07:50'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 09:21:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 09:34:08'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 09:55:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 09:59:49'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 09:41:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 09:34:18'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 09:43:16'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 09:32:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216862', 'Yayan Ruhian', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 09:37:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214999', 'Elly Sugigi', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 09:58:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213967', 'Luna Maya', 'FMIPA', 'THES', CONCAT(CURDATE(), ' 09:28:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212211', 'Raditya Dika', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 09:56:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211012', 'Omesh', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 09:42:12'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215255', 'Abimana Aryasatya', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 09:52:31'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213701', 'Rudi Hermawan', 'FKIP', 'CIRC', CONCAT(CURDATE(), ' 09:16:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211852', 'Ahmad Fauzan', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 09:42:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219168', 'Sule', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 09:05:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219150', 'Vanesha Prescilla', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 09:20:53'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212849', 'Nadine Chandrawinata', 'HUKUM', 'MAIN', CONCAT(CURDATE(), ' 09:42:25'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219859', 'Hesti Purwadinata', 'FISIP', 'CIRC', CONCAT(CURDATE(), ' 09:18:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212588', 'Oka Antara', 'FKIP', 'THES', CONCAT(CURDATE(), ' 09:31:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210887', 'Yayan Ruhian', 'HUKUM', 'MULTI', CONCAT(CURDATE(), ' 09:23:26'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219664', 'Kunto Aji', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 09:35:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216446', 'Fina Melati', 'TEKNIK', 'MAIN', CONCAT(CURDATE(), ' 09:05:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212383', 'Lesti Kejora', 'FE', 'CIRC', CONCAT(CURDATE(), ' 09:36:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219752', 'Bisma Karisma', 'FAPERTA', 'THES', CONCAT(CURDATE(), ' 09:03:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211342', 'Chelsea Islan', 'HUKUM', 'MULTI', CONCAT(CURDATE(), ' 09:56:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211988', 'Iqbal Ramadhan', 'HUKUM', 'REF', CONCAT(CURDATE(), ' 09:27:34'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 10:01:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 10:55:20'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 10:45:36'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 10:01:20'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 10:29:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 10:51:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 10:00:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 10:54:08'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 10:47:48'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 10:03:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 10:14:00'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 10:26:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 10:44:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 10:56:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 10:27:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 10:48:45'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 10:36:05'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 10:11:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 10:30:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 10:09:08'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 10:33:48'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 10:39:05'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 10:31:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 10:51:30'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 10:28:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216862', 'Yayan Ruhian', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 10:21:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214999', 'Elly Sugigi', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 10:45:31'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213967', 'Luna Maya', 'FMIPA', 'THES', CONCAT(CURDATE(), ' 10:20:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212211', 'Raditya Dika', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 10:41:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211012', 'Omesh', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 10:07:18'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215255', 'Abimana Aryasatya', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 10:06:52'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213701', 'Rudi Hermawan', 'FKIP', 'CIRC', CONCAT(CURDATE(), ' 10:21:49'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211852', 'Ahmad Fauzan', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 10:05:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219168', 'Sule', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 10:01:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219150', 'Vanesha Prescilla', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 10:50:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212849', 'Nadine Chandrawinata', 'HUKUM', 'MAIN', CONCAT(CURDATE(), ' 10:23:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219859', 'Hesti Purwadinata', 'FISIP', 'CIRC', CONCAT(CURDATE(), ' 10:30:19'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212588', 'Oka Antara', 'FKIP', 'THES', CONCAT(CURDATE(), ' 10:31:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210887', 'Yayan Ruhian', 'HUKUM', 'MULTI', CONCAT(CURDATE(), ' 10:52:50'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219664', 'Kunto Aji', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 10:42:11'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216446', 'Fina Melati', 'TEKNIK', 'MAIN', CONCAT(CURDATE(), ' 10:06:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212383', 'Lesti Kejora', 'FE', 'CIRC', CONCAT(CURDATE(), ' 10:02:32'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219752', 'Bisma Karisma', 'FAPERTA', 'THES', CONCAT(CURDATE(), ' 10:27:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211342', 'Chelsea Islan', 'HUKUM', 'MULTI', CONCAT(CURDATE(), ' 10:29:32'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211988', 'Iqbal Ramadhan', 'HUKUM', 'REF', CONCAT(CURDATE(), ' 10:33:12'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214798', 'Hasan Basri', 'FE', 'MAIN', CONCAT(CURDATE(), ' 10:58:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217009', 'Fauzi Baadilla', 'FAPERTA', 'CIRC', CONCAT(CURDATE(), ' 10:34:24'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213311', 'Pamela Bowie', 'FE', 'THES', CONCAT(CURDATE(), ' 10:32:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213757', 'Dimas Anggara', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 10:38:09'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214896', 'Jessica Mila', 'FE', 'REF', CONCAT(CURDATE(), ' 10:32:20'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 11:24:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 11:31:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 11:22:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 11:15:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 11:32:07'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 11:14:38'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 11:17:01'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 11:27:38'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 11:02:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 11:52:52'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 11:02:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 11:29:48'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 11:53:29'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 11:43:01'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 11:38:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 11:10:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 11:43:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 11:15:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 11:27:07'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 11:41:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 11:39:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 11:12:07'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 11:24:06'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 11:13:54'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 11:30:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216862', 'Yayan Ruhian', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 11:34:04'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214999', 'Elly Sugigi', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 11:03:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213967', 'Luna Maya', 'FMIPA', 'THES', CONCAT(CURDATE(), ' 11:10:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212211', 'Raditya Dika', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 11:55:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211012', 'Omesh', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 11:46:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215255', 'Abimana Aryasatya', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 11:52:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213701', 'Rudi Hermawan', 'FKIP', 'CIRC', CONCAT(CURDATE(), ' 11:48:20'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211852', 'Ahmad Fauzan', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 11:22:04'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219168', 'Sule', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 11:36:32'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219150', 'Vanesha Prescilla', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 11:15:15'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212849', 'Nadine Chandrawinata', 'HUKUM', 'MAIN', CONCAT(CURDATE(), ' 11:42:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219859', 'Hesti Purwadinata', 'FISIP', 'CIRC', CONCAT(CURDATE(), ' 11:50:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212588', 'Oka Antara', 'FKIP', 'THES', CONCAT(CURDATE(), ' 11:13:10'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210887', 'Yayan Ruhian', 'HUKUM', 'MULTI', CONCAT(CURDATE(), ' 11:57:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219664', 'Kunto Aji', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 11:19:32'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 12:11:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 12:54:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 12:02:07'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 12:16:14'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 12:00:06'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 12:03:29'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 12:39:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 12:34:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 12:13:07'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 12:56:18'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 12:50:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 12:14:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 12:06:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 12:53:30'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 12:30:03'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 12:17:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 12:05:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 12:46:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 12:22:34'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 12:32:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 13:26:24'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 13:41:09'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 13:12:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 13:47:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 13:35:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 13:12:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 13:41:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 13:35:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 13:31:00'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 13:56:46'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 13:11:26'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 13:02:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 13:03:25'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 13:36:16'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 13:22:36'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 13:28:25'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 13:31:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 13:26:24'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 13:32:06'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 13:21:19'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 13:44:24'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 13:14:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 13:15:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 13:59:55'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 13:08:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216862', 'Yayan Ruhian', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 13:05:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214999', 'Elly Sugigi', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 13:42:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213967', 'Luna Maya', 'FMIPA', 'THES', CONCAT(CURDATE(), ' 13:04:26'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212211', 'Raditya Dika', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 13:37:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211012', 'Omesh', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 13:40:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215255', 'Abimana Aryasatya', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 13:47:50'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213701', 'Rudi Hermawan', 'FKIP', 'CIRC', CONCAT(CURDATE(), ' 13:43:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211852', 'Ahmad Fauzan', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 13:31:35'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219168', 'Sule', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 13:22:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219150', 'Vanesha Prescilla', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 13:52:54'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 14:16:05'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 14:45:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 14:19:08'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 14:46:30'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 14:03:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 14:37:40'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 14:45:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 14:42:26'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 14:31:47'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 14:13:01'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 14:45:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 14:57:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 14:22:22'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 14:14:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 14:52:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 14:54:09'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 14:54:04'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 14:48:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 14:20:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 14:09:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 14:49:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 14:41:57'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 14:20:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 14:22:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 14:09:29'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216862', 'Yayan Ruhian', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 14:28:59'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214999', 'Elly Sugigi', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 14:32:10'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213967', 'Luna Maya', 'FMIPA', 'THES', CONCAT(CURDATE(), ' 14:17:02'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212211', 'Raditya Dika', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 14:14:05'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211012', 'Omesh', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 14:24:13'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 15:24:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 15:03:31'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 15:27:24'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 15:53:18'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 15:16:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 15:48:31'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 15:04:13'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 15:11:43'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 15:29:49'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 15:13:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 15:28:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 15:43:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 15:53:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 15:08:52'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 15:53:42'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 15:25:23'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 15:41:50'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 15:39:54'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 15:56:44'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 15:49:28'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217509', 'Tukul Arwana', 'FKIP', 'MAIN', CONCAT(CURDATE(), ' 15:05:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210457', 'Hasan Basri', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 15:28:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219347', 'Syifa Hadju', 'FISIP', 'THES', CONCAT(CURDATE(), ' 15:23:49'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212066', 'Marcel Chandrawinata', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 15:56:13'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212647', 'Nadine Chandrawinata', 'FMIPA', 'REF', CONCAT(CURDATE(), ' 15:44:00'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212754', 'Deddy Corbuzier', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 16:00:56'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214119', 'Putri Anggraini', 'HUKUM', 'CIRC', CONCAT(CURDATE(), ' 16:23:10'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214210', 'Ernest Prakasa', 'FISIP', 'THES', CONCAT(CURDATE(), ' 16:09:39'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('218009', 'Yuni Shara', 'FISIP', 'MULTI', CONCAT(CURDATE(), ' 16:12:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211093', 'Eza Gionino', 'TEKNIK', 'REF', CONCAT(CURDATE(), ' 16:40:51'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211347', 'Herjunot Ali', 'FE', 'MAIN', CONCAT(CURDATE(), ' 16:30:55'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213411', 'Raffi Ahmad', 'FE', 'CIRC', CONCAT(CURDATE(), ' 16:14:46'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215667', 'Vino G. Bastian', 'FKIP', 'THES', CONCAT(CURDATE(), ' 16:05:17'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('215143', 'Umay Shahab', 'FMIPA', 'MULTI', CONCAT(CURDATE(), ' 16:04:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('212513', 'Citra Kirana', 'FKIP', 'REF', CONCAT(CURDATE(), ' 16:54:16'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('219112', 'Ariel Noah', 'FAPERTA', 'MAIN', CONCAT(CURDATE(), ' 16:00:37'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('217781', 'Tara Basro', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 16:21:34'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216424', 'Iko Uwais', 'FISIP', 'THES', CONCAT(CURDATE(), ' 16:51:19'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214757', 'Hesti Purwadinata', 'TEKNIK', 'MULTI', CONCAT(CURDATE(), ' 16:09:27'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211755', 'Gisella Anastasia', 'FISIP', 'REF', CONCAT(CURDATE(), ' 16:01:33'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('211081', 'Dimas Anggara', 'FISIP', 'MAIN', CONCAT(CURDATE(), ' 16:43:16'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('210319', 'Jefri Nichol', 'TEKNIK', 'CIRC', CONCAT(CURDATE(), ' 16:25:00'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('214053', 'Farid Aja', 'TEKNIK', 'THES', CONCAT(CURDATE(), ' 16:02:41'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('216559', 'Darius Sinathrya', 'FKIP', 'MULTI', CONCAT(CURDATE(), ' 16:06:58'));
INSERT INTO `visitor_count` (`member_id`, `member_name`, `institution`, `room_code`, `checkin_date`)
VALUES ('213976', 'Cinta Laura', 'FISIP', 'REF', CONCAT(CURDATE(), ' 16:37:39'));

-- 8. TABEL KHUSUS KONFIGURASI LAYAR TV (library_tv_settings)
CREATE TABLE IF NOT EXISTS `library_tv_settings` (
  `branch` varchar(50) NOT NULL,
  `slide_duration` int NOT NULL DEFAULT 25,
  `show_popups` tinyint(1) NOT NULL DEFAULT 1,
  `running_text` text NOT NULL,
  `marquee_speed` int NOT NULL DEFAULT 25,
  `operational_hours` varchar(100) NOT NULL DEFAULT 'Senin - Jumat | 08:00 - 16:00 WIB',
  `emergency_alert` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`branch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `library_tv_settings` (`branch`, `slide_duration`, `show_popups`, `running_text`, `marquee_speed`, `operational_hours`, `emergency_alert`)
VALUES 
  ('Pusat', 25, 1, 'Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.', 25, 'Senin - Jumat | 08:00 - 16:00 WIB', NULL),
  ('Cabang A', 20, 1, 'Selamat datang di UPA Perpustakaan Unri Kampus Cabang A. Layanan sirkulasi dan ruang baca lantai 2 buka hingga 16.00 WIB.', 25, 'Senin - Jumat | 08:00 - 16:00 WIB', NULL),
  ('Cabang B', 25, 1, 'Selamat datang di Layanan Perpustakaan Fakultas Kedokteran Unri.', 30, 'Senin - Jumat | 08:00 - 16:00 WIB', NULL)
ON DUPLICATE KEY UPDATE 
  `running_text` = VALUES(`running_text`),
  `operational_hours` = VALUES(`operational_hours`);

-- 9. VIEW LENGKAP UNTUK DASHBOARD & CMS SIRKULASI

-- View 1: Daftar Keterlambatan Pengembalian Buku & Denda
CREATE OR REPLACE VIEW `v_late_books` AS
SELECT 
  l.loan_id AS id,
  m.member_name AS memberName,
  m.member_id AS nim,
  m.inst_name AS faculty,
  b.title AS title,
  DATEDIFF(CURDATE(), l.due_date) AS daysLate,
  COALESCE(
    (SELECT SUM(f.debet - f.credit) 
     FROM fines f 
     WHERE f.member_id = m.member_id 
       AND (f.description LIKE CONCAT('%', b.title, '%') OR f.description LIKE '%Denda terlambat%')),
    DATEDIFF(CURDATE(), l.due_date) * 10000
  ) AS fine
FROM loan l
JOIN item i ON l.item_code = i.item_code
JOIN biblio b ON i.biblio_id = b.biblio_id
JOIN member m ON l.member_id = m.member_id
WHERE l.is_return = 0 AND l.due_date < CURDATE();

-- View 2: Statistik Realtime Kunjungan & Sirkulasi
CREATE OR REPLACE VIEW `v_dashboard_summary` AS
SELECT 
  (SELECT COUNT(*) FROM visitor_count WHERE DATE(checkin_date) = CURDATE()) AS total_visitors_today,
  (SELECT COUNT(*) FROM visitor_count WHERE DATE(checkin_date) = CURDATE() AND room_code = 'MAIN') AS visit_main_door,
  (SELECT COUNT(*) FROM visitor_count WHERE DATE(checkin_date) = CURDATE() AND room_code = 'CIRC') AS visit_circulation_room,
  (SELECT COUNT(*) FROM visitor_count WHERE DATE(checkin_date) = CURDATE() AND room_code = 'THES') AS visit_thesis_room,
  (SELECT COUNT(*) FROM loan WHERE DATE(loan_date) = CURDATE()) AS borrowing_today,
  (SELECT COUNT(*) FROM loan WHERE DATE(return_date) = CURDATE() AND is_return = 1) AS returning_today,
  (SELECT COUNT(*) FROM biblio) AS total_book_titles,
  (SELECT COUNT(*) FROM item) AS total_copies,
  (SELECT COUNT(*) FROM item WHERE item_code NOT IN (SELECT item_code FROM loan WHERE is_return = 0)) AS available_circulation,
  (SELECT COUNT(*) FROM loan WHERE is_return = 0 AND due_date < CURDATE()) AS overdue_books,
  (SELECT COUNT(*) FROM loan WHERE is_return = 0) AS books_currently_borrowed,
  (SELECT COUNT(DISTINCT member_id) FROM loan WHERE is_return = 0) AS members_currently_borrowing;

-- View 3: Distribusi Koleksi per Kelas DDC (000 - 900)
CREATE OR REPLACE VIEW `v_collection_classes` AS
SELECT 
  CONCAT('Kelas ', LEFT(COALESCE(NULLIF(classification, ''), '000'), 1), '00') AS ddc_class,
  COUNT(*) AS count
FROM biblio
GROUP BY LEFT(COALESCE(NULLIF(classification, ''), '000'), 1);

-- View 4: Distribusi Anggota per Fakultas
CREATE OR REPLACE VIEW `v_membership_by_faculty` AS
SELECT 
  COALESCE(NULLIF(inst_name, ''), 'Lainnya') AS faculty,
  COUNT(*) AS count
FROM member
GROUP BY inst_name;
