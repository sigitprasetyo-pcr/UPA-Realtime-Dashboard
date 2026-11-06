import { Doughnut } from "react-chartjs-2";
import { useLibraryStore } from "../../store/useLibraryStore";
import { buildDonutOptions } from "../../utils/chartConfig";
import { AnimatedNumber } from "../UI/AnimatedNumber";
import { Users2, UserCheck, UserRound, Users } from "lucide-react";
import type { ChartData } from "chart.js";
import { useEffect, useState } from "react";

export function MembershipDonut({ isActive = true }: { isActive?: boolean }) {
  const s = useLibraryStore((st) => st.stats);
  const [chartKey, setChartKey] = useState(0);

  useEffect(() => {
    if (isActive) {
      setChartKey((prev) => prev + 1);
    }
  }, [isActive]);

  const categories = [
    {
      key: "member",
      label: "Anggota / Pemustaka",
      value: s.member_visitors,
      color: "#16a34a",
      icon: UserCheck,
    },
    {
      key: "card",
      label: "Anggota Kartu Baca",
      value: s.reading_card_visitors,
      color: "#ca8a04",
      icon: UserRound,
    },
    {
      key: "general",
      label: "Pengunjung Umum",
      value: s.general_visitors,
      color: "#0891b2",
      icon: Users,
    },
  ];

  const totalAnggota = s.member_visitors + s.reading_card_visitors;
  const grandTotal = s.member_visitors + s.reading_card_visitors + s.general_visitors;

  const data: ChartData<"doughnut"> = {
    labels: categories.map((c) => c.label),
    datasets: [
      {
        data: categories.map((c) => c.value),
        backgroundColor: categories.map((c) => c.color),
        borderColor: "#fff",
        borderWidth: 4,
        hoverOffset: 8,
      },
    ],
  };

  return (
    <div className="chart-card h-full animate-fade-in" style={{ animationDelay: "480ms" }}>
      <div className="chart-card-header">
        <div className="h-6 w-1.5 rounded-full bg-unri-green-500" />
        <Users2 className="h-5 w-5 text-unri-green-700" strokeWidth={2.2} />
        <h2 className="font-bold tracking-wide text-unri-green-800 text-sm md:text-base uppercase">
          Kunjungan Keanggotaan
        </h2>
      </div>
      <div className="flex-1 min-h-0 flex gap-3 items-stretch overflow-hidden">
        {/* Donut chart - takes available height */}
        <div className="relative w-[42%] min-w-0 flex items-center justify-center p-2">
          <div className="relative w-full aspect-square max-w-full max-h-full">
            <Doughnut key={chartKey} data={data} options={buildDonutOptions()} />
            <div className="donut-center">
              <AnimatedNumber
                value={totalAnggota}
                className="text-xl md:text-2xl font-black text-unri-green-700 tabular-nums leading-none"
              />
              <p className="text-[9px] font-bold uppercase tracking-widest text-unri-green-600 mt-0.5">
                Total Anggota
              </p>
            </div>
          </div>
        </div>
        {/* Legend */}
        <div className="flex-1 flex flex-col justify-center gap-3 min-w-0 pr-1">
          {categories.map((c) => {
            const Icon = c.icon;
            const pct = grandTotal > 0 ? (c.value / grandTotal) * 100 : 0;
            return (
              <div
                key={c.key}
                className="rounded-lg p-2.5 flex items-center justify-between min-w-0"
                style={{
                  background: `linear-gradient(90deg, ${c.color}15 0%, #ffffff00 100%)`,
                  borderLeft: `3px solid ${c.color}`,
                }}
              >
                <div className="flex items-center gap-2 min-w-0 flex-1">
                  <Icon className="h-4 w-4 shrink-0" style={{ color: c.color }} />
                  <div className="min-w-0 flex-1">
                    <p className="text-xs font-bold text-gray-700 leading-tight truncate">
                      {c.label}
                    </p>
                    <div className="w-full h-1.5 rounded-full overflow-hidden bg-gray-100 mt-1">
                      <div
                        className="h-full rounded-full"
                        style={{
                          width: `${pct}%`,
                          backgroundColor: c.color,
                          transition: "width 1s ease-out",
                        }}
                      />
                    </div>
                  </div>
                </div>
                <AnimatedNumber
                  value={c.value}
                  className="text-lg font-black tabular-nums ml-2 shrink-0"
                  style={{ color: c.color } as React.CSSProperties}
                />
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
