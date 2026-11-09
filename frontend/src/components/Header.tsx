import { useRealTimeClock } from "../hooks/useRealTimeClock";
import { useLibraryStore } from "../store/useLibraryStore";
import { UnriLogo } from "./UI/UnriLogo";
import { Clock, RefreshCw } from "lucide-react";

export function Header() {
  const { dateString, timeString } = useRealTimeClock();
  const lastUpdateDisplay = useLibraryStore((s) => s.lastUpdateDisplay);
  const settings = useLibraryStore((s) => s.settings);

  const branch = settings?.activeBranch || "Pusat";
  const branchLabel = {
    "Pusat": "Kampus Bina Widya (Pusat)",
    "Cabang A": "Kampus Gobah (Cabang A)",
    "Cabang B": "Kampus Dumai (Cabang B)",
  }[branch] || branch;

  const branchBadgeColor = {
    "Pusat": "bg-emerald-50 text-emerald-700 border-emerald-200",
    "Cabang A": "bg-amber-50 text-amber-700 border-amber-200",
    "Cabang B": "bg-blue-50 text-blue-700 border-blue-200",
  }[branch] || "bg-gray-100 text-gray-700 border-gray-200";

  return (
    <header className="w-full px-3 sm:px-5 py-2 sm:py-2.5 bg-white border-b-2 border-unri-green-100 shadow-sm shrink-0">
      <div className="w-full flex items-center justify-between gap-2 sm:gap-4">
        <div className="flex items-center gap-2 sm:gap-3 min-w-0">
          <div className="shrink-0 flex items-center justify-center">
            {settings?.logoUrl ? (
              <img src={settings.logoUrl} alt="Logo" className="h-8 sm:h-10 object-contain" />
            ) : (
              <UnriLogo size="sm" />
            )}
          </div>
          <div className="flex flex-col min-w-0">
            <h1 className="text-sm sm:text-lg md:text-2xl font-black text-unri-green-800 tracking-tight leading-tight truncate sm:whitespace-nowrap">
              PERPUSTAKAAN UNIVERSITAS RIAU
            </h1>
            <div className="flex items-center gap-1.5 sm:gap-2 mt-0.5 flex-wrap">
              <span className={`text-[10px] sm:text-[12px] font-black px-1.5 sm:px-2 py-0.5 rounded-md border ${branchBadgeColor}`}>
                📍 {branchLabel}
              </span>
              <span className="text-[10px] sm:text-[12px] font-black text-unri-yellow-600 bg-unri-yellow-50 px-1.5 sm:px-2 py-0.5 rounded-md border border-unri-yellow-100/50">
                Layanan Buka
              </span>
              <span className="hidden lg:inline text-xs font-bold text-gray-600">
                {settings?.operationalHours || "Senin - Jumat | 08:00 - 16:00 WIB"}
              </span>
            </div>
          </div>
        </div>

        {/* RIGHT: Date + Clock */}
        <div className="flex items-center gap-2 sm:gap-3 shrink-0">
          <div className="text-right flex flex-col">
            <span className="text-xs sm:text-sm md:text-base font-extrabold text-unri-green-700 whitespace-nowrap">
              {dateString}
            </span>
            <div className="flex items-center gap-1.5 justify-end">
              <span className="text-lg sm:text-2xl md:text-3xl font-black text-unri-yellow-600 tabular-nums tracking-tight leading-none">
                {timeString}
              </span>
            </div>
            <div className="hidden sm:flex items-center gap-1 justify-end mt-0.5 text-[10px] sm:text-[11px] text-gray-600 font-bold">
              <RefreshCw className="h-2.5 w-2.5 text-unri-green-600" />
              <span>Updated:</span>
              <span className="font-bold text-unri-green-700">{lastUpdateDisplay}</span>
            </div>
          </div>
          <Clock className="hidden md:block h-6 w-6 md:h-7 md:w-7 text-unri-green-600 shrink-0" strokeWidth={2} />
        </div>
      </div>
    </header>
  );
}
