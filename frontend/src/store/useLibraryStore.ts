import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { LibraryStats, LateBook } from "../types";

const syncChannel = new BroadcastChannel('library_sync_channel');

const INITIAL_HOURLY_VISITORS = [15, 35, 48, 42, 20, 40, 30, 22, 18];
const INITIAL_HOURLY_BORROWING = [8, 18, 25, 20, 10, 18, 15, 12, 10];
const INITIAL_HOURLY_RETURNING = [10, 22, 28, 22, 12, 20, 16, 14, 12];
const INITIAL_HOURLY_ADMINISTRATION = [5, 12, 18, 15, 8, 14, 12, 10, 8];

const INITIAL_COLLECTION: Record<string, number> = {
  "Kelas 000": 6008,
  "Kelas 100": 1152,
  "Kelas 200": 1025,
  "Kelas 300": 12061,
  "Kelas 400": 1167,
  "Kelas 500": 4539,
  "Kelas 600": 10946,
  "Kelas 700": 535,
  "Kelas 800": 1303,
  "Kelas 900": 1073,
};

const DUMMY_NAMES = [
  "Budi Santoso", "Siti Nurhaliza", "Rudi Hermawan", "Anisa Rahmawati", "Fajar Nugraha",
  "Diana Putri", "Kevin Sanjaya", "Putri Anggraini", "Ahmad Fauzan", "Rini Wulandari",
  "Gilang Ramadhan", "Dewi Lestari", "Andi Pratama", "Nadia Vega", "Reza Rahadian",
  "Maya Safira", "Hendra Wijaya", "Indah Permatasari", "Surya Saputra", "Ayu Ting Ting",
  "Aditya Pratama", "Bayu Saputra", "Citra Kirana", "Dian Sastrowardoyo", "Eko Patrio",
  "Fina Melati", "Gita Gutawa", "Hasan Basri", "Iqbal Ramadhan", "Joko Anwar",
  "Kiki Fatmala", "Lina Marlina", "Maudy Ayunda", "Naufal Abiyyu", "Oki Setiana",
  "Prilly Latuconsina", "Qory Sandioriva", "Raffi Ahmad", "Syahrini", "Tora Sudiro",
  "Umar Kayam", "Vino G. Bastian", "Wulan Guritno", "Xavier Nur", "Yayan Ruhian",
  "Zaskia Sungkar", "Agung Hercules", "Bagas Pangestu", "Cinta Laura", "Deddy Corbuzier",
  "Elly Sugigi", "Farid Aja", "Gading Marten", "Hesti Purwadinata", "Indro Warkop",
  "Jefri Nichol", "Kaesang Pangarep", "Lesti Kejora", "Melaney Ricardo", "Nirina Zubir",
  "Omesh", "Pamela Bowie", "Qomar", "Rina Nose", "Sule", "Tukul Arwana",
  "Uus", "Vidi Aldiano", "Wendi Cagur", "Yuni Shara", "Zacky Winter",
  "Ariel Noah", "Bunga Citra", "Chelsea Islan", "Dimas Anggara", "Eza Gionino",
  "Fedi Nuril", "Gisella Anastasia", "Herjunot Ali", "Iko Uwais", "Joe Taslim",
  "Kunto Aji", "Luna Maya", "Marcel Chandrawinata", "Nadine Chandrawinata", "Oka Antara",
  "Pevita Pearce", "Raditya Dika", "Sandra Dewi", "Tara Basro", "Vanesha Prescilla",
  "Wafda Saifan", "Yuki Kato", "Zidni Hakim", "Abimana Aryasatya", "Bisma Karisma",
  "Chicco Jerikho", "Darius Sinathrya", "Ernest Prakasa", "Fauzi Baadilla", "Giring Ganesha",
  "Hanggini", "Irfan Hakim", "Jessica Mila", "Kiky Saputri", "Lukman Sardi",
  "Marthino Lio", "Nikita Willy", "Oza Rangkuti", "Putri Marino", "Raline Shah",
  "Syifa Hadju", "Tatjana Saphira", "Umay Shahab", "Valerie Thomas"
];
const DUMMY_FACULTIES = ["FAPERTA", "FMIPA", "FE", "TEKNIK", "FISIP", "HUKUM", "FKIP"];
const DUMMY_TITLES = [
  "Pemrograman Java", "Statistika Terapan", "Ekonomi Makro", "Dasar Jaringan Komputer",
  "Metodologi Penelitian", "Hukum Internasional", "Manajemen Keuangan", "Kalkulus Lanjut",
  "Agroekoteknologi", "Psikologi Komunikasi", "Struktur Data", "Kecerdasan Buatan"
];

