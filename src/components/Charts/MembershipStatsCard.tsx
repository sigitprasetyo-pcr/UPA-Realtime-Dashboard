import { useLibraryStore } from "../../store/useLibraryStore";
import { Users, GraduationCap, Building2, User, CalendarDays } from "lucide-react";

const DEFAULT_GENDER = [
  { category: "Laki-laki", count: 298 },
  { category: "Perempuan", count: 420 },
];
const DEFAULT_AGE = [
  { category: "18-22", count: 245 },
  { category: "23-27", count: 312 },
  { category: "28-32", count: 124 },
  { category: "33+", count: 37 },
];
const DEFAULT_FACULTY = [
  { faculty: "FAPERTA", count: 145 },
  { faculty: "FMIPA", count: 132 },
  { faculty: "FE", count: 98 },
  { faculty: "FH", count: 87 },
  { faculty: "FKIP", count: 156 },
];
const DEFAULT_PROGRAM = [
  { category: "S1", count: 485 },
  { category: "S2", count: 156 },
  { category: "S3", count: 45 },
  { category: "D3", count: 32 },
];

export function MembershipStatsCard({ isActive = true }: { isActive?: boolean }) {
  const stats = useLibraryStore((s) => s.stats);

  const genderList = stats?.membership_by_gender && stats.membership_by_gender.length > 0 
    ? stats.membership_by_gender 
    : DEFAULT_GENDER;
  const ageList = stats?.membership_by_age && stats.membership_by_age.length > 0 
    ? stats.membership_by_age 
    : DEFAULT_AGE;
  const facultyList = stats?.membership_by_faculty && stats.membership_by_faculty.length > 0 
    ? stats.membership_by_faculty 
    : DEFAULT_FACULTY;
  const programList = stats?.membership_by_program && stats.membership_by_program.length > 0 
    ? stats.membership_by_program 
    : DEFAULT_PROGRAM;

  const renderProgressBar = (
    label: string, 
    value: number, 
    max: number, 
    colorClass: string, 
    bgClass: string,
    delayIndex: number
  ) => {
    const percent = max > 0 ? (value / max) * 100 : 0;
    return (
      <div key={label} className="flex flex-col gap-0.5 mb-1.5 last:mb-0">
        <div className="flex justify-between items-end mb-1">
          <span className="text-xs font-bold text-gray-700 truncate leading-none">{label}</span>
          <span className="text-xs font-black text-gray-900 tabular-nums leading-none">{value}</span>
        </div>
        <div className={`w-full h-2 rounded-full ${bgClass} overflow-hidden`}>
          <div 
            className={`h-full rounded-full ${colorClass}`}
            style={{ 
              width: isActive ? `${percent}%` : "0%",
              transition: `width 1s cubic-bezier(0.25, 1, 0.5, 1) ${delayIndex * 100}ms`
            }}
          />
        </div>
      </div>
    );
  };

  const maxGender = Math.max(...genderList.map(d => d.count), 1);
  const maxAge = Math.max(...ageList.map(d => d.count), 1);
  const maxProgram = Math.max(...programList.map(d => d.count), 1);

  return (
    <div className="kpi-card flex flex-col animate-fade-in h-full" style={{ animationDelay: "240ms" }}>
      <div className="kpi-card-header shrink-0 z-10 bg-white">
        <div className="h-6 w-1.5 rounded-full bg-unri-green-500" />
        <Users className="h-5 w-5 text-unri-green-600" strokeWidth={2.2} />
        <span className="kpi-title text-unri-green-700 tracking-wider">
          DEMOGRAFI KUNJUNGAN KEANGGOTAAN
        </span>
      </div>

      <div className="flex-1 min-h-0 overflow-hidden flex flex-col p-1 gap-1 bg-gradient-to-br from-green-50/30 to-emerald-50/30">
        <div className="flex flex-col gap-1 flex-1 min-h-0">
          
          {/* Gender */}
          <div className="flex flex-col min-h-0 flex-1 bg-white border border-green-100 rounded-lg p-1.5 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 mb-2 shrink-0">
              <User className="h-4 w-4 text-blue-500" />
              <span className="text-xs font-bold text-gray-800 uppercase tracking-wide leading-none mt-0.5">Jenis Kelamin</span>
            </div>
            <div className="flex-1 min-h-0 overflow-hidden relative">
              <div 
                className="absolute top-0 left-0 w-full animate-marquee-vertical"
                style={{ 
                  animationDuration: "15s",
                  animationPlayState: isActive ? "running" : "paused"
                }}
              >
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {genderList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxGender, "bg-blue-500", "bg-blue-100", i)
                  )}
                </div>
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {genderList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxGender, "bg-blue-500", "bg-blue-100", i)
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Age */}
          <div className="flex flex-col min-h-0 flex-1 bg-white border border-green-100 rounded-lg p-1.5 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 mb-2 shrink-0">
              <CalendarDays className="h-4 w-4 text-orange-500" />
              <span className="text-xs font-bold text-gray-800 uppercase tracking-wide leading-none mt-0.5">Kelompok Umur</span>
            </div>
            <div className="flex-1 min-h-0 overflow-hidden relative">
              <div 
                className="absolute top-0 left-0 w-full animate-marquee-vertical"
                style={{ 
                  animationDuration: "18s",
                  animationPlayState: isActive ? "running" : "paused"
                }}
              >
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {ageList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxAge, "bg-orange-500", "bg-orange-100", i)
                  )}
                </div>
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {ageList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxAge, "bg-orange-500", "bg-orange-100", i)
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Faculty */}
          <div className="flex flex-col min-h-0 flex-1 bg-white border border-green-100 rounded-lg p-1.5 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 mb-2 shrink-0">
              <Building2 className="h-4 w-4 text-emerald-600" />
              <span className="text-xs font-bold text-gray-800 uppercase tracking-wide leading-none mt-0.5">Fakultas</span>
            </div>
            <div className="flex-1 min-h-0 overflow-hidden relative">
              <div 
                className="absolute top-0 left-0 w-full"
              >
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {(() => {
                    const eksakta = facultyList
                      .filter(f => ["FAPERTA", "FMIPA", "TEKNIK"].includes(f.faculty))
                      .reduce((sum, item) => sum + item.count, 0);
                    const nonEksakta = facultyList
                      .filter(f => !["FAPERTA", "FMIPA", "TEKNIK"].includes(f.faculty))
                      .reduce((sum, item) => sum + item.count, 0);
                    const totalFac = eksakta + nonEksakta;
                    return (
                      <>
                        {renderProgressBar("Eksakta", eksakta, totalFac, "bg-emerald-500", "bg-emerald-100", 0)}
                        {renderProgressBar("Non-Eksakta", nonEksakta, totalFac, "bg-emerald-500", "bg-emerald-100", 1)}
                      </>
                    );
                  })()}
                </div>
              </div>
            </div>
          </div>

          {/* Program */}
          <div className="flex flex-col min-h-0 flex-1 bg-white border border-green-100 rounded-lg p-1.5 shadow-sm overflow-hidden">
            <div className="flex items-center gap-2 mb-2 shrink-0">
              <GraduationCap className="h-4 w-4 text-purple-500" />
              <span className="text-xs font-bold text-gray-800 uppercase tracking-wide leading-none mt-0.5">Program Studi</span>
            </div>
            <div className="flex-1 min-h-0 overflow-hidden relative">
              <div 
                className="absolute top-0 left-0 w-full animate-marquee-vertical"
                style={{ 
                  animationDuration: "18s",
                  animationPlayState: isActive ? "running" : "paused"
                }}
              >
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {programList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxProgram, "bg-purple-500", "bg-purple-100", i)
                  )}
                </div>
                <div className="flex flex-col gap-1.5 pr-2 pb-2">
                  {programList.map((item, i) => 
                    renderProgressBar(item.category, item.count, maxProgram, "bg-purple-500", "bg-purple-100", i)
                  )}
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
