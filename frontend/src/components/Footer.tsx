import { useLibraryStore } from "../store/useLibraryStore";
import { StatusIndicator } from "./UI/StatusIndicator";
import { RefreshCw, Megaphone } from "lucide-react";

export function Footer() {
  const lastUpdateDisplay = useLibraryStore((s) => s.lastUpdateDisplay);
  const stats = useLibraryStore((s) => s.stats);
  const settings = useLibraryStore((s) => s.settings);
  const online = stats.system_status === "online";

  return (
    <footer className="w-full bg-white border-t-2 border-unri-green-100 px-6 py-2 flex items-center justify-between gap-4 text-xs shrink-0 relative z-20">
      <div className="flex items-center gap-2 px-4 py-1.5 rounded-full bg-gradient-to-r from-unri-green-50 to-unri-yellow-50 border border-unri-green-200 shadow-sm shrink-0">
        <StatusIndicator online={online} size="sm" />
        <span className="text-unri-green-700 font-black text-base tracking-widest">LIVE</span>
        <span className="text-gray-300">•</span>
        <span className="text-[11px] font-extrabold text-unri-green-600 tracking-widest uppercase">
          Perpustakaan Aktif
        </span>
      </div>

      {/* Marquee Running Text */}
      <div className="flex-1 overflow-hidden mx-4 bg-gray-50/50 rounded-lg flex items-center gap-3 py-1.5 px-3 border border-gray-100/50">
        <Megaphone className="w-4 h-4 text-unri-yellow-500 shrink-0" />
        <div className="w-full overflow-hidden relative h-5">
          <div
            className="absolute whitespace-nowrap animate-scroll-left flex items-center h-full text-sm font-extrabold text-gray-800 tracking-wider"
            style={{ animationDuration: `${settings?.marqueeSpeed || 25}s` }}
          >
            {settings?.runningText || "Selamat datang di UPA Perpustakaan Universitas Riau."}
          </div>
        </div>
      </div>

      <div className="flex items-center gap-5 shrink-0">
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-unri-green-50 border border-unri-green-200 shadow-sm">
          <span className={`font-black ${online ? "text-unri-green-700" : "text-yellow-700"}`}>
            {online ? "SYSTEM ONLINE" : "CONNECTION LOST"}
          </span>
          <span className="text-gray-400">•</span>
          <RefreshCw className="h-3 w-3 text-unri-green-600" />
          <span className="text-gray-600 font-bold">DATA UPDATED</span>
          <span className="font-black text-unri-green-700 tabular-nums">{lastUpdateDisplay}</span>
        </div>
      </div>
    </footer>
  );
}
