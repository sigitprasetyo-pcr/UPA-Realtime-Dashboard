import { useLibraryStore } from "../../store/useLibraryStore";
import { AnimatedNumber } from "../UI/AnimatedNumber";
import {
  ArrowRightLeft,
  ArrowUpCircle,
  ArrowDownCircle,
  BookX,
  CircleUserRound,
  AlertTriangle,
  RefreshCw,
} from "lucide-react";
import { Doughnut } from "react-chartjs-2";
import { buildDonutOptions } from "../../utils/chartConfig";
import type { ChartData } from "chart.js";

export function TransactionInfoCard() {
  const stats = useLibraryStore((s) => s.stats);

  const rows = [
    {
      label: "Total Peminjaman",
      value: stats.total_borrowing_all,
      icon: ArrowUpCircle,
      valueColor: "text-unri-yellow-600",
      color: "#eab308",
    },
    {
      label: "Total Pengembalian",
      value: stats.total_returning_all,
      icon: ArrowDownCircle,
      valueColor: "text-unri-yellow-600",
      color: "#22c55e",
    },
    {
      label: "Total Perpanjangan",
      value: stats.total_extension_all,
      icon: RefreshCw,
      valueColor: "text-unri-yellow-600",
      color: "#3b82f6",
    },
    {
      label: "Buku Dipinjam",
      value: stats.books_currently_borrowed,
      icon: BookX,
      valueColor: "text-unri-green-700",
      color: "#16a34a",
    },
    {
      label: "Member Pinjam",
      value: stats.members_currently_borrowing,
      icon: CircleUserRound,
      valueColor: "text-unri-green-700",
      color: "#14b8a6",
    },
    {
      label: "Terlambat",
      value: stats.overdue_books,
      icon: AlertTriangle,
      valueColor: "text-unri-red-600",
      isWarning: true,
      color: "#ef4444",
    },
  ];

  const chartData: ChartData<"doughnut"> = {
    labels: [rows[0].label, rows[1].label, rows[2].label],
    datasets: [{
      data: [rows[0].value, rows[1].value, rows[2].value],
      backgroundColor: [rows[0].color, rows[1].color, rows[2].color],
      borderWidth: 2,
      borderColor: "#fff",
      hoverOffset: 4,
    }]
  };

  const shouldScroll = rows.length > 2;
  const scrollDuration = Math.max(15, rows.length * 3.5);

  const renderRow = (r: typeof rows[0], i: number, uniqueKey: string) => {
    const Icon = r.icon;
    let maxVal = 1;
    if (i < 3) {
      maxVal = Math.max(stats.total_borrowing_all, stats.total_returning_all, stats.total_extension_all);
    } else {
      maxVal = Math.max(stats.books_currently_borrowed, stats.members_currently_borrowing, stats.overdue_books);
    }
    const pct = maxVal > 0 ? (r.value / maxVal) * 100 : 0;
    
    return (
      <div
        key={uniqueKey}
        className={`flex flex-col bg-white border rounded-lg p-2 shadow-sm shrink-0 ${r.isWarning ? "border-unri-red-200 bg-red-50/30" : "border-green-100"}`}
      >
        <div className="flex items-center justify-between mb-1.5">
          <div className="flex items-center gap-1.5 min-w-0">
            <Icon
              className={`h-4 w-4 shrink-0`}
              style={{ color: r.color }}
            />
            <span className="text-xs font-bold text-gray-700 truncate uppercase tracking-wide">{r.label}</span>
          </div>
          <AnimatedNumber
            value={r.value}
            className={`text-lg font-black tabular-nums shrink-0 ml-1`}
            style={{ color: r.color }}
          />
        </div>
        <div className={`w-full h-1.5 rounded-full overflow-hidden ${r.isWarning ? "bg-red-100" : "bg-gray-100"}`}>
          <div
            className="h-full rounded-full"
            style={{
              width: `${pct}%`,
              backgroundColor: r.color,
              transition: "width 1s ease-out",
            }}
          />
        </div>
      </div>
    );
  };

  return (
    <div className="kpi-card flex flex-col animate-fade-in h-full" style={{ animationDelay: "240ms" }}>
      <div className="kpi-card-header shrink-0 z-10 bg-white shadow-sm">
        <div className="h-6 w-1.5 rounded-full bg-unri-red-500" />
        <ArrowRightLeft className="h-5 w-5 text-unri-red-600" strokeWidth={2.2} />
        <span className="kpi-title text-unri-red-700 tracking-wider">
          TOTAL TRANSAKSI S.D. HARI INI
        </span>
      </div>

      <div className="flex-1 flex flex-col min-h-0 overflow-hidden bg-white">
        <div className="flex-1 overflow-hidden relative min-h-0">
          <div
            className={`absolute top-0 left-0 w-full flex flex-col ${
              shouldScroll ? "animate-marquee-vertical hover:[animation-play-state:paused]" : ""
            }`}
            style={{
              animationDuration: shouldScroll ? `${scrollDuration}s` : undefined,
            }}
          >
            <div className="flex flex-col gap-2 pb-2 px-2 pt-2">
              {rows.map((r, i) => renderRow(r, i, `block1-${i}`))}
            </div>
            {shouldScroll && (
              <div className="flex flex-col gap-2 pb-2 px-2">
                {rows.map((r, i) => renderRow(r, i, `block2-${i}`))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
