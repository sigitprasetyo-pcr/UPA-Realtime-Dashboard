-- ============================================================
-- UPA Dashboard - Inisialisasi Database Lokal (MySQL)
-- Dijalankan otomatis saat container db-local pertama kali start
-- ============================================================

CREATE DATABASE IF NOT EXISTS `dashboard_realtime`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `dashboard_realtime`;

-- Tabel users untuk autentikasi login
CREATE TABLE IF NOT EXISTS `users` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(100) NOT NULL DEFAULT 'Administrator',
    `email`      VARCHAR(100) NOT NULL UNIQUE,
    `password`   VARCHAR(255) NOT NULL,
    `role`       VARCHAR(20)  NOT NULL DEFAULT 'admin',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert akun admin default
-- Password: admin123 (bcrypt hash)
INSERT IGNORE INTO `users` (`name`, `email`, `password`, `role`) VALUES
(
    'Admin Perpustakaan',
    'admin@upa.unri.ac.id',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',  -- password: password (ganti sesuai kebutuhan)
    'admin'
);

-- Catatan: Hash di atas adalah contoh. Saat container pertama start,
-- PHP API (getLocalXamppPDO) akan membuat akun admin dengan hash baru
-- menggunakan password_hash('admin123', PASSWORD_BCRYPT).

