# Dashboard Statistik UPA Perpustakaan Unri - Dokumentasi Lengkap

## 🎯 Ringkasan Fitur

Dashboard statistik real-time untuk UPA Perpustakaan Universitas Riau dengan visualisasi data komprehensif, terorganisir dalam 3 kategori utama.

---

## 📊 Kategori Dashboard

### 1. **Kategori Koleksi** (Koleksi Buku)
- **URL:** `/collection`
- **Data yang ditampilkan:**
  - Koleksi buku (total judul & eksemplar)
  - Resource internal
  - Koleksi per kelas (000-900)
  - Buku populer (top 5 berdasarkan peminjaman)
  - Keterlambatan buku (nama, NIM, judul, denda, fakultas)

### 2. **Kategori Keanggotaan** (Pengunjung & Anggota)
- **URL:** `/membership`
- **Data yang ditampilkan:**
  - Total kunjungan hari ini (per lokasi layanan)
  - Keanggotaan (anggota pemustaka, kartu baca, pengunjung umum)
  - Breakdown keanggotaan:
    - Per fakultas
    - Per jenis kelamin
    - Per program (S1, S2, S3, D3)
    - Per umur
  - Tren aktivitas harian

### 3. **Kategori Tugas Akhir** (Karya Ilmiah)
- **URL:** `/academic-works`
- **Data yang ditampilkan:**
  - Tugas Akhir D3
  - Skripsi S1
  - Tesis S2
  - Karya ilmiah dosen
  - Daftar karya terbaru (dengan detail: judul, penulis, tanggal, fakultas)

---

## 🏠 Dashboard Utama (Home)

**URL:** `/`

### Fitur Utama:

#### 1. **Navigasi Kategori** (Bagian Atas)
Tiga kartu navigasi interaktif untuk mengakses kategori dashboard:
- Kategori Koleksi (Orange)
- Kategori Keanggotaan (Cyan)
- Kategori Tugas Akhir (Violet)

#### 2. **KPI Cards** (Metrik Kunci - 6 Kartu)
- **Kunjungan Hari Ini:** Per lokasi (Pintu Utama, Ruang Sirkulasi, Ruang Skripsi)
- **Transaksi Hari Ini:** Peminjaman, pengembalian, administrasi
- **Koleksi Buku:** Total judul, eksemplar, ketersediaan
- **Info Transaksi:** Total transaksi, buku sedang dipinjam, member aktif
- **Resource Internal:** Total resource tersimpan
- **Ringkasan Keterlambatan:** Total buku terlambat, kasus aktif, total denda

#### 3. **Grafik & Charts**
- **Activity Trend Chart:** Tren kunjungan & transaksi per jam (08:00-16:00)
- **Collection by Class Chart:** Distribusi koleksi per kelas DDC (000-900)
- **Membership Donut:** Komposisi keanggotaan (anggota, kartu baca, umum)
- **Academic Work Chart:** Distribusi tugas akhir (D3, S1, S2, Dosen)
- **Admin Transactions Card:** Breakdown transaksi administrasi
- **Total Transactions Card:** Total peminjaman, pengembalian, sedang dipinjam

#### 4. **Daftar Detail** (Bawah)
- **Late Books List:** Daftar lengkap buku terlambat dengan detail anggota
- **Popular Collections:** Top 5 koleksi paling populer berdasarkan peminjaman

#### 5. **Running Ticker** (Bagian Bawah)
Ticker informasi real-time yang menampilkan:
- Total judul buku
- Total eksemplar
- Buku tersedia
- Kunjungan hari ini
- Peminjaman/pengembalian
- Buku sedang dipinjam
- Dan lebih banyak lagi...

---

## 📈 Jenis Data yang Ditampilkan

### 1. **Koleksi**
- Total buku dalam berbagai klasifikasi
- Ketersediaan eksemplar
- Koleksi popular dan terbaru
- Internal resources

### 2. **Kunjungan**
- Per lokasi layanan (pintu utama, sirkulasi, skripsi)
- Per jenis anggota (pemustaka, kartu baca, umum)
- Breakdown demografis:
  - Per fakultas (FAPERTA, FMIPA, FE, FH, FKIP, dll)
  - Per jenis kelamin
  - Per program studi
  - Per kelompok umur

### 3. **Transaksi Administrasi**
- Peminjaman
- Pengembalian
- Validasi/Aktivasi
- Bebas Pustaka
- Pendaftaran
- Pembayaran Denda

### 4. **Karya Ilmiah**
- Tugas Akhir D3
- Skripsi S1
- Tesis S2
- Karya Ilmiah Dosen
- Dengan detail: judul, penulis, fakultas, tanggal

