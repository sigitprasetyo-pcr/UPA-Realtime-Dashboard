import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { LibraryStats, LateBook } from "../types";
import { supabase } from "../lib/supabase";

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
  total_visitors_today: 416,

  // Transaksi
  borrowing_today: 140,
  returning_today: 158,
  validation_today: 12,
  bebas_pustaka_today: 8,
  registration_today: 5,
  fine_payment_today: 15,
  administration_today: 115,
  total_transactions_today: 413,

  // Koleksi
  total_book_titles: 39815,
  total_copies: 134668,
  available_circulation: 133977,
  availability_percent: 99.5,
  total_internal_resources: 2456,
  popular_collections: [
    { id: "1", title: "Pemrograman Web Modern", author: "Adi Nugroho", borrowCount: 245, class: "Kelas 000" },
    { id: "2", title: "Database Design", author: "C.J. Date", borrowCount: 198, class: "Kelas 100" },
    { id: "3", title: "Algoritma & Struktur Data", author: "Sedgewick", borrowCount: 187, class: "Kelas 300" },
    { id: "4", title: "Clean Code", author: "Robert C. Martin", borrowCount: 156, class: "Kelas 600" },
    { id: "5", title: "Desain Basis Data", author: "Connolly", borrowCount: 142, class: "Kelas 000" },
    { id: "6", title: "Jaringan Komputer", author: "Kurose", borrowCount: 130, class: "Kelas 000" },
    { id: "7", title: "Rekayasa Perangkat Lunak", author: "Pressman", borrowCount: 115, class: "Kelas 600" },
  ],

  // Total Transaksi
  total_borrowing_all: 392605,
  total_returning_all: 391916,
  total_extension_all: 14502,
  books_currently_borrowed: 689,
  members_currently_borrowing: 396,
  overdue_books: 104,
  late_books: Array.from({ length: 104 }, (_, i) => generateLateBook(`init-${i}`)),

  // Keanggotaan
  member_visitors: 396,
  reading_card_visitors: 0,
  general_visitors: 1,
  membership_by_faculty: [
    { faculty: "FAPERTA", count: 145 },
    { faculty: "FMIPA", count: 132 },
    { faculty: "FE", count: 98 },
    { faculty: "FH", count: 87 },
    { faculty: "FKIP", count: 156 },
  ],
  membership_by_gender: [
    { category: "Laki-laki", count: 298 },
    { category: "Perempuan", count: 420 },
  ],
  membership_by_program: [
    { category: "S1", count: 485 },
    { category: "S2", count: 156 },
    { category: "S3", count: 45 },
    { category: "D3", count: 32 },
  ],
  membership_by_age: [
    { category: "18-22", count: 245 },
    { category: "23-27", count: 312 },
    { category: "28-32", count: 124 },
    { category: "33+", count: 37 },
  ],

  // Tugas Akhir
  ta_d3: 2,
  skripsi_s1: 15,
  tesis_s2: 3,
  disertasi_s3: 1,
  academic_works: [
    { id: "1", title: "Pengaruh Algoritma Machine Learning pada Prediksi Cuaca", author: "Budi Santoso", nim: "21102001", type: "skripsi_s1", submissionDate: "2024-09-01T08:15:00", faculty: "FMIPA" },
    { id: "2", title: "Sistem Informasi Manajemen Perpustakaan", author: "Siti Nurhaliza", nim: "21102002", type: "ta_d3", submissionDate: "2024-09-01T09:30:00", faculty: "TEKNIK" },
    { id: "3", title: "Analisis Sentimen Menggunakan NLP", author: "Ahmad Fauzan", nim: "21102003", type: "tesis_s2", submissionDate: "2024-09-01T10:45:00", faculty: "FMIPA" },
    { id: "4", title: "Pengembangan Model Deep Learning untuk Diagnosa Medis", author: "Dr. Hendra Wijaya", nim: "21102004", type: "disertasi_s3", submissionDate: "2024-09-01T11:20:00", faculty: "KEDOKTERAN" },
    { id: "5", title: "Rancang Bangun Jaringan Sensor Nirkabel", author: "Gilang Ramadhan", nim: "21102005", type: "skripsi_s1", submissionDate: "2024-09-01T13:10:00", faculty: "TEKNIK" },
    { id: "6", title: "Optimasi Query pada Database Terdistribusi", author: "Dewi Lestari", nim: "21102006", type: "skripsi_s1", submissionDate: "2024-09-01T14:05:00", faculty: "FMIPA" },
  ],

  // Admin Transactions
  admin_transactions: [
    { type: "peminjaman", count: 140 },
    { type: "pengembalian", count: 158 },
    { type: "validasi", count: 12 },
    { type: "bebas_pustaka", count: 8 },
    { type: "pendaftaran", count: 5 },
    { type: "pembayaran_denda", count: 15 },
  ],

  // Hourly Data
  hourly_visitors: [...INITIAL_HOURLY_VISITORS],
  hourly_borrowing: [...INITIAL_HOURLY_BORROWING],
  hourly_returning: [...INITIAL_HOURLY_RETURNING],
  hourly_administration: [...INITIAL_HOURLY_ADMINISTRATION],

  // Koleksi per Kelas
  collection_by_class: { ...INITIAL_COLLECTION },

  last_updated: new Date().toISOString(),
  system_status: "online",
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

