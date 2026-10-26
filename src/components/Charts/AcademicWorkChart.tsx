import { Bar } from "react-chartjs-2";
import { useLibraryStore } from "../../store/useLibraryStore";
import { formatNumber } from "../../utils/formatters";
import { GraduationCap, Award } from "lucide-react";
import type { ChartData, ChartOptions } from "chart.js";
import { useEffect, useState } from "react";

export function AcademicWorkChart({ isActive = true }: { isActive?: boolean }) {
  const s = useLibraryStore((st) => st.stats);
  const [chartKey, setChartKey] = useState(0);

  useEffect(() => {
    if (isActive) {
      setChartKey((prev) => prev + 1);
    }
  }, [isActive]);

  const categories = [
    { label: "Tugas Akhir/D3", value: s?.ta_d3 ?? 11, color: "#16a34a" },
    { label: "Skripsi", value: s?.skripsi_s1 ?? 29, color: "#ca8a04" },
    { label: "Tesis", value: s?.tesis_s2 ?? 7, color: "#0ea5e9" },
    { label: "Disertasi", value: s?.disertasi_s3 ?? 5, color: "#7c3aed" },
  ];

  const maxVal = Math.max(...categories.map((c) => c.value), 1);
  const values = categories.map((c) => c.value);

  const data: ChartData<"bar"> = {
    labels: categories.map((c) => c.label),
    datasets: [
      {
        label: "Jumlah",
        data: values,
        backgroundColor: categories.map((c) => c.color),
        borderRadius: 10,
        borderSkipped: false,
        barPercentage: 0.6,
        categoryPercentage: 0.75,
      },
    ],
  };

  const yMax = Math.ceil((maxVal * 1.25) / 2) * 2;
  const opts: ChartOptions<"bar"> = {
    indexAxis: "x",
    responsive: true,
    maintainAspectRatio: false,
    animations: {
      y: {
        duration: 800,
        easing: "easeOutQuart",
        delay: (context: any) => {
          if (context.type === "data") {
            return 500 + context.dataIndex * 300; // 500ms base + 300ms per bar stagger
          }
          return 0;
        },
      }
    } as any,
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: "#78350f",
        titleFont: { size: 13, family: "'Plus Jakarta Sans', Poppins, sans-serif", weight: 700 },
        bodyFont: { size: 12, family: "'Plus Jakarta Sans', Poppins, sans-serif" },
        padding: 10,
        cornerRadius: 8,
        callbacks: {
          label: (ctx) => ` ${formatNumber(Number(ctx.raw ?? 0))} karya`,
        },
      },
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: {
          color: "#4b5563",
          font: { size: 11, family: "'Plus Jakarta Sans', Poppins, sans-serif", weight: 600 },
        },
      },
      y: {
        max: yMax,
        grid: { color: "rgba(0,0,0,0.04)" },
        ticks: {
          stepSize: 5,
          color: "#9ca3af",
          font: { size: 11, family: "'Plus Jakarta Sans', Poppins, sans-serif" },
        },
      },
    },
  };

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-amber-500" />
        <Award className="h-5 w-5 text-amber-600" strokeWidth={2.2} />
        <span className="kpi-title text-amber-700 tracking-wider">
          KARYA ILMIAH & TUGAS AKHIR
        </span>
        <div className="flex items-center gap-1 ml-auto text-xs font-semibold text-amber-700 bg-amber-50 px-2.5 py-1 rounded-full border border-amber-200">
          <GraduationCap className="h-3.5 w-3.5 text-amber-600" />
          <span>Repositori</span>
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
