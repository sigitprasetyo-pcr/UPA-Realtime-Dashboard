import { Bar } from "react-chartjs-2";
import { useLibraryStore } from "../../store/useLibraryStore";
import { buildBarChartOptions } from "../../utils/chartConfig";
import { formatNumber } from "../../utils/formatters";
import { BarChart3, Layers } from "lucide-react";
import type { ChartData, ChartOptions } from "chart.js";
import { useEffect, useState } from "react";

const CLASS_ORDER = [
  "Kelas 000",
  "Kelas 100",
  "Kelas 200",
  "Kelas 300",
  "Kelas 400",
  "Kelas 500",
  "Kelas 600",
  "Kelas 700",
  "Kelas 800",
  "Kelas 900",
];

export function CollectionClassChart({ isActive = true }: { isActive?: boolean }) {
  const s = useLibraryStore((st) => st.stats);
  const [chartKey, setChartKey] = useState(0);

  useEffect(() => {
    if (isActive) {
      setChartKey((prev) => prev + 1);
    }
  }, [isActive]);

  const labels = CLASS_ORDER.slice().reverse();
  const classMap = s?.collection_by_class || {};
  const values = labels.map((k) => classMap[k] ?? 0);
  const maxVal = Math.max(...values, 1);

  const barColors = labels.map((k) => {
    if (k === "Kelas 300") return "#ca8a04";
    if (k === "Kelas 600") return "#16a34a";
    const idx = CLASS_ORDER.indexOf(k);
    const grad = 1 - (idx + 1) / (CLASS_ORDER.length + 1);
    return `rgba(22, 163, 74, ${0.35 + 0.45 * grad})`;
  });

  const data: ChartData<"bar"> = {
    labels,
    datasets: [
      {
        label: "Judul",
        data: values,
        backgroundColor: barColors,
        borderRadius: 8,
        borderSkipped: false,
        barPercentage: 0.65,
        categoryPercentage: 0.8,
      },
    ],
  };

  const xMax = Math.ceil((maxVal * 1.25) / 1000) * 1000;
  const opts: ChartOptions<"bar"> = {
    ...buildBarChartOptions(true),
    indexAxis: "y",
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: "#14532d",
        titleFont: { size: 13, family: "'Plus Jakarta Sans', Poppins, sans-serif", weight: 700 },
        bodyFont: { size: 12, family: "'Plus Jakarta Sans', Poppins, sans-serif" },
        padding: 10,
        cornerRadius: 8,
        callbacks: {
          label: (ctx) => ` ${formatNumber(Number(ctx.raw ?? 0))} judul`,
        },
      },
    },
  };

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-unri-green-500" />
        <BarChart3 className="h-5 w-5 text-unri-green-600" strokeWidth={2.2} />
        <span className="kpi-title text-unri-green-700 tracking-wider">
          KOLEKSI BERDASARKAN KELAS
        </span>
        <div className="flex items-center gap-1 ml-auto text-xs font-semibold text-unri-green-700 bg-unri-green-50 px-2.5 py-1 rounded-full border border-unri-green-200">
          <Layers className="h-3.5 w-3.5 text-unri-green-600" />
          <span>DDC 000–900</span>
        </div>
      </div>

      <div className="flex-1 min-h-0 overflow-hidden relative p-1.5 flex flex-col">
        <div className="flex-1 min-h-0 w-full relative">
          <Bar key={chartKey} data={data} options={opts} />
        </div>
      </div>
    </div>
  );
}
