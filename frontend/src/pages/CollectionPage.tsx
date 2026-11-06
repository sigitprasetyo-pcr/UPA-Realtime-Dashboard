import { useEffect } from "react";
import { Link } from "react-router-dom";
import { Header } from "../components/Header";
import { Footer } from "../components/Footer";
import { RunningTicker } from "../components/RunningTicker";
import { CollectionCard } from "../components/KPICards/CollectionCard";
import { InternalResourcesCard } from "../components/KPICards/InternalResourcesCard";
import { PopularCollections } from "../components/Charts/PopularCollections";
import { CollectionClassChart } from "../components/Charts/CollectionClassChart";
import { LateBooksList } from "../components/Charts/LateBooksList";
import { useLibraryStore } from "../store/useLibraryStore";
import { ArrowLeft } from "lucide-react";

export default function CollectionPage() {
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
          <span className="text-gray-700 font-semibold">Kategori Koleksi</span>
        </div>

        {/* TITLE */}
        <div className="mb-2">
          <h1 className="text-2xl md:text-3xl font-bold text-gray-900">
            Statistik Koleksi Buku
          </h1>
          <p className="text-sm text-gray-600">
            Kategori: Umum (000), Komputer & TI (300), Sosial (600)
          </p>
        </div>

        {/* ROW 1: 3 KPI cards */}
        <section className="grid grid-cols-3 gap-3 md:gap-4 h-[28%] min-h-0">
          <CollectionCard />
          <InternalResourcesCard />
          <div className="kpi-card flex flex-col animate-fade-in">
            <div className="kpi-card-header shrink-0 flex-1">
              <div className="h-6 w-1.5 rounded-full bg-orange-500" />
              <span className="kpi-title text-orange-700 tracking-wider">
                TOTAL KOLEKSI
              </span>
            </div>
            <div className="flex-1 flex flex-col justify-center items-center">
              <p className="text-4xl md:text-5xl font-bold text-orange-600">
                {Intl.NumberFormat("id-ID").format(
                  useLibraryStore((s) => s.stats.total_copies)
                )}
              </p>
              <p className="text-xs text-gray-600 mt-2">
                {Intl.NumberFormat("id-ID").format(
                  useLibraryStore((s) => s.stats.total_book_titles)
                )}{" "}
                judul
              </p>
            </div>
          </div>
        </section>

        {/* ROW 2: Charts */}
        <section className="grid grid-cols-12 gap-3 md:gap-4 flex-1 min-h-0">
          <div className="col-span-6 min-h-0 h-full">
            <CollectionClassChart />
          </div>
          <div className="col-span-6 grid grid-rows-2 gap-3 md:gap-4 min-h-0 h-full">
            <PopularCollections />
            <LateBooksList />
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
