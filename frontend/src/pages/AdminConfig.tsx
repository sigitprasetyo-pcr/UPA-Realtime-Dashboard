import { useState, useEffect, useRef } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAdminStore } from "../store/useAdminStore";
import { useLibraryStore, Settings } from "../store/useLibraryStore";
import { 
  CheckCircle, LogOut, X, AlertTriangle, RotateCcw, 
  LayoutDashboard, MonitorPlay, Database, Megaphone,
  Users, BookUp, BookDown, FileEdit, BellRing, Library, BookCopy, BookCheck, BookOpen
} from "lucide-react";

export default function AdminConfig() {
  const isAuthenticated = useAdminStore((s) => s.isAuthenticated);
  const logout = useAdminStore((s) => s.logout);
  const navigate = useNavigate();
  const location = useLocation();

  const settings = useLibraryStore((s) => s.settings);
  const stats = useLibraryStore((s) => s.stats);
  const fetchSettings = useLibraryStore((s) => s.fetchSettings);
  const updateSettings = useLibraryStore((s) => s.updateSettings);
  const saveSettings = useLibraryStore((s) => s.saveSettings);
  const resetToSnapshot = useLibraryStore((s) => s.resetToSnapshot);
  const updateStatsManually = useLibraryStore((s) => s.updateStatsManually);
  const removeLateBook = useLibraryStore((s) => s.removeLateBook);
  const addLateBook = useLibraryStore((s) => s.addLateBook);
  const fetchStats = useLibraryStore((s) => s.fetchStats);

  const [activeTab, setActiveTab] = useState<"overview" | "display" | "data" | "circulation">("overview");

  // Display Settings States
  const [activeBranch, setActiveBranch] = useState<Settings["activeBranch"]>(settings.activeBranch);
  const [slideDuration, setSlideDuration] = useState(settings.slideDuration / 1000);
  const [showPopups, setShowPopups] = useState(settings.showPopups);
  const [logoPreview, setLogoPreview] = useState<string | null>(settings.logoUrl);
  const [runningText, setRunningText] = useState(settings.runningText || "");
  const [marqueeSpeed, setMarqueeSpeed] = useState(settings.marqueeSpeed || 25);
  const [operationalHours, setOperationalHours] = useState(settings.operationalHours || "");
  const [emergencyAlert, setEmergencyAlert] = useState(settings.emergencyAlert || "");
  const [isSaving, setIsSaving] = useState(false);
  const [hasLoadedSettings, setHasLoadedSettings] = useState(false);

  // Data Override States
  const [manualVisitors, setManualVisitors] = useState(stats.total_visitors_today);
  const [manualBorrowing, setManualBorrowing] = useState(stats.borrowing_today);

  // Circulation Search & Add State
  const [searchQuery, setSearchQuery] = useState("");
  const [showAddForm, setShowAddForm] = useState(false);
  const [newLateBook, setNewLateBook] = useState({
    memberName: "", nim: "", faculty: "TEKNIK", title: "", daysLate: 1, fine: 10000
  });

  // Popup States
  const [toastMessage, setToastMessage] = useState<{title: string, message: string, type: "success" | "info"} | null>(null);
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);
  const [showResetConfirm, setShowResetConfirm] = useState(false);
  
  const showToast = (title: string, message: string, type: "success" | "info" = "success") => {
    setToastMessage({ title, message, type });
    setTimeout(() => setToastMessage(null), 3500);
  };
  
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    fetchSettings();
    fetchStats();
    
    // Poll stats periodically to ensure perfect sync across different browsers/devices
    const interval = setInterval(() => {
      fetchStats();
      // fetchSettings() dipanggil sekali saja agar tidak mereset input form saat admin sedang mengetik
    }, 2500);
    
    return () => clearInterval(interval);
  }, [fetchSettings, fetchStats]);

  // Sync form dari settings store HANYA SATU KALI saat settings pertama kali dimuat
  // (bukan setiap settings berubah, agar input user tidak ter-reset saat menyimpan)
  useEffect(() => {
    if (!hasLoadedSettings && (
      settings.runningText || settings.operationalHours || settings.slideDuration
    )) {
      setActiveBranch(settings.activeBranch);
      setSlideDuration(settings.slideDuration / 1000);
      setShowPopups(settings.showPopups);
      setLogoPreview(settings.logoUrl);
      setRunningText(settings.runningText || "");
      setMarqueeSpeed(settings.marqueeSpeed || 25);
      setOperationalHours(settings.operationalHours || "");
      setEmergencyAlert(settings.emergencyAlert || "");
      setHasLoadedSettings(true);
    }
  }, [settings, hasLoadedSettings]);

  useEffect(() => {
    if (!isAuthenticated) {
      navigate("/login");
    }
  }, [isAuthenticated, navigate]);

  useEffect(() => {
    if (location.state?.loginSuccess) {
      showToast("Login Berhasil!", "Selamat datang di Sistem CMS Admin UPA.");
      window.history.replaceState({}, document.title);
    }
  }, [location]);

  const handleBranchChange = (newBranch: Settings["activeBranch"]) => {
    setActiveBranch(newBranch);
    updateSettings({ activeBranch: newBranch });
  };

  const handleSaveDisplay = async () => {
    setIsSaving(true);
    const newSettings: Settings = {
      activeBranch,
      slideDuration: slideDuration * 1000,
      showPopups,
      logoUrl: logoPreview,
      runningText,
      marqueeSpeed: Number(marqueeSpeed),
      operationalHours,
      emergencyAlert: emergencyAlert.trim() === "" ? null : emergencyAlert,
    };
    await saveSettings(newSettings);
    // Setelah simpan, izinkan sync ulang form jika settings dari server berbeda
    setHasLoadedSettings(false);
    await fetchStats();
    setIsSaving(false);
    showToast("Berhasil Disimpan", `Pengaturan layar ${activeBranch} berhasil disinkronkan ke TV!`);
  };

  const handleUpdateData = () => {
    updateStatsManually({
      total_visitors_today: Number(manualVisitors),
      borrowing_today: Number(manualBorrowing)
    });
    showToast("Data Diperbarui", "Data simulasi berhasil di-override manual!", "info");
  };

  const handleAddLateBook = (e: React.FormEvent) => {
    e.preventDefault();
    addLateBook({
      memberName: newLateBook.memberName,
      nim: newLateBook.nim,
      faculty: newLateBook.faculty,
      title: newLateBook.title,
      daysLate: Number(newLateBook.daysLate),
      fine: Number(newLateBook.fine),
      photo: undefined
    });
    setNewLateBook({ memberName: "", nim: "", faculty: "TEKNIK", title: "", daysLate: 1, fine: 10000 });
    setShowAddForm(false);
    showToast("Data Ditambahkan", `Data denda untuk ${newLateBook.memberName} berhasil masuk sistem.`);
  };

  const handleLogoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => setLogoPreview(reader.result as string);
      reader.readAsDataURL(file);
    }
  };

  const confirmLogout = () => {
    logout();
    navigate("/");
  };

  const handleResetData = () => {
    resetToSnapshot();
    setShowResetConfirm(false);
    showToast("Sistem Direset", "Semua data statistik telah dikembalikan ke kondisi awal.");
  };

  if (!isAuthenticated) return null;

  return (
    <div className="h-screen bg-gray-50 flex overflow-hidden">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 animate-bounce-in">
          <div className={`bg-white border-l-4 shadow-xl rounded-xl px-6 py-4 flex items-center gap-4 min-w-[320px] ${
            toastMessage.type === 'success' ? 'border-unri-green-500' : 'border-blue-500'
          }`}>
            {toastMessage.type === 'success' ? (
              <CheckCircle className="w-8 h-8 text-unri-green-500" />
            ) : (
              <Database className="w-8 h-8 text-blue-500" />
            )}
            <div className="flex-1">
              <h3 className="font-bold text-gray-900">{toastMessage.title}</h3>
              <p className="text-sm text-gray-500">{toastMessage.message}</p>
            </div>
            <button onClick={() => setToastMessage(null)} className="text-gray-400 hover:text-gray-600 transition-colors">
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>
      )}

      {/* Logout Modal */}
      {showLogoutConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm px-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm overflow-hidden animate-fade-scale">
            <div className="p-6 text-center">
              <div className="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-4">
                <AlertTriangle className="w-8 h-8 text-red-500" />
              </div>
              <h3 className="text-xl font-extrabold text-gray-900 mb-2">Konfirmasi Keluar</h3>
              <p className="text-gray-500 text-sm leading-relaxed">Apakah Anda yakin ingin keluar dari sesi Admin?</p>
            </div>
            <div className="bg-gray-50 px-6 py-4 flex gap-3 justify-end border-t border-gray-100">
              <button onClick={() => setShowLogoutConfirm(false)} className="px-4 py-2.5 text-gray-600 font-bold hover:bg-gray-200 rounded-xl transition-colors flex-1">Batal</button>
              <button onClick={confirmLogout} className="px-4 py-2.5 bg-red-500 hover:bg-red-600 text-white font-bold rounded-xl shadow-lg transition-colors flex-1 flex items-center justify-center gap-2"><LogOut className="w-4 h-4" /> Keluar</button>
            </div>
          </div>
        </div>
      )}

      {/* Reset Modal */}
      {showResetConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm px-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm overflow-hidden animate-fade-scale">
            <div className="p-6 text-center">
              <div className="w-16 h-16 bg-orange-50 rounded-full flex items-center justify-center mx-auto mb-4">
                <RotateCcw className="w-8 h-8 text-orange-500" />
              </div>
              <h3 className="text-xl font-extrabold text-gray-900 mb-2">Reset Sistem Penuh</h3>
              <p className="text-gray-500 text-sm leading-relaxed">Aksi ini akan mereset seluruh angka simulasi kembali ke kondisi snapshot awal.</p>
            </div>
            <div className="bg-gray-50 px-6 py-4 flex gap-3 justify-end border-t border-gray-100">
              <button onClick={() => setShowResetConfirm(false)} className="px-4 py-2.5 text-gray-600 font-bold hover:bg-gray-200 rounded-xl transition-colors flex-1">Batal</button>
              <button onClick={handleResetData} className="px-4 py-2.5 bg-orange-500 hover:bg-orange-600 text-white font-bold rounded-xl shadow-lg transition-colors flex-1 flex items-center justify-center gap-2"><RotateCcw className="w-4 h-4" /> Reset</button>
            </div>
          </div>
        </div>
      )}

      {/* Sidebar */}
      <aside className="w-72 bg-unri-green-900 text-white flex flex-col shadow-2xl z-20 shrink-0">
        <div className="px-6 py-8 border-b border-white/10">
          <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center mb-4">
            <Database className="w-7 h-7 text-unri-yellow-400" />
          </div>
          <h1 className="text-2xl font-extrabold tracking-tight">UPA CMS</h1>
          <p className="text-unri-green-200/70 text-sm mt-1">Admin Management System</p>
        </div>

        <nav className="flex-1 px-4 py-6 space-y-2">
          <button
            onClick={() => setActiveTab("overview")}
            className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl font-bold transition-all ${activeTab === "overview" ? "bg-unri-green-800 text-white shadow-inner" : "text-unri-green-100 hover:bg-white/5"}`}
          >
            <LayoutDashboard className="w-5 h-5" /> Ringkasan Admin
          </button>
          <button
            onClick={() => setActiveTab("display")}
            className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl font-bold transition-all ${activeTab === "display" ? "bg-unri-green-800 text-white shadow-inner" : "text-unri-green-100 hover:bg-white/5"}`}
          >
            <MonitorPlay className="w-5 h-5" /> Konfigurasi Layar TV
          </button>
          <button
            onClick={() => setActiveTab("data")}
            className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl font-bold transition-all ${activeTab === "data" ? "bg-unri-green-800 text-white shadow-inner" : "text-unri-green-100 hover:bg-white/5"}`}
          >
            <FileEdit className="w-5 h-5" /> Manajemen Data
          </button>
          <button
            onClick={() => setActiveTab("circulation")}
            className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl font-bold transition-all ${activeTab === "circulation" ? "bg-unri-green-800 text-white shadow-inner" : "text-unri-green-100 hover:bg-white/5"}`}
          >
            <BookDown className="w-5 h-5" /> Sirkulasi & Denda
          </button>
        </nav>

        <div className="p-4 border-t border-white/10">
          <button
            onClick={() => navigate("/")}
            className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-white/10 hover:bg-white/20 rounded-xl font-bold text-sm transition-all mb-2"
          >
            <MonitorPlay className="w-4 h-4" /> Lihat Dashboard Layar
          </button>
          <button
            onClick={() => setShowLogoutConfirm(true)}
            className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-red-500/80 hover:bg-red-500 rounded-xl font-bold text-sm transition-all"
          >
            <LogOut className="w-4 h-4" /> Keluar Sesi
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <main className="flex-1 flex flex-col h-full overflow-hidden bg-gray-50 relative">
        <header className="px-8 py-6 bg-white border-b border-gray-200 flex items-center justify-between sticky top-0 z-10">
          <h2 className="text-2xl font-extrabold text-gray-800 flex items-center gap-2">
            {activeTab === "overview" && "Ringkasan Aktivitas Perpustakaan"}
            {activeTab === "display" && "Konfigurasi Penayangan TV"}
            {activeTab === "data" && "Manajemen Override Data Statistik"}
            {activeTab === "circulation" && "Sirkulasi & Daftar Denda Mahasiswa"}
          </h2>
          <div className="flex items-center gap-3 px-4 py-2 bg-unri-green-50 rounded-full border border-unri-green-200">
            <span className="w-2.5 h-2.5 bg-unri-green-500 rounded-full animate-pulse"></span>
            <span className="text-sm font-bold text-unri-green-700">Sistem Aktif</span>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto p-8">
          <div className="max-w-[1200px] mx-auto">

            {/* TAB: OVERVIEW */}
            {activeTab === "overview" && (
              <div className="space-y-8 animate-fade-scale">
                {/* Database Connection Status Banner */}
                <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-5 flex flex-col md:flex-row md:items-center justify-between gap-4 shadow-sm">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-emerald-500 text-white rounded-xl flex items-center justify-center font-black">
                      <Database className="w-5 h-5" />
                    </div>
                    <div>
                      <h4 className="font-extrabold text-emerald-900 text-base">
                        {settings.activeBranch === "Pusat"
                          ? "Terhubung ke Database SLiMS 9 Bulian (Pusat)"
                          : `Sistem Aktif: ${settings.activeBranch === "Cabang A" ? "Kampus Gobah (Cabang A)" : "Kampus Dumai (Cabang B)"}`}
                      </h4>
                      <p className="text-xs text-emerald-700 font-medium">
                        {settings.activeBranch === "Pusat"
                          ? (stats.connected_to ? `Terkoneksi: ${stats.connected_to}` : "Host: 172.16.9.8:24002 | Database: urlibslims (Server SLiMS UNRI)")
                          : `Layanan: ${settings.activeBranch} | Sinkronisasi Server Bridge`}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="w-3 h-3 bg-emerald-500 rounded-full animate-ping"></span>
                    <span className="text-xs font-bold text-emerald-800 bg-emerald-100 px-3 py-1.5 rounded-full border border-emerald-300">
                      Aktif: {settings.activeBranch}
                    </span>
                  </div>
                </div>

                {/* SLiMS Master Catalog & Inventory */}
                <div>
                  <h3 className="text-lg font-black text-gray-800 mb-4 flex items-center gap-2">
                    <Library className="w-5 h-5 text-unri-green-600" />
                    Statistik Koleksi & Inventaris ({settings.activeBranch})
                  </h3>
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-amber-50 text-amber-600 rounded-xl flex items-center justify-center shrink-0">
                        <Library className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Total Koleksi (Judul)</p>
                        <p className="text-2xl font-black text-gray-900">{stats.total_book_titles}</p>
                        <p className="text-[10px] text-gray-400 font-medium">SLiMS: Total of Collections</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center shrink-0">
                        <BookCopy className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Total Eksemplar Fisik</p>
                        <p className="text-2xl font-black text-gray-900">{stats.total_copies}</p>
                        <p className="text-[10px] text-gray-400 font-medium">SLiMS: Total of Items</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-purple-50 text-purple-600 rounded-xl flex items-center justify-center shrink-0">
                        <BookOpen className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Sedang Dipinjam</p>
                        <p className="text-2xl font-black text-purple-700">{stats.books_currently_borrowed}</p>
                        <p className="text-[10px] text-gray-400 font-medium">SLiMS: Lent</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-emerald-50 text-emerald-600 rounded-xl flex items-center justify-center shrink-0">
                        <BookCheck className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Tersedia di Rak</p>
                        <p className="text-2xl font-black text-emerald-600">{stats.available_circulation}</p>
                        <p className="text-[10px] text-gray-400 font-medium">SLiMS: Available</p>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Aktivitas Sirkulasi & Kunjungan Hari Ini */}
                <div>
                  <h3 className="text-lg font-black text-gray-800 mb-4 flex items-center gap-2">
                    <LayoutDashboard className="w-5 h-5 text-blue-600" />
                    Aktivitas Transaksi Hari Ini (Buku Tamu & Sirkulasi Real-time)
                  </h3>
                  <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center shrink-0">
                        <Users className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Kunjungan Hari Ini</p>
                        <p className="text-2xl font-black text-gray-900">{stats.total_visitors_today}</p>
                        <p className="text-[10px] text-gray-400 font-medium">Dari visitor_count SLiMS</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-emerald-50 text-emerald-600 rounded-xl flex items-center justify-center shrink-0">
                        <BookUp className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Dipinjam Hari Ini</p>
                        <p className="text-2xl font-black text-gray-900">{stats.borrowing_today}</p>
                        <p className="text-[10px] text-gray-400 font-medium">Dari loan SLiMS hari ini</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 bg-orange-50 text-orange-600 rounded-xl flex items-center justify-center shrink-0">
                        <BookDown className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Dikembalikan Hari Ini</p>
                        <p className="text-2xl font-black text-gray-900">{stats.returning_today}</p>
                        <p className="text-[10px] text-gray-400 font-medium">Dari loan pengembalian</p>
                      </div>
                    </div>

                    <div className="bg-white p-5 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-4 cursor-pointer hover:border-red-200 transition-colors" onClick={() => setActiveTab("circulation")}>
                      <div className="w-12 h-12 bg-red-50 text-red-600 rounded-xl flex items-center justify-center shrink-0">
                        <AlertTriangle className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="text-xs font-bold text-gray-500">Total Tunggakan Overdue</p>
                        <p className="text-2xl font-black text-red-600">{stats.overdue_books || stats.late_books?.length || 0}</p>
                        <p className="text-[10px] text-red-500 font-semibold underline">Lihat 104 data di Sirkulasi &rarr;</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* TAB: DISPLAY */}
            {activeTab === "display" && (
              <div className="space-y-8 animate-fade-scale">
                
                <section className="bg-white p-8 rounded-2xl border border-gray-100 shadow-sm">
                  <h3 className="text-lg font-bold text-gray-900 mb-6 flex items-center gap-2"><MonitorPlay className="w-5 h-5 text-unri-green-600"/> Pengaturan Umum Tampilan</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-3">Mode Tampilan</label>
                      <div className="flex gap-4">
                        {(["Pusat", "Cabang A", "Cabang B"] as const).map((branch) => (
                          <label key={branch} className="flex items-center gap-2 cursor-pointer group">
                            <input type="radio" name="branch" value={branch} checked={activeBranch === branch} onChange={(e) => handleBranchChange(e.target.value as Settings["activeBranch"])} className="w-5 h-5 text-unri-green-600 focus:ring-unri-green-500 cursor-pointer" />
                            <span className="font-semibold text-gray-700">{branch}</span>
                          </label>
                        ))}
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-3">Durasi Slide (Detik)</label>
                      <input type="number" min="5" max="120" value={slideDuration} onChange={(e) => setSlideDuration(Number(e.target.value))} className="w-32 rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-unri-green-500 focus:ring-2 focus:ring-unri-green-500/20 font-bold p-3 text-center transition-colors" />
                    </div>
                  </div>
                </section>

                <section className="bg-white p-8 rounded-2xl border border-gray-100 shadow-sm">
                  <h3 className="text-lg font-bold text-gray-900 mb-6 flex items-center gap-2"><Megaphone className="w-5 h-5 text-unri-yellow-500"/> Konten Komunikasi</h3>
                  <div className="space-y-6">
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">Teks Pengumuman Berjalan (Marquee)</label>
                      <textarea value={runningText} onChange={(e) => setRunningText(e.target.value)} rows={2} className="w-full rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-unri-green-500 focus:ring-2 focus:ring-unri-green-500/20 font-medium p-3 resize-none transition-colors" placeholder="Masukkan pengumuman..." />
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">Jam Operasional Layanan</label>
                        <input type="text" value={operationalHours} onChange={(e) => setOperationalHours(e.target.value)} className="w-full rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-unri-green-500 focus:ring-2 focus:ring-unri-green-500/20 font-medium p-3 transition-colors" placeholder="Senin - Jumat | 08:00 - 16:00 WIB" />
                      </div>
                      <div>
                        <label className="block text-sm font-bold text-gray-700 mb-2">Kecepatan Teks Berjalan (Detik)</label>
                        <input type="number" min="5" max="100" value={marqueeSpeed} onChange={(e) => setMarqueeSpeed(Number(e.target.value))} className="w-full rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-unri-green-500 focus:ring-2 focus:ring-unri-green-500/20 font-bold p-3 transition-colors" />
                        <p className="text-xs text-gray-500 mt-1">Makin kecil = makin cepat (Standar: 25).</p>
                      </div>
                    </div>
                  </div>
                </section>

                <section className="bg-red-50 p-8 rounded-2xl border border-red-100 shadow-sm relative overflow-hidden">
                  <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/10 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
                  <h3 className="text-lg font-bold text-red-800 mb-2 flex items-center gap-2"><BellRing className="w-5 h-5 text-red-600"/> Peringatan Darurat TV (Emergency Alert)</h3>
                  <p className="text-sm text-red-600/80 mb-4 font-medium max-w-2xl">Jika diisi, akan memunculkan banner merah raksasa secara paksa di seluruh layar TV perpustakaan. Kosongkan untuk menonaktifkan.</p>
                  <input type="text" value={emergencyAlert} onChange={(e) => setEmergencyAlert(e.target.value)} className="w-full rounded-xl border border-red-300 bg-white focus:border-red-500 focus:ring-2 focus:ring-red-500/20 font-bold text-red-700 p-4 shadow-inner transition-colors" placeholder="Cth: PERPUSTAKAAN AKAN TUTUP DALAM 15 MENIT. HARAP SEGERA..." />
                </section>

                <div className="flex justify-end pt-4">
                  <button onClick={handleSaveDisplay} disabled={isSaving} className={`px-10 py-4 w-full md:w-auto ${isSaving ? 'bg-gray-400' : 'bg-unri-green-600 hover:bg-unri-green-700'} text-white font-extrabold rounded-xl shadow-lg transition-all active:scale-95 text-lg flex items-center justify-center gap-3`}>
                    {isSaving ? "Menyimpan ke TV..." : "Terapkan Konfigurasi ke Layar TV"}
                  </button>
                </div>
              </div>
            )}

            {/* TAB: DATA */}
            {activeTab === "data" && (
              <div className="space-y-8 animate-fade-scale">
                <section className="bg-white p-8 rounded-2xl border border-gray-100 shadow-sm">
                  <h3 className="text-lg font-bold text-gray-900 mb-2 flex items-center gap-2"><FileEdit className="w-5 h-5 text-blue-500"/> Input Manual / Override Statistik</h3>
                  <p className="text-sm text-gray-500 mb-6 font-medium">Ubah angka di bawah ini untuk memodifikasi simulasi sistem saat ini.</p>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">Total Kunjungan Hari Ini</label>
                      <input type="number" value={manualVisitors} onChange={(e) => setManualVisitors(Number(e.target.value))} className="w-full rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 font-bold p-3 text-lg transition-colors" />
                      <p className="text-sm text-gray-500 mt-2 font-medium">Angka riil di layar TV saat ini: <strong className="text-blue-600">{stats.total_visitors_today}</strong></p>
                    </div>
                    <div>
                      <label className="block text-sm font-bold text-gray-700 mb-2">Total Peminjaman Hari Ini</label>
                      <input type="number" value={manualBorrowing} onChange={(e) => setManualBorrowing(Number(e.target.value))} className="w-full rounded-xl border border-gray-300 bg-gray-50 shadow-sm focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20 font-bold p-3 text-lg transition-colors" />
                      <p className="text-sm text-gray-500 mt-2 font-medium">Angka riil di layar TV saat ini: <strong className="text-blue-600">{stats.borrowing_today}</strong></p>
                    </div>
                  </div>
                  
                  <div className="flex justify-end border-t border-gray-100 pt-6">
                    <button onClick={handleUpdateData} className="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-md transition-all active:scale-95 flex items-center justify-center gap-2">
                      <Database className="w-4 h-4" /> Timpa Data Simulasi
                    </button>
                  </div>
                </section>

                <section className="bg-red-50 p-8 rounded-2xl border border-red-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-6">
                  <div>
                    <h3 className="text-xl font-bold text-red-800 mb-2">Reset Sistem & Snapshot</h3>
                    <p className="text-base text-red-700/80 font-medium">Mengembalikan seluruh angka (kunjungan, peminjaman) ke keadaan bersih (snapshot awal).</p>
                  </div>
                  <button onClick={() => setShowResetConfirm(true)} className="shrink-0 px-6 py-4 bg-red-600 hover:bg-red-700 text-white font-bold rounded-xl shadow-md transition-colors flex items-center gap-3 text-lg">
                    <RotateCcw className="w-5 h-5" /> Reset Semua Data
                  </button>
                </section>
              </div>
            )}

            {/* TAB: CIRCULATION */}
            {activeTab === "circulation" && (
              <div className="space-y-6 animate-fade-scale">
                
                {/* Add Late Book Form Section */}
                <section className="bg-white p-8 rounded-2xl border border-gray-100 shadow-sm">
                  <div className="flex items-center justify-between mb-6">
                    <h3 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <BookDown className="w-6 h-6 text-unri-green-600"/> Tambah Tagihan Denda Mahasiswa
                    </h3>
                    <button 
                      onClick={() => setShowAddForm(!showAddForm)}
                      className="px-4 py-2 bg-unri-green-50 text-unri-green-700 font-bold rounded-xl border border-unri-green-200 hover:bg-unri-green-100 transition-colors text-sm"
                    >
                      {showAddForm ? "Batal Menambahkan" : "+ Tambah Data Baru"}
                    </button>
                  </div>

                  {showAddForm && (
                    <form onSubmit={handleAddLateBook} className="bg-gray-50 p-6 rounded-xl border border-gray-200 animate-fade-scale mb-4">
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                          <label className="block text-sm font-bold text-gray-700 mb-2">Nama Lengkap</label>
                          <input required type="text" value={newLateBook.memberName} onChange={(e) => setNewLateBook({...newLateBook, memberName: e.target.value})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500" placeholder="Cth: Budi Santoso" />
                        </div>
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <label className="block text-sm font-bold text-gray-700 mb-2">NIM</label>
                            <input required type="text" value={newLateBook.nim} onChange={(e) => setNewLateBook({...newLateBook, nim: e.target.value})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500" placeholder="Cth: 2110..." />
                          </div>
                          <div>
                            <label className="block text-sm font-bold text-gray-700 mb-2">Fakultas</label>
                            <select value={newLateBook.faculty} onChange={(e) => setNewLateBook({...newLateBook, faculty: e.target.value})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500">
                              {["FAPERTA", "FMIPA", "FE", "TEKNIK", "FISIP", "HUKUM", "FKIP", "KEDOKTERAN"].map(f => <option key={f} value={f}>{f}</option>)}
                            </select>
                          </div>
                        </div>
                        <div className="md:col-span-2">
                          <label className="block text-sm font-bold text-gray-700 mb-2">Judul Buku</label>
                          <input required type="text" value={newLateBook.title} onChange={(e) => setNewLateBook({...newLateBook, title: e.target.value})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500" placeholder="Cth: Algoritma dan Struktur Data" />
                        </div>
                        <div>
                          <label className="block text-sm font-bold text-gray-700 mb-2">Terlambat (Hari)</label>
                          <input required type="number" min="1" value={newLateBook.daysLate} onChange={(e) => setNewLateBook({...newLateBook, daysLate: Number(e.target.value)})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500" />
                        </div>
                        <div>
                          <label className="block text-sm font-bold text-gray-700 mb-2">Nominal Denda (Rp)</label>
                          <input required type="number" min="0" value={newLateBook.fine} onChange={(e) => setNewLateBook({...newLateBook, fine: Number(e.target.value)})} className="w-full rounded-xl border border-gray-300 bg-white p-3 focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500" />
                        </div>
                      </div>
                      <div className="flex justify-end">
                        <button type="submit" className="px-6 py-3 bg-unri-green-600 hover:bg-unri-green-700 text-white font-bold rounded-xl shadow-md transition-colors flex items-center gap-2">
                          Simpan Data Denda
                        </button>
                      </div>
                    </form>
                  )}
                </section>

                <section className="bg-white p-8 rounded-2xl border border-gray-100 shadow-sm">
                  <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                    <h3 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <AlertTriangle className="w-6 h-6 text-red-500"/> Daftar Keterlambatan Pengembalian Buku
                    </h3>
                    <div className="flex items-center gap-3">
                      <div className="relative">
                        <input 
                          type="text" 
                          placeholder="Cari Nama atau NIM..." 
                          value={searchQuery}
                          onChange={(e) => setSearchQuery(e.target.value)}
                          className="w-full md:w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white focus:ring-2 focus:ring-unri-green-500/20 focus:border-unri-green-500 transition-colors text-sm font-medium"
                        />
                        <svg className="w-5 h-5 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                      </div>
                      <div className="px-4 py-2 bg-red-50 text-red-700 rounded-full font-bold text-sm border border-red-200 shrink-0">
                        Total Tunggakan: {stats.late_books?.length || 0}
                      </div>
                    </div>
                  </div>

                  {(() => {
                    const filteredBooks = (stats.late_books || []).filter((book: any) => 
                      book.memberName.toLowerCase().includes(searchQuery.toLowerCase()) || 
                      book.nim.toLowerCase().includes(searchQuery.toLowerCase())
                    );

                    if (!stats.late_books || stats.late_books.length === 0) {
                      return (
                        <div className="text-center py-16 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                          <CheckCircle className="w-12 h-12 text-unri-green-500 mx-auto mb-3" />
                          <h4 className="text-lg font-bold text-gray-700">Tidak ada keterlambatan saat ini</h4>
                          <p className="text-gray-500">Semua buku telah dikembalikan tepat waktu.</p>
                        </div>
                      );
                    }

                    if (filteredBooks.length === 0) {
                      return (
                        <div className="text-center py-16 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                          <h4 className="text-lg font-bold text-gray-700 mb-2">Pencarian Tidak Ditemukan</h4>
                          <p className="text-gray-500">Tidak ada mahasiswa dengan nama atau NIM "{searchQuery}".</p>
                        </div>
                      );
                    }

                    return (
                      <div className="overflow-x-auto">
                        <table className="w-full text-left border-collapse">
                          <thead>
                            <tr className="bg-gray-50 border-y border-gray-200 text-gray-500 text-sm">
                              <th className="px-4 py-3 font-bold">Data Mahasiswa</th>
                              <th className="px-4 py-3 font-bold">Judul Buku</th>
                              <th className="px-4 py-3 font-bold text-center">Terlambat (Hari)</th>
                              <th className="px-4 py-3 font-bold text-right">Nominal Denda</th>
                              <th className="px-4 py-3 font-bold text-center w-32">Aksi</th>
                            </tr>
                          </thead>
                          <tbody className="divide-y divide-gray-100">
                            {filteredBooks.map((book: any) => (
                            <tr key={book.id} className="hover:bg-red-50/50 transition-colors">
                              <td className="px-4 py-4">
                                <div className="flex items-center gap-3">
                                  {book.photo ? (
                                    <img src={book.photo} alt={book.memberName} className="w-10 h-10 rounded-full object-cover shadow-sm" />
                                  ) : (
                                    <div className="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center text-red-600 font-bold">
                                      {book.memberName.charAt(0)}
                                    </div>
                                  )}
                                  <div>
                                    <p className="font-bold text-gray-900">{book.memberName}</p>
                                    <p className="text-xs font-semibold text-gray-500">{book.nim} • {book.faculty}</p>
                                  </div>
                                </div>
                              </td>
                              <td className="px-4 py-4 text-sm font-semibold text-gray-700">
                                {book.title}
                              </td>
                              <td className="px-4 py-4 text-center">
                                <span className="inline-flex items-center gap-1 bg-orange-100 text-orange-700 px-2.5 py-1 rounded-md text-xs font-black">
                                  {book.daysLate} Hari
                                </span>
                              </td>
                              <td className="px-4 py-4 text-right">
                                <span className="text-red-600 font-black text-sm">
                                  Rp {book.fine.toLocaleString('id-ID')}
                                </span>
                              </td>
                              <td className="px-4 py-4 text-center">
                                <button
                                  onClick={() => {
                                    removeLateBook(book.id);
                                    showToast("Denda Lunas", `Mahasiswa ${book.memberName} telah menyelesaikan pembayaran denda.`, "success");
                                  }}
                                  className="px-3 py-1.5 bg-unri-green-50 text-unri-green-700 hover:bg-unri-green-600 hover:text-white font-bold text-xs rounded-lg transition-colors"
                                  title="Tandai Sudah Bayar / Lunas"
                                >
                                  Selesaikan
                                </button>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  );
                })()}
                </section>
              </div>
            )}

          </div>
        </div>
      </main>
    </div>
  );
}