function generateLateBook(id: string): LateBook {
  return {
    id,
    memberName: DUMMY_NAMES[Math.floor(Math.random() * DUMMY_NAMES.length)],
    nim: "21" + Math.floor(Math.random() * 10000).toString().padStart(4, "0"),
    title: DUMMY_TITLES[Math.floor(Math.random() * DUMMY_TITLES.length)],
    daysLate: Math.floor(Math.random() * 14) + 1,
    fine: (Math.floor(Math.random() * 14) + 1) * 10000,
    faculty: DUMMY_FACULTIES[Math.floor(Math.random() * DUMMY_FACULTIES.length)]
  };
}

export type Settings = {
  activeBranch: "Pusat" | "Cabang A" | "Cabang B";
  slideDuration: number;
  showPopups: boolean;
  logoUrl: string | null;
  runningText: string;
  marqueeSpeed: number;
  operationalHours: string;
  emergencyAlert: string | null;
};

const INITIAL_STATS: any = {
  total_visitors_today: 0,
  visit_main_door: 0,
  visit_circulation_room: 0,
  visit_thesis_room: 0,
  visit_multimedia_room: 0,
  visit_reference_room: 0,
  borrowing_today: 0,
  returning_today: 0,
  validation_today: 0,
  bebas_pustaka_today: 0,
  registration_today: 0,
  fine_payment_today: 0,
  administration_today: 0,
  total_transactions_today: 0,
  total_book_titles: 0,
  total_copies: 0,
  available_circulation: 0,
  availability_percent: 0,
  total_internal_resources: 0,
  popular_collections: [],
  total_borrowing_all: 0,
  total_returning_all: 0,
  total_extension_all: 0,
  books_currently_borrowed: 0,
  members_currently_borrowing: 0,
  overdue_books: 0,
  late_books: [],
  member_visitors: 0,
  reading_card_visitors: 0,
  general_visitors: 0,
  membership_by_faculty: [],
  membership_by_gender: [],
  membership_by_program: [],
  membership_by_age: [],
  ta_d3: 0,
  skripsi_s1: 0,
  tesis_s2: 0,
  disertasi_s3: 0,
  academic_works: [],
  admin_transactions: [
    { type: "peminjaman", count: 0 },
    { type: "pengembalian", count: 0 },
    { type: "validasi", count: 0 },
    { type: "bebas_pustaka", count: 0 },
    { type: "pendaftaran", count: 0 },
    { type: "pembayaran_denda", count: 0 },
  ],
  hourly_visitors: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  hourly_borrowing: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  hourly_returning: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  hourly_administration: [0, 0, 0, 0, 0, 0, 0, 0, 0],
  collection_by_class: {
    "Kelas 000": 0, "Kelas 100": 0, "Kelas 200": 0, "Kelas 300": 0, "Kelas 400": 0,
    "Kelas 500": 0, "Kelas 600": 0, "Kelas 700": 0, "Kelas 800": 0, "Kelas 900": 0,
  },
  last_updated: new Date().toISOString(),
  system_status: "online",
};

export const BRANCH_DEFAULT_STATS: Record<string, any> = {
  "Pusat": { ...INITIAL_STATS },
  "Cabang A": { ...INITIAL_STATS },
  "Cabang B": { ...INITIAL_STATS },
};

export type PopupNotification = {
  id: string;
  message: string;
  type: 'success' | 'info' | 'warning';
};

