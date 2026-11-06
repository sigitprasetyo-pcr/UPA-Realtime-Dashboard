import { useLibraryStore } from "../../store/useLibraryStore";
import { Database, Server, HardDrive, Archive } from "lucide-react";
import { formatNumber } from "../../utils/formatters";

export function InternalResourcesCard() {
  const stats = useLibraryStore((s) => s.stats);

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-pink-500" />
        <Database className="h-5 w-5 text-pink-600" strokeWidth={2.2} />
        <span className="kpi-title text-pink-700 tracking-wider">
          RESOURCE INTERNAL
        </span>
      </div>

      <div className="flex-1 flex flex-col min-h-0 overflow-hidden p-2 gap-2">
        {/* Main stat */}
        <div className="flex-[3] flex flex-col items-center justify-center bg-gradient-to-b from-white to-pink-50/30 rounded-xl border border-pink-100/50 shadow-sm">
          <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-pink-500 to-rose-600 flex items-center justify-center shadow-md mb-2">
            <Server className="h-6 w-6 text-white drop-shadow-sm" />
          </div>
          <div className="flex items-baseline gap-1.5">
            <p className="text-4xl font-black text-pink-600 leading-none tracking-tight">
              {formatNumber(stats.total_internal_resources)}
            </p>
            <span className="text-[12px] font-bold text-pink-400">File</span>
          </div>
          <p className="text-[11px] font-bold text-gray-400 uppercase tracking-wider mt-1">
            Total Resource Tersimpan
          </p>
        </div>
        
        {/* Breakdown */}
        <div className="flex-[2] grid grid-cols-2 gap-2 min-h-0">
          <div className="bg-pink-50/80 border border-pink-200/60 rounded-xl p-3 flex flex-col justify-center items-center text-center gap-1 shadow-sm">
            <HardDrive className="h-5 w-5 text-pink-500 mb-0.5" />
            <span className="text-[10px] font-bold text-pink-600/80 uppercase leading-none">Database</span>
            <span className="text-lg font-black text-pink-700 leading-tight">
              {formatNumber(Math.floor(stats.total_internal_resources * 0.417))}
            </span>
          </div>
          <div className="bg-rose-50/80 border border-rose-200/60 rounded-xl p-3 flex flex-col justify-center items-center text-center gap-1 shadow-sm">
            <Archive className="h-5 w-5 text-rose-500 mb-0.5" />
            <span className="text-[10px] font-bold text-rose-600/80 uppercase leading-none">Arsip Digital</span>
            <span className="text-lg font-black text-rose-700 leading-tight">
              {formatNumber(stats.total_internal_resources - Math.floor(stats.total_internal_resources * 0.417))}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
}
