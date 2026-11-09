import { useLibraryStore } from "../store/useLibraryStore";
import { StatusIndicator } from "./UI/StatusIndicator";
import { RefreshCw, Megaphone } from "lucide-react";

export function Footer() {
  const lastUpdateDisplay = useLibraryStore((s) => s.lastUpdateDisplay);
  const stats = useLibraryStore((s) => s.stats);
  const settings = useLibraryStore((s) => s.settings);
  const online = stats.system_status === "online";

  return (
    <footer className="w-full bg-white border-t-2 border-unri-green-100 px-2 sm:px-6 py-1.5 sm:py-2 flex items-center justify-between gap-2 sm:gap-4 text-xs shrink-0 relative z-20">
      <div className="flex items-center gap-1.5 sm:gap-2 px-2.5 sm:px-4 py-1 sm:py-1.5 rounded-full bg-gradient-to-r from-unri-green-50 to-unri-yellow-50 border border-unri-green-200 shadow-sm shrink-0">
        <StatusIndicator online={online} size="sm" />
        <span className="text-unri-green-700 font-black text-xs sm:text-base tracking-widest">LIVE</span>
        <span className="hidden sm:inline text-gray-300">•</span>
        <span className="hidden sm:inline text-[11px] font-extrabold text-unri-green-600 tracking-widest uppercase">
          Perpustakaan Aktif
        </span>
      </div>

      {/* Marquee Running Text */}
      <div className="flex-1 overflow-hidden mx-1 sm:mx-4 bg-gray-50/50 rounded-lg flex items-center gap-2 sm:gap-3 py-1 sm:py-1.5 px-2 sm:px-3 border border-gray-100/50">
        <Megaphone className="w-3.5 h-3.5 sm:w-4 sm:h-4 text-unri-yellow-500 shrink-0" />
        <div className="w-full overflow-hidden relative h-4 sm:h-5">
          <div
            className="absolute whitespace-nowrap animate-scroll-left flex items-center h-full text-xs sm:text-sm font-extrabold text-gray-800 tracking-wider"
            style={{ animationDuration: `${settings?.marqueeSpeed || 25}s` }}
          >
            {settings?.runningText || "Selamat datang di UPA Perpustakaan Universitas Riau."}
          </div>
        </div>
      </div>

      <div className="flex items-center gap-2 sm:gap-5 shrink-0">
        <div className="flex items-center gap-1.5 sm:gap-2 px-2 sm:px-3 py-1 sm:py-1.5 rounded-full bg-unri-green-50 border border-unri-green-200 shadow-sm">
          <span className={`font-black text-[10px] sm:text-xs ${online ? "text-unri-green-700" : "text-yellow-700"}`}>
            {online ? "ONLINE" : "OFFLINE"}
          </span>
          <span className="text-gray-400 hidden md:inline">•</span>
          <RefreshCw className="h-2.5 w-2.5 sm:h-3 sm:w-3 text-unri-green-600 hidden sm:inline" />
          <span className="text-gray-600 font-bold hidden md:inline">UPDATED</span>
          <span className="font-black text-unri-green-700 tabular-nums text-[10px] sm:text-xs">{lastUpdateDisplay}</span>
        </div>
      </div>
    </footer>
  );
}
