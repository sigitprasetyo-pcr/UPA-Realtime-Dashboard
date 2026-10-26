import { useLibraryStore } from "../../store/useLibraryStore";
import { Workflow, CheckCircle, RotateCcw, AlertCircle, UserPlus, CreditCard } from "lucide-react";
import { formatNumber } from "../../utils/formatters";
import type { AdminTransaction } from "../../types";

const DEFAULT_ADMIN_TRANSACTIONS: AdminTransaction[] = [
  { type: "peminjaman", count: 140 },
  { type: "pengembalian", count: 158 },
  { type: "validasi", count: 12 },
  { type: "bebas_pustaka", count: 8 },
  { type: "pendaftaran", count: 5 },
  { type: "pembayaran_denda", count: 15 },
];

export function AdminTransactionsCard() {
  const stats = useLibraryStore((s) => s.stats);
  const adminTransactions = stats?.admin_transactions && stats.admin_transactions.length > 0 
    ? stats.admin_transactions 
    : DEFAULT_ADMIN_TRANSACTIONS;

  const transactionConfig: Record<AdminTransaction["type"], { label: string; icon: React.ComponentType<{ className: string }>; barColor: string; dotColor: string }> = {
    peminjaman: { label: "Peminjaman", icon: CheckCircle, barColor: "bg-emerald-400", dotColor: "bg-emerald-500" },
    pengembalian: { label: "Pengembalian", icon: RotateCcw, barColor: "bg-blue-400", dotColor: "bg-blue-500" },
    validasi: { label: "Validasi", icon: AlertCircle, barColor: "bg-amber-400", dotColor: "bg-amber-500" },
    bebas_pustaka: { label: "Bebas Pustaka", icon: CheckCircle, barColor: "bg-purple-400", dotColor: "bg-purple-500" },
    pendaftaran: { label: "Pendaftaran", icon: UserPlus, barColor: "bg-indigo-400", dotColor: "bg-indigo-500" },
    pembayaran_denda: { label: "Denda", icon: CreditCard, barColor: "bg-rose-400", dotColor: "bg-rose-500" },
  };

  const total = adminTransactions.reduce((sum, t) => sum + (t.count || 0), 0);
  const maxCount = Math.max(...adminTransactions.map(t => t.count || 0), 1);

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-indigo-500" />
        <Workflow className="h-5 w-5 text-indigo-600" strokeWidth={2.2} />
        <span className="kpi-title text-indigo-700 tracking-wider">
          TRANSAKSI HARI INI
        </span>
        <span className="ml-auto text-indigo-600 font-bold text-sm">
          {formatNumber(total)}
        </span>
      </div>

      <div className="flex-1 min-h-0 overflow-hidden flex flex-col px-3 py-1.5">
        <div className="flex flex-col flex-1 justify-evenly">
          {adminTransactions.map((transaction) => {
            const config = transactionConfig[transaction.type] || {
              label: transaction.type,
              icon: CheckCircle,
              barColor: "bg-gray-400",
              dotColor: "bg-gray-500"
            };
            const percent = ((transaction.count || 0) / maxCount) * 100;

            return (
              <div key={transaction.type} className="flex items-center gap-2">
                {/* Colored dot */}
                <div className={`w-2 h-2 rounded-full ${config.dotColor} shrink-0`} />
                
                {/* Label */}
                <span className="text-xs font-semibold text-gray-700 w-[80px] shrink-0 truncate">
                  {config.label}
                </span>

                {/* Progress bar container */}
                <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                  <div
                    className={`h-full rounded-full ${config.barColor} transition-all duration-700 ease-out`}
                    style={{ width: `${Math.max(percent, 4)}%` }}
                  />
                </div>

                {/* Value */}
                <span className="text-xs font-bold text-gray-900 w-[42px] text-right shrink-0 tabular-nums">
                  {formatNumber(transaction.count || 0)}
                </span>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
