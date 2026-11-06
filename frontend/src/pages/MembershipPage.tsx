import { useEffect } from "react";
import { Link } from "react-router-dom";
import { Header } from "../components/Header";
import { Footer } from "../components/Footer";
import { RunningTicker } from "../components/RunningTicker";
import { VisitorsCard } from "../components/KPICards/VisitorsCard";
import { MembershipDonut } from "../components/Charts/MembershipDonut";
import { MembershipBreakdown } from "../components/Charts/MembershipBreakdown";
import { ActivityTrendChart } from "../components/Charts/ActivityTrendChart";
import { useLibraryStore } from "../store/useLibraryStore";
import { ArrowLeft } from "lucide-react";

export default function MembershipPage() {
  const startAutoRefresh = useLibraryStore((s) => s.startAutoRefresh);

  useEffect(() => {
    const dispose = startAutoRefresh();
    return dispose;
  }, [startAutoRefresh]);

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
          <span className="text-gray-700 font-semibold">Kategori Keanggotaan</span>
        </div>

        {/* TITLE */}
        <div className="mb-2">
          <h1 className="text-2xl md:text-3xl font-bold text-gray-900">
            Statistik Keanggotaan Perpustakaan
          </h1>
          <p className="text-sm text-gray-600">
            Analisis keanggotaan: Pengunjung, Per Fakultas, Per Jenis Kelamin, Per Program, Per Umur
          </p>
        </div>

        {/* ROW 1: Visitors + Donut */}
        <section className="grid grid-cols-12 gap-3 md:gap-4 h-[35%] min-h-0">
          <div className="col-span-4 min-h-0 h-full">
            <VisitorsCard />
          </div>
          <div className="col-span-4 min-h-0 h-full">
            <MembershipDonut />
          </div>
          <div className="col-span-4 min-h-0 h-full">
            <div className="kpi-card flex flex-col animate-fade-in">
              <div className="kpi-card-header shrink-0">
                <div className="h-6 w-1.5 rounded-full bg-teal-500" />
                <span className="kpi-title text-teal-700 tracking-wider">
                  STATISTIK KEANGGOTAAN
                </span>
              </div>
              <div className="flex-1 p-3 flex flex-col justify-center space-y-4">
                {[
                  {
                    label: "Total Pengunjung",
                    value: useLibraryStore((s) => s.stats.total_visitors_today),
                  },
                  {
                    label: "Anggota Pemustaka",
                    value: useLibraryStore((s) => s.stats.member_visitors),
                  },
                  {
                    label: "Kartu Baca",
                    value: useLibraryStore((s) => s.stats.reading_card_visitors),
                  },
                  {
                    label: "Pengunjung Umum",
                    value: useLibraryStore((s) => s.stats.general_visitors),
                  },
                ].map((item) => (
                  <div key={item.label} className="flex justify-between items-center">
                    <span className="text-sm text-gray-700">{item.label}</span>
                    <span className="text-lg font-bold text-teal-600">
                      {Intl.NumberFormat("id-ID").format(item.value)}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        {/* ROW 2: Breakdown + Activity */}
        <section className="grid grid-cols-12 gap-3 md:gap-4 flex-1 min-h-0">
          <div className="col-span-5 min-h-0 h-full">
            <MembershipBreakdown />
          </div>
          <div className="col-span-7 min-h-0 h-full">
            <ActivityTrendChart />
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
