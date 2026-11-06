import { useEffect } from "react";
import { Link } from "react-router-dom";
import { Header } from "../components/Header";
import { Footer } from "../components/Footer";
import { RunningTicker } from "../components/RunningTicker";
import { AcademicWorkChart } from "../components/Charts/AcademicWorkChart";
import { AcademicWorksDisplay } from "../components/Charts/AcademicWorksLatest";
import { useLibraryStore } from "../store/useLibraryStore";
import { ArrowLeft, Award, BookMarked, GraduationCap } from "lucide-react";

export default function AcademicWorksPage() {
  const startAutoRefresh = useLibraryStore((s) => s.startAutoRefresh);
  const stats = useLibraryStore((s) => s.stats);

  useEffect(() => {
    const dispose = startAutoRefresh();
    return dispose;
  }, [startAutoRefresh]);

  const academicStats = [
    {
      label: "Tugas Akhir D3",
      value: stats.ta_d3,
      icon: GraduationCap,
      color: "bg-green-50 border-green-200",
      textColor: "text-green-700",
    },
    {
      label: "Skripsi S1",
      value: stats.skripsi_s1,
      icon: BookMarked,
      color: "bg-blue-50 border-blue-200",
      textColor: "text-blue-700",
    },
    {
      label: "Tesis S2",
      value: stats.tesis_s2,
      icon: Award,
      color: "bg-purple-50 border-purple-200",
      textColor: "text-purple-700",
    },
    {
      label: "Karya Ilmiah Dosen",
      value: stats.karya_ilmiah_dosen,
      icon: Award,
      color: "bg-amber-50 border-amber-200",
      textColor: "text-amber-700",
    },
  ];

  return (
    <div className="w-screen h-screen flex flex-col overflow-hidden bg-[#f8faf8]">
      {/* HEADER */}
      <Header />

      {/* MAIN CONTENT */}
      <main className="flex-1 min-h-0 p-3 md:p-4 flex flex-col gap-3 md:gap-4 overflow-hidden">
        {/* BREADCRUMB */}
        <div className="flex items-center gap-2 text-sm">
          <Link
            to="/"
            className="flex items-center gap-1 text-blue-600 hover:text-blue-700 font-medium"
          >
            <ArrowLeft className="h-4 w-4" />
            Kembali ke Dashboard
          </Link>
          <span className="text-gray-400">/</span>
          <span className="text-gray-700 font-semibold">Kategori Tugas Akhir</span>
        </div>

        {/* TITLE */}
        <div className="mb-2">
          <h1 className="text-2xl md:text-3xl font-bold text-gray-900">
            Penerimaan Karya Ilmiah & Tugas Akhir
          </h1>
          <p className="text-sm text-gray-600">
            D3, Skripsi, Tesis, dan Karya Ilmiah Dosen
          </p>
        </div>

        {/* ROW 1: Statistics Cards */}
        <section className="grid grid-cols-4 gap-3 md:gap-4 h-[22%] min-h-0">
          {academicStats.map((stat) => {
            const Icon = stat.icon;
            return (
              <div
                key={stat.label}
                className={`kpi-card border-2 ${stat.color} flex flex-col animate-fade-in`}
              >
                <div className={`kpi-card-header shrink-0 ${stat.textColor}`}>
                  <Icon className="h-5 w-5" strokeWidth={2} />
                  <span className="text-xs font-bold tracking-wider">
                    {stat.label}
                  </span>
                </div>
                <div className="flex-1 flex items-center justify-center">
                  <p className={`text-5xl font-bold ${stat.textColor}`}>
                    {stat.value}
                  </p>
                </div>
              </div>
            );
          })}
        </section>

        {/* ROW 2: Chart + List */}
        <section className="grid grid-cols-12 gap-3 md:gap-4 flex-1 min-h-0">
          <div className="col-span-5 min-h-0 h-full">
            <AcademicWorkChart />
          </div>
          <div className="col-span-7 min-h-0 h-full">
            <AcademicWorksDisplay />
          </div>
        </section>
      </main>

      {/* RUNNING TICKER */}
      <RunningTicker />

      {/* FOOTER */}
      <Footer />
    </div>
  );
}
