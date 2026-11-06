import { useEffect, useState } from "react";
import { useLibraryStore } from "../store/useLibraryStore";
import { useAdminStore } from "../store/useAdminStore";
import { BellRing, X } from "lucide-react";

const NOTIFICATIONS = [
  "Buku 'Machine Learning Dasar' telah dikembalikan oleh Budi Santoso",
  "Pendaftaran anggota baru: Siti Nurhaliza (TEKNIK)",
  "Pembayaran denda sebesar Rp 5.000 berhasil",
  "Mahasiswa Ahmad Fauzan telah menerbitkan surat Bebas Pustaka",
  "Kunjungan terbanyak hari ini: Ruang Sirkulasi",
];

export function PopupNotification() {
  const settings = useLibraryStore((s) => s.settings);
  const isAuthenticated = useAdminStore((s) => s.isAuthenticated);
  const [currentNotif, setCurrentNotif] = useState<string | null>(null);
  const [isVisible, setIsVisible] = useState(false);

  // Determine if popup should be active
  const shouldShow = settings?.showPopups && isAuthenticated;

  useEffect(() => {
    if (!shouldShow) {
      setIsVisible(false);
      return;
    }

    const interval = setInterval(() => {
      // Pick random notification
      const randomMsg = NOTIFICATIONS[Math.floor(Math.random() * NOTIFICATIONS.length)];
      setCurrentNotif(randomMsg);
      setIsVisible(true);

      // Hide after 5 seconds
      setTimeout(() => {
        setIsVisible(false);
      }, 5000);
    }, 10000); // Show popup every 10 seconds

    return () => clearInterval(interval);
  }, [shouldShow]);

  if (!shouldShow) return null;

  return (
    <div 
      className={`fixed bottom-12 right-6 z-50 bg-white shadow-2xl rounded-xl border border-green-100 p-4 max-w-sm transition-all duration-500 transform ${
        isVisible ? "translate-y-0 opacity-100" : "translate-y-10 opacity-0 pointer-events-none"
      }`}
    >
      <div className="flex items-start gap-3 relative">
        <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center shrink-0">
          <BellRing className="h-5 w-5 text-green-600 animate-[wiggle_1s_ease-in-out_infinite]" />
        </div>
        <div className="flex-1 pr-6">
          <h4 className="text-sm font-bold text-gray-900 mb-1">Aktivitas Baru</h4>
          <p className="text-sm text-gray-600 leading-snug">{currentNotif}</p>
        </div>
        <button 
          onClick={() => setIsVisible(false)}
          className="absolute top-0 right-0 p-1 text-gray-400 hover:text-gray-600 bg-gray-50 hover:bg-gray-100 rounded-md transition-colors"
        >
          <X className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}
