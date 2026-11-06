<?php
// ============================================================
// redis-cache.php — Redis Cache Layer untuk UPA Dashboard
// File ini HANYA berisi fungsi cache, tidak ada logika bisnis.
// Di-require oleh index.php dengan 1 baris saja.
// ============================================================

/**
 * Koneksi ke Redis.
 * Di Docker: Redis ada di service "redis" (hostname "redis")
 * Di XAMPP/lokal: fallback ke 127.0.0.1:6379
 * Jika Redis tidak tersedia sama sekali: return null (aman, tidak crash)
 */
function getRedis(): ?Redis {
    static $redis = null;
    static $tried = false;

    if ($tried) return $redis;
    $tried = true;

    $host = getenv('REDIS_HOST') ?: '127.0.0.1';
    $port = (int)(getenv('REDIS_PORT') ?: 6379);

    try {
        $r = new Redis();
        // connect dengan timeout 1 detik agar tidak menggantung
        $r->connect($host, $port, 1.0);
        $redis = $r;
    } catch (Exception $e) {
        // Redis tidak tersedia → aplikasi tetap jalan, langsung query DB
        $redis = null;
    }

    return $redis;
}

/**
 * Ambil data dari Redis cache.
 * @param string $key   Nama key cache (mis. "stats_pusat")
 * @return array|null   Data yang tersimpan, atau null jika tidak ada / kadaluwarsa
 */
function cacheGet(string $key): ?array {
    $redis = getRedis();
    if (!$redis) return null;

    try {
        $raw = $redis->get("upa:dashboard:$key");
        if ($raw === false) return null;
        return json_decode($raw, true) ?: null;
    } catch (Exception $e) {
        return null;
    }
}

/**
 * Simpan data ke Redis cache dengan TTL (waktu kadaluwarsa).
 * @param string $key    Nama key cache
 * @param array  $data   Data yang akan disimpan
 * @param int    $ttl    Berapa detik cache berlaku (default: 15 detik)
 */
function cacheSet(string $key, array $data, int $ttl = 15): void {
    $redis = getRedis();
    if (!$redis) {
        // Fallback: simpan ke file cache jika Redis tidak ada
        $cacheDir = __DIR__ . '/cache';
        if (!is_dir($cacheDir)) @mkdir($cacheDir, 0777, true);
        @file_put_contents(
            $cacheDir . '/redis_fallback_' . md5($key) . '.json',
            json_encode(['data' => $data, 'expires' => time() + $ttl])
        );
        return;
    }

    try {
        $redis->setEx(
            "upa:dashboard:$key",
            $ttl,
            json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
        );
    } catch (Exception $e) {
        // Diam saja jika gagal simpan — data tetap dikembalikan ke user
    }
}

/**
 * Fallback: baca dari file cache jika Redis tidak aktif.
 * TTL file cache = 15 detik sama seperti Redis.
 */
function cacheGetFallback(string $key): ?array {
    $file = __DIR__ . '/cache/redis_fallback_' . md5($key) . '.json';
    if (!file_exists($file)) return null;

    $raw = @file_get_contents($file);
    if (!$raw) return null;

    $cached = json_decode($raw, true);
    if (!$cached || ($cached['expires'] ?? 0) < time()) return null;

    return $cached['data'] ?? null;
}

/**
 * Helper utama: ambil data dari cache (Redis → File → null).
 * null berarti tidak ada cache valid → harus query database.
 */
function dashboardCacheGet(string $key): ?array {
    return cacheGet($key) ?? cacheGetFallback($key);
}

/**
 * Hapus semua cache upa:dashboard:* di Redis.
 * Berguna saat admin ingin force-refresh data.
 */
function cacheClear(): void {
    $redis = getRedis();
    if (!$redis) return;

    try {
        $keys = $redis->keys('upa:dashboard:*');
        if (!empty($keys)) $redis->del($keys);
    } catch (Exception $e) {}
}

/**
 * Cek status koneksi Redis (untuk endpoint ping/health check).
 */
function redisStatus(): array {
    $redis = getRedis();
    if (!$redis) {
        return ['connected' => false, 'message' => 'Redis tidak tersedia, menggunakan file cache fallback'];
    }

    try {
        $pong = $redis->ping('UPA');
        return [
            'connected' => true,
            'host'      => getenv('REDIS_HOST') ?: '127.0.0.1',
            'port'      => (int)(getenv('REDIS_PORT') ?: 6379),
            'message'   => "Redis OK — PING: $pong",
        ];
    } catch (Exception $e) {
        return ['connected' => false, 'message' => $e->getMessage()];
    }
}

