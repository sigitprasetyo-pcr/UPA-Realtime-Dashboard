import { Line } from "react-chartjs-2";
import { useLibraryStore } from "../../store/useLibraryStore";
import { HOURLY_LABELS } from "../../types";
import { buildLineChartOptions } from "../../utils/chartConfig";
import { Activity, TrendingUp } from "lucide-react";
import type { ChartData } from "chart.js";
import { useEffect, useState } from "react";

const ZERO_HOURLY = [0, 0, 0, 0, 0, 0, 0, 0, 0];

export function ActivityTrendChart({ isActive = true }: { isActive?: boolean }) {
  const s = useLibraryStore((st) => st.stats);
  const [chartKey, setChartKey] = useState(0);

  useEffect(() => {
    if (isActive) {
      setChartKey((prev) => prev + 1);
    }
  }, [isActive]);

  const data: ChartData<"line"> = {
    labels: HOURLY_LABELS,
    datasets: [
      {
        label: "Pengunjung",
        data: s?.hourly_visitors || ZERO_HOURLY,
        borderColor: "#16a34a",
        backgroundColor: "rgba(22, 163, 74, 0.18)",
        borderWidth: 3,
        pointRadius: 4,
        pointBackgroundColor: "#16a34a",
        pointBorderColor: "#fff",
        pointBorderWidth: 2,
        tension: 0.4,
        fill: true,
      },
      {
        label: "Peminjaman",
        data: s?.hourly_borrowing || ZERO_HOURLY,
        borderColor: "#ca8a04",
        backgroundColor: "rgba(202, 138, 4, 0.14)",
        borderWidth: 3,
        pointRadius: 4,
        pointBackgroundColor: "#ca8a04",
        pointBorderColor: "#fff",
        pointBorderWidth: 2,
        tension: 0.4,
        fill: true,
      },
      {
        label: "Pengembalian",
        data: s?.hourly_returning || ZERO_HOURLY,
        borderColor: "#dc2626",
        backgroundColor: "rgba(220, 38, 38, 0.1)",
        borderWidth: 3,
        pointRadius: 4,
        pointBackgroundColor: "#dc2626",
        pointBorderColor: "#fff",
        pointBorderWidth: 2,
        tension: 0.4,
        fill: true,
      },
      {
        label: "Administrasi",
        data: s?.hourly_administration || ZERO_HOURLY,
        borderColor: "#0f766e",
        backgroundColor: "rgba(15, 118, 110, 0.1)",
        borderWidth: 3,
        pointRadius: 4,
        pointBackgroundColor: "#0f766e",
        pointBorderColor: "#fff",
        pointBorderWidth: 2,
        tension: 0.4,
        fill: true,
      },
    ],
  };

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-unri-green-500" />
        <Activity className="h-5 w-5 text-unri-green-600" strokeWidth={2.2} />
        <span className="kpi-title text-unri-green-700 tracking-wider">
          TREN AKTIVITAS HARI INI
        </span>
        <div className="flex items-center gap-1 ml-auto text-xs font-semibold text-unri-green-700 bg-unri-green-50 px-2.5 py-1 rounded-full border border-unri-green-200">
          <TrendingUp className="h-3.5 w-3.5 text-unri-green-600" />
          <span>Real-time</span>
        </div>
      </div>

      <div className="flex-1 min-h-0 overflow-hidden relative p-1.5 flex flex-col">
        <div className="flex-1 min-h-0 w-full relative">
          <Line key={chartKey} data={data} options={buildLineChartOptions()} />
        </div>
      </div>
    </div>
  );
}
