import { useLibraryStore } from "../../store/useLibraryStore";
import { AlertTriangle, BookX, BadgeDollarSign, TrendingDown, Users } from "lucide-react";
import { formatNumber } from "../../utils/formatters";

export function OverdueBooksSummary() {
  const stats = useLibraryStore((s) => s.stats);

  const totalFines =
    stats.late_books?.reduce((sum, book) => sum + book.fine, 0) || 0;
  const averageFine =
    stats.late_books && stats.late_books.length > 0
      ? Math.floor(totalFines / stats.late_books.length)
      : 0;

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-red-500" />
        <AlertTriangle className="h-5 w-5 text-red-600" strokeWidth={2.2} />
        <span className="kpi-title text-red-700 tracking-wider">
          KETERLAMBATAN
        </span>
      </div>

      <div className="flex-1 p-2.5 flex flex-col justify-between gap-2 min-h-0 overflow-hidden">
        {/* Main metric */}
        <div className="bg-gradient-to-br from-red-50 to-red-100 border-2 border-red-300 rounded-lg p-3 flex items-center justify-between">
          <div>
            <p className="text-[10px] text-gray-600 font-bold uppercase tracking-wide mb-0.5">
              Total Terlambat
            </p>
            <p className="text-3xl font-bold text-red-600">
              {stats.overdue_books}
            </p>
          </div>
          <BookX className="h-8 w-8 text-red-400 opacity-40" />
        </div>

        {/* Secondary metrics - 3 items to fill space */}
        <div className="grid grid-cols-3 gap-2 flex-1">
          <div className="bg-gradient-to-br from-orange-50 to-orange-100 border border-orange-300 rounded-lg p-2.5 flex flex-col justify-center">
            <div className="flex items-center gap-1 mb-1">
              <Users className="h-3 w-3 text-orange-600" />
              <p className="text-[10px] text-gray-600 font-bold uppercase tracking-wide">
                Kasus Aktif
              </p>
            </div>
            <p className="text-xl font-bold text-orange-600">
              {stats.late_books?.length || 0}
            </p>
          </div>

          <div className="bg-gradient-to-br from-rose-50 to-rose-100 border border-rose-300 rounded-lg p-2.5 flex flex-col justify-center">
            <div className="flex items-center gap-1 mb-1">
              <BadgeDollarSign className="h-3 w-3 text-rose-600" />
              <p className="text-[10px] text-gray-600 font-bold uppercase tracking-wide">
                Total Denda
              </p>
            </div>
            <p className="text-sm font-bold text-rose-700 truncate">
              Rp {formatNumber(totalFines)}
            </p>
          </div>

          <div className="bg-gradient-to-br from-yellow-50 to-amber-100 border border-yellow-300 rounded-lg p-2.5 flex flex-col justify-center">
            <div className="flex items-center gap-1 mb-1">
              <TrendingDown className="h-3 w-3 text-amber-600" />
              <p className="text-[10px] text-gray-600 font-bold uppercase tracking-wide">
                Rata-rata
              </p>
            </div>
            <p className="text-sm font-bold text-amber-700 truncate">
              Rp {formatNumber(averageFine)}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
