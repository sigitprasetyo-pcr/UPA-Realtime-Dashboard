import { useLibraryStore } from "../../store/useLibraryStore";
import { AnimatedNumber } from "../UI/AnimatedNumber";
import { Library, BookCopy, BookCheck, BookOpen, MonitorSmartphone } from "lucide-react";

export function CollectionCard({ isActive = true }: { isActive?: boolean }) {
  const stats = useLibraryStore((s) => s.stats);

  const rows = [
    {
      label: "Total Judul Buku",
      value: stats.total_book_titles,
      icon: Library,
      valueClass: "text-unri-yellow-600",
      iconClass: "text-unri-yellow-600",
    },
    {
      label: "Total Eksemplar",
      value: stats.total_copies,
      icon: BookCopy,
      valueClass: "text-unri-yellow-700",
      iconClass: "text-unri-yellow-600",
    },
    {
      label: "Tersedia Sirkulasi",
      value: stats.available_circulation,
      icon: BookCheck,
      valueClass: "text-unri-green-700",
      iconClass: "text-unri-green-600",
    },
    {
      label: "Buku Dipinjam",
      value: stats.books_currently_borrowed,
      icon: BookOpen,
      valueClass: "text-gray-800",
      iconClass: "text-gray-600",
    },
    {
      label: "Total E-Book / Digital",
      value: stats.total_internal_resources,
      icon: MonitorSmartphone,
      valueClass: "text-indigo-700",
      iconClass: "text-indigo-600",
    },
  ];

  return (
    <div className="kpi-card flex flex-col animate-fade-in h-full" style={{ animationDelay: "160ms" }}>
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-unri-green-600" />
        <Library className="h-5 w-5 text-unri-green-700" strokeWidth={2.2} />
        <span className="text-[12px] font-black text-unri-green-700 tracking-widest uppercase">
          STATISTIK KOLEKSI
        </span>
      </div>

      <div className="flex-1 p-2 flex flex-col justify-between min-h-0 overflow-hidden">
        <div className="flex flex-col gap-1">
          {rows.map((r) => {
            const Icon = r.icon;
            return (
              <div key={r.label} className="stat-row !py-0.5">
                <div className="flex items-center gap-1.5 min-w-0">
                  <Icon className={`h-4 w-4 ${r.iconClass} shrink-0`} />
                  <span className="text-xs font-extrabold text-gray-800 truncate">{r.label}</span>
                </div>
                <AnimatedNumber
                  value={r.value}
                  className={`text-xl font-black ${r.valueClass} tabular-nums shrink-0 ml-1`}
                  showDelta
                  deltaColorClass="text-unri-green-500"
                />
              </div>
            );
          })}
        </div>

        {/* Availability bar */}
        <div className="pt-1 mt-auto shrink-0" style={{ borderTop: "1px dashed rgba(22, 163, 74, 0.25)" }}>
          <div className="flex items-center justify-between mb-0.5">
            <span className="text-[11px] font-extrabold text-gray-700 uppercase tracking-widest">Ketersediaan Koleksi</span>
            <span className="text-base font-black text-unri-green-700 tabular-nums">
              {typeof stats.availability_percent === "number" ? (
                <>{Number(stats.availability_percent).toFixed(1)}%</>
              ) : (
                <span className="text-gray-500">-</span>
              )}
            </span>
          </div>
          <div className="w-full h-3 rounded-full bg-unri-green-50 overflow-hidden" aria-hidden>
            <div
              className="h-full rounded-full"
              style={{
                width: isActive ? `${Math.max(0, Math.min(100, Number(stats.availability_percent || 0)))}%` : "0%",
                background: "linear-gradient(90deg,#16a34a,#22c55e,#ca8a04)",
                transition: "width 1.5s cubic-bezier(0.25, 1, 0.5, 1)",
              }}
            />
          </div>
        </div>
      </div>
    </div>
  );
}
