import { useLibraryStore } from "../../store/useLibraryStore";
import { BookOpen, Award, GraduationCap, Calendar, Building2 } from "lucide-react";

export function AcademicWorksDisplay() {
  const stats = useLibraryStore((s) => s.stats);

  const typeLabels = {
    ta_d3: "Tugas Akhir D3",
    skripsi_s1: "Skripsi S1",
    tesis_s2: "Tesis S2",
    karya_dosen: "Karya Ilmiah Dosen",
  };

  const typeColors = {
    ta_d3: {
      bg: "bg-gradient-to-br from-green-50 to-emerald-100",
      border: "border-green-300",
      badge: "bg-green-100 text-green-700",
      icon: "text-green-600",
    },
    skripsi_s1: {
      bg: "bg-gradient-to-br from-blue-50 to-cyan-100",
      border: "border-blue-300",
      badge: "bg-blue-100 text-blue-700",
      icon: "text-blue-600",
    },
    tesis_s2: {
      bg: "bg-gradient-to-br from-purple-50 to-indigo-100",
      border: "border-purple-300",
      badge: "bg-purple-100 text-purple-700",
      icon: "text-purple-600",
    },
    karya_dosen: {
      bg: "bg-gradient-to-br from-amber-50 to-orange-100",
      border: "border-amber-300",
      badge: "bg-amber-100 text-amber-700",
      icon: "text-amber-600",
    },
  };

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-violet-500" />
        <Award className="h-5 w-5 text-violet-600" strokeWidth={2.2} />
        <span className="kpi-title text-violet-700 tracking-wider">
          KARYA ILMIAH TERBARU
        </span>
      </div>

      <div className="flex-1 p-3 overflow-y-auto min-h-0">
        <div className="space-y-2.5">
          {stats.academic_works && stats.academic_works.length > 0 ? (
            stats.academic_works.map((work) => {
              const colors = typeColors[work.type] || typeColors.karya_dosen;
              const Icon = work.type === "ta_d3" ? GraduationCap : BookOpen;

              return (
                <div
                  key={work.id}
                  className={`${colors.bg} border-2 ${colors.border} rounded-lg p-3 hover:shadow-lg hover:border-opacity-100 transition-all`}
                >
                  <div className="flex items-start gap-2.5">
                    {/* Icon */}
                    <div className="p-2.5 rounded-lg bg-white shadow-sm">
                      <Icon className={`h-5 w-5 ${colors.icon}`} />
                    </div>

                    {/* Content */}
                    <div className="flex-1 min-w-0">
                      {/* Badge */}
                      <div className="inline-block mb-1.5">
                        <span className={`text-xs font-bold px-2.5 py-1 ${colors.badge} rounded-md`}>
                          {typeLabels[work.type]}
                        </span>
                      </div>

                      {/* Title */}
                      <p className="text-sm font-bold text-gray-900 line-clamp-2 mb-1">
                        {work.title}
                      </p>

                      {/* Author */}
                      <p className="text-xs text-gray-700 font-medium mb-2">
                        {work.author}
                      </p>

                      {/* Meta Info */}
                      <div className="flex flex-wrap gap-2 items-center text-xs text-gray-600">
                        <div className="flex items-center gap-1">
                          <Building2 className="h-3.5 w-3.5" />
                          <span className="font-medium">{work.faculty}</span>
                        </div>
                        <span className="text-gray-400">•</span>
                        <div className="flex items-center gap-1">
                          <Calendar className="h-3.5 w-3.5" />
                          <span>
                            {new Date(work.submissionDate).toLocaleDateString(
                              "id-ID",
                              {
                                day: "numeric",
                                month: "short",
                                year: "numeric",
                              }
                            )}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              );
            })
          ) : (
            <div className="flex flex-col items-center justify-center py-12 text-center">
              <div className="w-16 h-16 rounded-full bg-violet-100 flex items-center justify-center mb-3">
                <BookOpen className="h-8 w-8 text-violet-600" />
              </div>
              <p className="text-sm font-semibold text-gray-700">
                Belum Ada Data
              </p>
              <p className="text-xs text-gray-500 mt-1">
                Karya ilmiah terbaru akan ditampilkan di sini
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
