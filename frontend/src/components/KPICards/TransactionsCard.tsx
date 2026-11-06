import { useLibraryStore } from "../../store/useLibraryStore";
import { AnimatedNumber } from "../UI/AnimatedNumber";
import { ArrowRightLeft, ArrowUpCircle, ArrowDownCircle, FileCheck } from "lucide-react";

export function TransactionsCard() {
  const stats = useLibraryStore((s) => s.stats);

  const rows = [
    {
      label: "Peminjaman",
      value: stats.borrowing_today,
      icon: ArrowUpCircle,
      valueColor: "text-unri-yellow-600",
      iconColor: "text-unri-yellow-600",
    },
    {
      label: "Pengembalian",
      value: stats.returning_today,
      icon: ArrowDownCircle,
      valueColor: "text-unri-green-700",
      iconColor: "text-unri-green-600",
    },
    {
      label: "Administrasi",
      value: stats.administration_today,
      icon: FileCheck,
      valueColor: "text-gray-800",
      iconColor: "text-gray-600",
    },
  ];

  return (
    <div className="kpi-card flex flex-col animate-fade-in h-full" style={{ animationDelay: "80ms" }}>
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-unri-yellow-500" />
        <ArrowRightLeft className="h-5 w-5 text-unri-yellow-600" strokeWidth={2.2} />
        <span className="kpi-title text-unri-yellow-700 tracking-wider">
          TRANSAKSI HARI INI
        </span>
      </div>

      <div className="flex-1 p-2 flex flex-col justify-between min-h-0 overflow-hidden">
        <div className="flex flex-col gap-1.5">
          {rows.map((r) => {
            const Icon = r.icon;
            return (
              <div key={r.label} className="stat-row">
                <div className="flex items-center gap-1.5 min-w-0">
                  <Icon className={`h-3.5 w-3.5 ${r.iconColor} shrink-0`} />
                  <span className="text-xs font-semibold text-gray-700 truncate">{r.label}</span>
                </div>
                <AnimatedNumber
                  value={r.value}
                  className={`text-lg font-black ${r.valueColor} tabular-nums shrink-0 ml-1`}
                  showDelta
                  deltaColorClass="text-unri-green-500"
                />
              </div>
            );
          })}
        </div>

        <div
          className="pt-1 mt-auto"
          style={{
            borderTop: "1px dashed rgba(245, 158, 11, 0.2)",
          }}
        >
          <div
            className="rounded-lg px-2 py-1.5 flex items-center justify-between"
            style={{
              background:
                "linear-gradient(135deg, rgba(245, 158, 11, 0.1) 0%, rgba(245, 158, 11, 0.02) 100%)",
            }}
          >
            <p className="text-[10px] font-bold uppercase tracking-wider text-unri-yellow-700/80">
              Total Transaksi Hari Ini
            </p>
            <AnimatedNumber
              value={stats.total_transactions_today}
              className="text-2xl font-black text-unri-yellow-600 tabular-nums"
              showDelta
              deltaColorClass="text-unri-yellow-500"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
