import { useLibraryStore } from "../store/useLibraryStore";
import { formatNumber } from "../utils/formatters";
import {
  BookCheck,
  BookX,
  BookCopy,
  CircleUser,
  BookText,
  Users,
  ArrowRightLeft,
  Undo2,
  GraduationCap,
} from "lucide-react";
import type { ComponentType } from "react";

interface TickerStat {
  icon: ComponentType<any>;
  label: string;
  value: number;
  color: string;
}

export function RunningTicker() {
  const s = useLibraryStore((st) => st.stats);

  // The user requested: "Total buku per kelas {running teks}"
  const items = Object.entries(s.collection_by_class).map(([className, count]) => {
    // Determine subject based on Dewey Decimal Classification standard
    let subject = "";
    if (className === "Kelas 000") subject = "Komputer, Informasi, & Umum";
    else if (className === "Kelas 100") subject = "Filsafat & Psikologi";
    else if (className === "Kelas 200") subject = "Agama";
    else if (className === "Kelas 300") subject = "Ilmu Sosial";
    else if (className === "Kelas 400") subject = "Bahasa";
    else if (className === "Kelas 500") subject = "Sains & Matematika";
    else if (className === "Kelas 600") subject = "Teknologi & Ilmu Terapan";
    else if (className === "Kelas 700") subject = "Kesenian & Rekreasi";
    else if (className === "Kelas 800") subject = "Sastra";
    else if (className === "Kelas 900") subject = "Sejarah & Geografi";

    return {
      icon: BookCopy,
      label: `${className} (${subject})`,
      value: count,
      color: "text-white",
    };
  });

  const fullList = Array(6).fill(items).flat();

  return (
    <div
      className="w-full overflow-hidden py-2.5 relative"
      style={{
        background: "linear-gradient(90deg, #15803d 0%, #16a34a 30%, #ca8a04 70%, #a16207 100%)",
      }}
    >
      <div className="ticker-track text-white">
        {fullList.map((item, i) => {
          const Icon = item.icon;
          return (
            <div key={i} className="ticker-item text-white">
              <span className="text-unri-yellow-100 text-xl">●</span>
              <Icon className="h-5 w-5 shrink-0" strokeWidth={2.2} />
              <span className="font-extrabold text-sm tracking-wider">
                {item.label}
              </span>
              <span
                className="font-black text-xl tabular-nums tracking-tight"
                style={{ color: "#fff7cc", textShadow: "0 1px 2px rgba(0,0,0,0.15)" }}
              >
                {formatNumber(item.value)}
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
