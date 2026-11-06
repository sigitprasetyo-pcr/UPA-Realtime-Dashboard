import { useLibraryStore } from "../../store/useLibraryStore";
import { BarChart3, BookOpen, BookX, TrendingUp } from "lucide-react";
import { formatNumber } from "../../utils/formatters";

export function TotalTransactionsCard() {
  const stats = useLibraryStore((s) => s.stats);

  const transactionData = [
    {
      label: "Total Peminjaman",
      value: stats.total_borrowing_all,
      icon: BookOpen,
      bgGradient: "from-green-50 to-emerald-100",
      borderColor: "border-green-300",
      textColor: "text-green-700",
    },
    {
      label: "Total Pengembalian",
      value: stats.total_returning_all,
      icon: BookX,
      bgGradient: "from-blue-50 to-cyan-100",
      borderColor: "border-blue-300",
      textColor: "text-blue-700",
    },
    {
      label: "Sedang Dipinjam",
      value: stats.books_currently_borrowed,
      icon: TrendingUp,
      bgGradient: "from-orange-50 to-amber-100",
      borderColor: "border-orange-300",
      textColor: "text-orange-700",
    },
  ];

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-indigo-500" />
        <BarChart3 className="h-5 w-5 text-indigo-600" strokeWidth={2.2} />
        <span className="kpi-title text-indigo-700 tracking-wider">
          TOTAL TRANSAKSI
        </span>
      </div>

      <div className="flex-1 p-2 flex flex-col justify-center gap-1.5 min-h-0 overflow-hidden">
        {transactionData.map((item) => {
          const Icon = item.icon;
          return (
            <div
              key={item.label}
              className={`bg-gradient-to-br ${item.bgGradient} border ${item.borderColor} rounded-lg px-3 py-2 flex-1 flex items-center`}
            >
              <div className="flex items-center justify-between gap-2 w-full">
                <div className="flex items-center gap-2 flex-1 min-w-0">
                  <Icon className={`h-4 w-4 ${item.textColor} flex-shrink-0`} />
                  <p className="text-xs font-bold text-gray-700 uppercase tracking-wide truncate">
                    {item.label}
                  </p>
                </div>
                <p className={`text-base font-bold ${item.textColor} tabular-nums shrink-0`}>
                  {formatNumber(item.value)}
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