interface LibraryStore {
  stats: any;
  settings: Settings;
  lastUpdateDisplay: string;
  currentPopup: PopupNotification | null;
  updateSettings: (newSettings: Partial<Settings>) => void;
  fetchSettings: () => Promise<void>;
  saveSettings: (newSettings: Settings) => Promise<void>;
  fetchStats: () => Promise<void>;
  saveStats: (newStats: any) => Promise<void>;
  refreshTimestamp: () => void;
  startAutoRefresh: () => () => void;
  resetToSnapshot: () => void;
  clearPopup: () => void;
  updateStatsManually: (updates: any) => void;
  removeLateBook: (id: string) => void;
  addLateBook: (book: Omit<LateBook, 'id'>) => void;
}

// Selalu mulai dari nol saat app dibuka.
// Data nyata akan masuk otomatis dari fetchStats() setelah startAutoRefresh() dipanggil.
// Jika server mati → tetap nol. Jika server hidup → data masuk dari database.
const getSavedStats = () => {
  // Bersihkan cache lama agar tidak ada data stale yang tampil saat server offline
  if (typeof window !== 'undefined') {
    localStorage.removeItem('upa_stats');
  }
  return { ...INITIAL_STATS };
};

export const useLibraryStore = create<LibraryStore>()(
  (set, get) => ({
    stats: getSavedStats(),
    settings: {
      activeBranch: "Pusat",
      slideDuration: 25000,
      showPopups: true,
      logoUrl: null,
      runningText: "Selamat datang di UPA Perpustakaan Universitas Riau. Harap menjaga ketenangan dan kebersihan selama berada di ruang baca.",
      marqueeSpeed: 25,
      operationalHours: "Senin - Jumat | 08:00 - 16:00 WIB",
      emergencyAlert: null,
    },
    lastUpdateDisplay:
      new Date().toLocaleTimeString("id-ID", {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        timeZone: "Asia/Jakarta",
      }) + " WIB",
    currentPopup: null,

    updateSettings: (newSettings) => {
      const oldBranch = get().settings.activeBranch;
      set((state) => ({ settings: { ...state.settings, ...newSettings } }));
      if (newSettings.activeBranch && newSettings.activeBranch !== oldBranch) {
        get().fetchStats();
      }
    },

    updateStatsManually: (updates) => {
      set((state) => {
        const newStats = {
          ...state.stats,
          ...updates,
        };
        get().saveStats(newStats);
        return { stats: newStats };
      });
    },

    removeLateBook: (id) => {
      // Sinkronisasi hapus/selesaikan denda ke SLiMS Laragon MySQL
      const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
      const branch = get().settings.activeBranch || 'Pusat';
      fetch(`${slimsApi}?endpoint=resolve-fine&branch=${encodeURIComponent(branch)}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id, branch }),
      }).catch(() => {});

      set((state) => {
        const newLateBooks = state.stats.late_books.filter((b: any) => String(b.id) !== String(id));
        const newStats = {
          ...state.stats,
          late_books: newLateBooks,
          overdue_books: newLateBooks.length,
        };
        get().saveStats(newStats);
        return { stats: newStats };
      });
    },

    addLateBook: (book) => {
      // Sinkronisasi tambah denda ke SLiMS Laragon MySQL
      const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
      const branch = get().settings.activeBranch || 'Pusat';
      fetch(`${slimsApi}?endpoint=add-fine&branch=${encodeURIComponent(branch)}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ...book, branch }),
      }).catch(() => {});

      set((state) => {
        const newBook: LateBook = { ...book, id: `manual-${Date.now()}` };
        const newLateBooks = [newBook, ...(state.stats.late_books || [])];
        const newStats = {
          ...state.stats,
          late_books: newLateBooks,
          overdue_books: newLateBooks.length,
        };
        get().saveStats(newStats);
        return { stats: newStats };
      });
    },

    fetchSettings: async () => {
      // Ambil dari SLiMS Server / XAMPP Bridge
      const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
      const branch = get().settings.activeBranch || 'Pusat';
      try {
        const res = await fetch(`${slimsApi}?endpoint=settings&branch=${encodeURIComponent(branch)}`, { signal: AbortSignal.timeout(6000) });
        if (res.ok) {
          const json = await res.json();
          if (json.status === 'success' && json.data) {
            set({ settings: { ...get().settings, ...json.data } });
            return;
          }
        }
      } catch (err) {
        // Mode offline / API belum jalan
      }
    },

    saveSettings: async (newSettings) => {
      const oldBranch = get().settings.activeBranch;
      set({ settings: newSettings });
      // Broadcast to other tabs instantly
      syncChannel.postMessage({ type: 'SYNC_SETTINGS', payload: newSettings });

      // Simpan ke SLiMS XAMPP MySQL Bridge
      const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
      try {
        fetch(`${slimsApi}?endpoint=settings&branch=${encodeURIComponent(newSettings.activeBranch)}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(newSettings),
        }).catch(() => {});
      } catch (e) {}

      if (newSettings.activeBranch !== oldBranch) {
        await get().fetchStats();
      }
    },

    fetchStats: async () => {
      const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
      const branch = get().settings.activeBranch || 'Pusat';
      try {
        const res = await fetch(`${slimsApi}?endpoint=stats&branch=${encodeURIComponent(branch)}`, { signal: AbortSignal.timeout(10000) });
        if (res.ok) {
          const json = await res.json();
          if (json.status === 'success' && json.data) {
            const liveData = { ...json.data, system_status: 'online' };
            set({ stats: liveData });
            localStorage.setItem("upa_stats", JSON.stringify(liveData));
            return;
          }
        }
        // API menjawab tapi bukan success → data bermasalah
        set({ stats: { ...INITIAL_STATS, system_status: 'offline' } });
        localStorage.removeItem("upa_stats");
      } catch (err) {
        // ======================================================
        // XAMPP MATI: fetch gagal (timeout / connection refused)
        // → Kosongkan semua data ke nol & tandai offline
        // ======================================================
        console.warn("[LibraryStore] XAMPP offline – data dikosongkan:", err);
        set({ stats: { ...INITIAL_STATS, system_status: 'offline' } });
        localStorage.removeItem("upa_stats");
      }
    },

    saveStats: async (newStats) => {
      localStorage.setItem("upa_stats", JSON.stringify(newStats));
      // Broadcast to other tabs instantly
      syncChannel.postMessage({ type: 'SYNC_STATS', payload: newStats });
    },

    clearPopup: () => set({ currentPopup: null }),

    refreshTimestamp: () => {
      const ts = new Date();
      const timeStr =
        ts.toLocaleTimeString("id-ID", {
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
          timeZone: "Asia/Jakarta",
        }) + " WIB";

      set({ lastUpdateDisplay: timeStr });
    },

    resetToSnapshot: () => {
      if (typeof window !== 'undefined') {
        localStorage.removeItem('upa_stats');
      }
      // Set data ke nol & tandai sistem offline
      set({ stats: { ...INITIAL_STATS, system_status: 'offline' } });
    },

    startAutoRefresh: () => {
      get().refreshTimestamp();
      get().fetchStats();
      get().fetchSettings();
      const id = window.setInterval(() => {
        get().refreshTimestamp();
        get().fetchStats();
        get().fetchSettings();
      }, 8000);
      return () => window.clearInterval(id);
    },
  })
);

if (typeof window !== "undefined") {
  // Fallback storage listener
  window.addEventListener("storage", (e) => {
    if (e.key === "upa_stats" && e.newValue) {
      try {
        useLibraryStore.setState({ stats: JSON.parse(e.newValue) });
      } catch (err) {
        console.error("Failed to parse upa_stats from localStorage", err);
      }
    }
  });

  // Instant BroadcastChannel listener
  syncChannel.onmessage = (event) => {
    if (event.data?.type === 'SYNC_STATS' && event.data?.payload) {
      useLibraryStore.setState({ stats: event.data.payload });
    }
    if (event.data?.type === 'SYNC_SETTINGS' && event.data?.payload) {
      useLibraryStore.setState({ settings: event.data.payload });
    }
  };
}
