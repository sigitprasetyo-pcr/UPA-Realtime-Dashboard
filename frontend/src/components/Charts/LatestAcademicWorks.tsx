import { useLibraryStore } from "../../store/useLibraryStore";
import { GraduationCap, Award, Calendar, User } from "lucide-react";
import { maskNimWithFaculty } from "../../utils/formatters";
import type { AcademicWorkDetail } from "../../types";

export function LatestAcademicWorks({ isActive = true }: { isActive?: boolean }) {
  const stats = useLibraryStore((s) => s.stats);

  const works = stats.academic_works || [];
  const worksCount = works.length;
  // Scroll if we have more than 6 items (since it's a 2-column grid, 6 items is 3 rows). Currently we have 6 items in dummy data.
  // We'll set it to scroll if > 4 so it animates.
  const shouldScroll = worksCount > 4;
  // 4 seconds per row for a comfortable reading speed
  const scrollDuration = Math.max(20, Math.ceil(worksCount / 2) * 4);

  const getBadgeColor = (type: string) => {
    switch (type) {
      case "ta_d3": return "bg-green-100 text-green-700";
      case "skripsi_s1": return "bg-yellow-100 text-yellow-700";
      case "tesis_s2": return "bg-blue-100 text-blue-700";
      case "disertasi_s3": return "bg-purple-100 text-purple-700";
      default: return "bg-gray-100 text-gray-700";
    }
  };

  const formatType = (type: string) => {
    switch (type) {
      case "ta_d3": return "TA / D3";
      case "skripsi_s1": return "Skripsi / S1";
      case "tesis_s2": return "Tesis / S2";
      case "disertasi_s3": return "Disertasi / S3";
      default: return "Karya Ilmiah";
    }
  };

  // Mock a supervisor based on the author's name length to keep it consistent
  const getSupervisor = (author: string) => {
    const supervisors = ["Prof. Dr. Irwan", "Dr. Budi Santoso", "Dr. Siti Aminah", "Prof. Yudi", "Dr. Rina", "Prof. Dr. Hasan"];
    return supervisors[author.length % supervisors.length];
  };

  const renderWorkItem = (work: AcademicWorkDetail, uniqueKey: string) => (
    <div
      key={uniqueKey}
      className="flex flex-col justify-between bg-gradient-to-br from-white to-blue-50/30 border border-blue-100/60 rounded-xl p-3 shrink-0 shadow-sm hover:shadow-md transition-shadow"
    >
      <div className="flex items-start gap-3">
        {/* Icon */}
        <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center flex-shrink-0 shadow-sm mt-0.5">
          <Award className="h-5 w-5 text-white" />
        </div>

        {/* Info */}
        <div className="flex-1 min-w-0 flex flex-col">
          {/* Author and Type */}
          <div className="flex items-start justify-between gap-1.5 mb-1">
            <div className="flex flex-col min-w-0">
              <p className="font-bold text-sm text-gray-900 truncate leading-tight">
                {work.author}
              </p>
              <p className="text-[11px] text-gray-500 font-medium">
                NIM: {maskNimWithFaculty(work.nim, work.faculty)}
              </p>
            </div>
            <span className={`text-[10px] font-bold px-2 py-0.5 rounded-md whitespace-nowrap shrink-0 ${getBadgeColor(work.type)}`}>
              {formatType(work.type)}
            </span>
          </div>

          {/* Title */}
          <p className="text-[13px] text-gray-800 line-clamp-2 font-semibold mb-2 leading-snug">
            {work.title}
          </p>

          <div className="mt-auto flex items-center justify-between pt-1 border-t border-blue-50/50">
            {/* Supervisor */}
            <div className="flex items-center gap-1 text-gray-600">
              <User className="h-3 w-3" />
              <span className="text-[10px] truncate max-w-[120px]">
                Pembimbing: {getSupervisor(work.author)}
              </span>
            </div>
            
            {/* Date */}
            <div className="flex items-center gap-1 text-gray-500">
              <Calendar className="h-3 w-3" />
              <span className="text-[10px] font-medium">
                {new Date(work.submissionDate).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' })}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0 z-10 bg-white shadow-sm">
        <div className="h-6 w-1.5 rounded-full bg-blue-500" />
        <GraduationCap className="h-5 w-5 text-blue-600" strokeWidth={2.2} />
        <span className="kpi-title text-blue-700 tracking-wider">
          KARYA ILMIAH TERBARU
        </span>
      </div>

      {/* Content with seamless continuous scrolling */}
      <div className="flex-1 overflow-hidden relative min-h-0 bg-white">
        {worksCount > 0 ? (
          <div 
            className={`absolute top-0 left-0 w-full flex flex-col ${
              shouldScroll 
                ? "animate-marquee-vertical hover:[animation-play-state:paused]" 
                : ""
            }`}
            style={{ 
              animationDuration: shouldScroll ? `${scrollDuration}s` : undefined,
              animationPlayState: shouldScroll ? (isActive ? "running" : "paused") : undefined
            }}
          >
            {/* Block 1 */}
            <div className="grid grid-cols-2 gap-3 pb-3 px-3 pt-3">
              {works.map((work) => renderWorkItem(work, `block1-${work.id}`))}
            </div>
            {/* Block 2 (duplicate for seamless loop, only render if scrolling) */}
            {shouldScroll && (
              <div className="grid grid-cols-2 gap-3 pb-3 px-3 pt-3">
                {works.map((work) => renderWorkItem(work, `block2-${work.id}`))}
              </div>
            )}
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center h-full text-center">
            <div className="w-14 h-14 rounded-full bg-blue-100 flex items-center justify-center mb-3">
              <Award className="h-7 w-7 text-blue-600" />
            </div>
            <p className="text-base font-semibold text-gray-700">
              Belum ada karya terbaru
            </p>
          </div>
        )}
      </div>

      <div className="h-1 bg-gradient-to-r from-blue-200 via-indigo-400 to-blue-200 shrink-0 z-10 relative" />
    </div>
  );
}