### 5. **Keterlambatan**
- Nama anggota
- NIM
- Judul buku
- Hari keterlambatan
- Total denda
- Fakultas anggota
- (Foto: opsional, siap untuk integrasi foto)

---

## 🎨 Desain & Styling

### Color Scheme:
- **Green (#16a34a):** Kunjungan (Visitors)
- **Orange/Amber (#ca8a04):** Koleksi (Collection)
- **Red (#ef4444):** Keterlambatan (Late Books)
- **Cyan (#0891b2):** Keanggotaan (Membership)
- **Violet (#7c3aed):** Tugas Akhir (Academic Works)
- **Indigo (#4f46e5):** Administrasi (Admin)
- **Pink (#ec4899):** Resource Internal

### Layout:
- Responsive design (mobile, tablet, desktop)
- Grid layout dengan proportional spacing
- Card-based UI dengan shadow & hover effects
- Smooth animations dan transitions

---

## 🔄 Real-Time Updates

### Simulasi Data Real-Time:
Dashboard menggunakan Zustand store dengan simulasi real-time yang:
- Update setiap 2.5 detik
- Mensimulasikan pengunjung (65% chance)
- Mensimulasikan transaksi (55% chance)
- Mensimulasikan submission karya ilmiah (15% chance)
- Mensimulasikan penambahan koleksi (20% chance)
- Update fluktuasi buku terlambat (12% chance)

---

## 🛠️ Teknologi & Tools

### Framework & Libraries:
- **React 18** - UI Framework
- **TypeScript** - Type Safety
- **Tailwind CSS** - Styling
- **Chart.js** - Visualisasi Data
- **React Router** - Navigation
- **Zustand** - State Management
- **Lucide React** - Icons

### Struktur Folder:
```
src/
├── components/
│   ├── Charts/
│   │   ├── AcademicWorkChart.tsx
│   │   ├── AcademicWorksLatest.tsx
│   │   ├── ActivityTrendChart.tsx
│   │   ├── AdminTransactionsCard.tsx
│   │   ├── CollectionClassChart.tsx
│   │   ├── LateBooksList.tsx
│   │   ├── MembershipBreakdown.tsx
│   │   ├── MembershipDonut.tsx
│   │   └── PopularCollections.tsx
│   ├── KPICards/
│   │   ├── CollectionCard.tsx
│   │   ├── InternalResourcesCard.tsx
│   │   ├── OverdueBooksSummary.tsx
│   │   ├── TotalTransactionsCard.tsx
│   │   ├── TransactionInfoCard.tsx
│   │   ├── TransactionsCard.tsx
│   │   └── VisitorsCard.tsx
│   ├── UI/
│   ├── Footer.tsx
│   ├── Header.tsx
│   └── RunningTicker.tsx
├── pages/
│   ├── Home.tsx
│   ├── CollectionPage.tsx
│   ├── MembershipPage.tsx
│   └── AcademicWorksPage.tsx
├── store/
│   └── useLibraryStore.ts
├── types/
│   └── index.ts
└── utils/
    ├── chartConfig.ts
    └── formatters.ts
```

---

## 🚀 Cara Menjalankan

### Development:
```bash
npm run dev
```
Akses di: `http://localhost:5173`

### Build for Production:
```bash
npm run build
```

### TypeScript Check:
```bash
npm run check
```

---

## 📱 Responsiveness

Dashboard dioptimalkan untuk:
- **Desktop:** Full-width display dengan semua fitur
- **Tablet:** Grid disesuaikan untuk layar menengah
- **Mobile:** Simplified layout (jika diperlukan, custom mobile view bisa ditambahkan)

---

## ✨ Fitur Tambahan yang Dapat Ditambahkan

### Future Enhancements:
1. **Export Data:**
   - Excel/CSV export
   - PDF reports

2. **Filters & Search:**
   - Filter per tanggal
   - Search anggota terlambat
   - Filter koleksi per kategori

3. **Real API Integration:**
   - Koneksi ke backend API
   - Real database integration
   - Live WebSocket updates

4. **Mobile App:**
   - Dedicated mobile layout
   - Progressive Web App (PWA)

5. **Advanced Analytics:**
   - Predictive analytics
   - Trend forecasting
   - Member behavior insights

6. **Customization:**
   - User preferences/themes
   - Customizable widgets
   - Dashboard layouts

---

## 📞 Support & Documentation

Untuk pertanyaan atau perbaikan, silakan hubungi tim development atau lihat dokumentasi di repository.

---

**Version:** 1.0.0  
**Last Updated:** 2024  
**Status:** Production Ready ✅