const getSavedStats = () => {
  if (typeof window !== 'undefined') {
    const saved = localStorage.getItem('upa_stats');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (e) {
        return { ...INITIAL_STATS };
      }
    }
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

    updateSettings: (newSettings) => set((state) => ({ settings: { ...state.settings, ...newSettings } })),

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
      set((state) => {
        const newLateBooks = state.stats.late_books.filter((b: any) => b.id !== id);
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
      try {
        const branch = get().settings.activeBranch;
        const { data, error } = await supabase
          .from('library_settings')
          .select('data')
          .eq('branch', branch)
          .single();
        if (!error && data?.data && Object.keys(data.data).length > 0) {
          set({ settings: { ...get().settings, ...data.data } });
        }
      } catch (e) {
        console.error('Failed to fetch settings', e);
      }
    },

    saveSettings: async (newSettings) => {
      set({ settings: newSettings });
      // Broadcast to other tabs instantly
      syncChannel.postMessage({ type: 'SYNC_SETTINGS', payload: newSettings });

      try {
        const { data, error } = await supabase
          .from('library_settings')
          .upsert({ branch: newSettings.activeBranch, data: newSettings }, { onConflict: 'branch' })
          .select();
        if (error) {
          console.error('[Supabase saveSettings Error]:', error.message, error.details || error);
        } else {
          console.log('[Supabase saveSettings Berhasil Disimpan]:', data);
        }
      } catch (e) {
        console.error('Failed to save settings', e);
      }
    },

    fetchStats: async () => {
      try {
        const branch = get().settings.activeBranch;
        const { data, error } = await supabase
          .from('library_stats')
          .select('data')
          .eq('branch', branch)
          .single();
        if (!error && data?.data && Object.keys(data.data).length > 0) {
          set({ stats: data.data });
          localStorage.setItem("upa_stats", JSON.stringify(data.data));
        }
      } catch (e) {
        console.error('Failed to fetch stats', e);
      }
    },

    saveStats: async (newStats) => {
      localStorage.setItem("upa_stats", JSON.stringify(newStats));
      // Broadcast to other tabs instantly
      syncChannel.postMessage({ type: 'SYNC_STATS', payload: newStats });

      try {
        const branch = get().settings.activeBranch;
        const { data, error } = await supabase
          .from('library_stats')
          .upsert({ branch, data: newStats }, { onConflict: 'branch' })
          .select();
        if (error) {
          console.error('[Supabase saveStats Error]:', error.message, error.details || error);
        } else {
          console.log('[Supabase saveStats Berhasil Disimpan]:', data);
        }
      } catch (e) {
        console.error('Failed to save stats API', e);
      }
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

      set((state) => {
        const s = { ...state.stats };

        const currentHour = ts.getHours();
        let hourIdx = currentHour - 8;
        if (hourIdx < 0) hourIdx = 0;
        if (hourIdx > 8) hourIdx = 8;

        if (Math.random() < 0.65) {
          const randDoor = Math.random();
          let dMain = 0;
          let dCirc = 0;
          let dThesis = 0;

          if (randDoor < 0.3) dMain = 1;
          else if (randDoor < 0.8) dCirc = Math.floor(Math.random() * 2) + 1;
          else dThesis = 1;

          s.visit_main_door += dMain;
          s.visit_circulation_room += dCirc;
          s.visit_thesis_room += dThesis;
          s.total_visitors_today =
            s.visit_main_door + s.visit_circulation_room + s.visit_thesis_room;

          const totalAdd = dMain + dCirc + dThesis;
          const mRand = Math.random();
          if (mRand < 0.7) {
            s.member_visitors += totalAdd;
          } else if (mRand < 0.9) {
            s.reading_card_visitors += totalAdd;
          } else {
            s.general_visitors += totalAdd;
          }

          const newHourlyVisitors = [...s.hourly_visitors];
          newHourlyVisitors[hourIdx] = (newHourlyVisitors[hourIdx] || 0) + totalAdd;
          s.hourly_visitors = newHourlyVisitors;
        }

        if (Math.random() < 0.55) {
          const tRand = Math.random();
          if (tRand < 0.35) {
            const add = 1;
            s.borrowing_today += add;
            s.total_borrowing_all += add;
            s.books_currently_borrowed += add;
            s.available_circulation = Math.max(0, s.available_circulation - add);
            if (Math.random() < 0.6) s.members_currently_borrowing += 1;
            if (s.admin_transactions[0]) s.admin_transactions[0].count += add;

            const newHourlyBorrowing = [...s.hourly_borrowing];
            newHourlyBorrowing[hourIdx] = (newHourlyBorrowing[hourIdx] || 0) + add;
            s.hourly_borrowing = newHourlyBorrowing;
          } else if (tRand < 0.70) {
            const add = 1;
            s.returning_today += add;
            s.total_returning_all += add;
            if (s.books_currently_borrowed > 0) s.books_currently_borrowed -= add;
            s.available_circulation += add;
            if (s.admin_transactions[1]) s.admin_transactions[1].count += add;

            const newHourlyReturning = [...s.hourly_returning];
            newHourlyReturning[hourIdx] = (newHourlyReturning[hourIdx] || 0) + add;
            s.hourly_returning = newHourlyReturning;
          } else if (tRand < 0.80) {
            const add = 1;
            s.validation_today += add;
            if (s.admin_transactions[2]) s.admin_transactions[2].count += add;
          } else if (tRand < 0.85) {
            const add = 1;
            s.bebas_pustaka_today += add;
            if (s.admin_transactions[3]) s.admin_transactions[3].count += add;
          } else if (tRand < 0.90) {
            const add = 1;
            s.registration_today += add;
            if (s.admin_transactions[4]) s.admin_transactions[4].count += add;
          } else {
            const add = 1;
            s.fine_payment_today += add;
            if (s.admin_transactions[5]) s.admin_transactions[5].count += add;
          }

          s.administration_today = s.validation_today + s.bebas_pustaka_today + s.registration_today + s.fine_payment_today;
          s.total_transactions_today =
            s.borrowing_today + s.returning_today + s.administration_today;
          s.availability_percent = Number(
            ((s.available_circulation / s.total_copies) * 100).toFixed(1),
          );
        }

        if (Math.random() < 0.15) {
          const aRand = Math.random();
          if (aRand < 0.4) s.skripsi_s1 += 1;
          else if (aRand < 0.65) s.ta_d3 += 1;
          else if (aRand < 0.85) s.tesis_s2 += 1;
          else s.disertasi_s3 += 1;
        }

        // Simulating collection additions
        if (Math.random() < 0.2) {
          const classes = [
            "Kelas 000", "Kelas 100", "Kelas 200", "Kelas 300", "Kelas 400",
            "Kelas 500", "Kelas 600", "Kelas 700", "Kelas 800", "Kelas 900",
          ];
          const randomClass = classes[Math.floor(Math.random() * classes.length)];
          const addTitle = Math.random() < 0.7 ? 1 : 2;
          const addCopies = addTitle * (Math.floor(Math.random() * 3) + 1);

          const newCollection = { ...s.collection_by_class };
          newCollection[randomClass] = (newCollection[randomClass] || 0) + addTitle;
          s.collection_by_class = newCollection;

          s.total_book_titles += addTitle;
          s.total_copies += addCopies;
          s.available_circulation += addCopies;
          s.availability_percent = Number(
            ((s.available_circulation / s.total_copies) * 100).toFixed(1),
          );
        }

        s.last_updated = ts.toISOString();
        s.system_status = "online";

        // Random Popup Logic
        let newPopup = state.currentPopup;
        if (state.settings.showPopups && !newPopup && Math.random() < 0.15) {
          const popupOptions = [
            { message: "Pengunjung baru masuk ke Ruang Sirkulasi", type: "info" },
            { message: "1 Buku berhasil dikembalikan", type: "success" },
            { message: "Pendaftaran anggota baru berhasil", type: "success" },
            { message: "Buku terlambat dikembalikan (Denda tercatat)", type: "warning" },
            { message: "Transaksi Bebas Pustaka selesai", type: "info" },
          ];
          const chosen = popupOptions[Math.floor(Math.random() * popupOptions.length)];
          newPopup = { id: Date.now().toString(), message: chosen.message, type: chosen.type as any };
        }

        get().saveStats(s);

        return {
          lastUpdateDisplay: timeStr,
          stats: s,
          currentPopup: newPopup,
        };
      });
    },

    resetToSnapshot: () => {
      const freshStats = JSON.parse(JSON.stringify(INITIAL_STATS));
      get().saveStats(freshStats);
      set({
        stats: freshStats,
      });
    },

    startAutoRefresh: () => {
      const id = window.setInterval(() => {
        get().refreshTimestamp();
        get().fetchSettings();
        // TV screen also periodically syncs just in case storage event misses
        get().fetchStats();
      }, 2500);
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
