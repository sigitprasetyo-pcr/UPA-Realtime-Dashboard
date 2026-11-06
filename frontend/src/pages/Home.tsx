import { useEffect, useState } from "react";
import { Header } from "../components/Header";
import { Footer } from "../components/Footer";
import { RunningTicker } from "../components/RunningTicker";
import { VisitorsCard } from "../components/KPICards/VisitorsCard";
import { CollectionCard } from "../components/KPICards/CollectionCard";
import { TransactionInfoCard } from "../components/KPICards/TransactionInfoCard";
import { InternalResourcesCard } from "../components/KPICards/InternalResourcesCard";
import { ActivityTrendChart } from "../components/Charts/ActivityTrendChart";
import { CollectionClassChart } from "../components/Charts/CollectionClassChart";
import { AcademicWorkChart } from "../components/Charts/AcademicWorkChart";
import { AdminTransactionsCard } from "../components/Charts/AdminTransactionsCard";
import { LateBooksList } from "../components/Charts/LateBooksList";
import { PopularCollections } from "../components/Charts/PopularCollections";
import { MembershipStatsCard } from "../components/Charts/MembershipStatsCard";
import { LatestAcademicWorks } from "../components/Charts/LatestAcademicWorks";
import { BebasPustakaCard } from "../components/KPICards/BebasPustakaCard";
import { ContactSlide } from "../components/ContactSlide";
import { useLibraryStore } from "../store/useLibraryStore";

export default function Home() {
  const startAutoRefresh = useLibraryStore((s) => s.startAutoRefresh);
  const settings = useLibraryStore((s) => s.settings);
  const fetchSettings = useLibraryStore((s) => s.fetchSettings);
  const [currentSlide, setCurrentSlide] = useState(0);

  const isPusat = settings?.activeBranch === "Pusat";
  const slideDuration = settings?.slideDuration || 25000;
  const slideCount = 4;

  useEffect(() => {
    fetchSettings();
  }, [fetchSettings]);

  useEffect(() => {
    const dispose = startAutoRefresh();
    return dispose;
  }, [startAutoRefresh]);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % slideCount);
    }, slideDuration);
    return () => clearInterval(interval);
  }, [slideDuration, slideCount]);

  return (
    <div className="w-screen h-screen flex flex-col overflow-hidden bg-[#f8faf8]">
      {/* HEADER */}
      <Header />

      {/* MAIN CONTENT - SLIDE CONTAINER */}
      <main className="flex-1 min-h-0 flex flex-col overflow-hidden relative">
        <div 
          className="flex-1 min-h-0 flex w-full transition-transform duration-1000 ease-[cubic-bezier(0.25,1,0.5,1)]"
          style={{ transform: `translateX(-${currentSlide * 100}%)` }}
        >
          {/* ============ SLIDE 1: KATEGORI KOLEKSI & AKTIVITAS ============ */}
          <div className="w-full shrink-0 h-full flex flex-col gap-1.5 px-2 py-1.5 overflow-hidden">
            <section className="grid grid-cols-3 gap-1.5 flex-[3] min-h-0">
              <div className="min-h-0 overflow-hidden flex flex-col">
                <CollectionCard isActive={currentSlide === 0} />
              </div>
              <div className="col-span-2 min-h-0 overflow-hidden flex flex-col">
                <ActivityTrendChart isActive={currentSlide === 0} />
              </div>
            </section>
            <section className="grid grid-cols-3 gap-1.5 flex-[4] min-h-0">
              <div className="col-span-2 min-h-0 overflow-hidden flex flex-col">
                <CollectionClassChart isActive={currentSlide === 0} />
              </div>
              <div className="min-h-0 overflow-hidden flex flex-col">
                <PopularCollections />
              </div>
            </section>
          </div>

          {/* ============ SLIDE 2: KATEGORI KEANGGOTAAN & TRANSAKSI ============ */}
          <div className="w-full shrink-0 h-full grid grid-cols-3 grid-rows-2 gap-1.5 px-2 py-1.5 overflow-hidden">
            {/* Column 1: Kunjungan & Info Sirkulasi */}
            <div className="col-start-1 row-start-1 min-h-0 overflow-hidden flex flex-col">
              <VisitorsCard />
            </div>
            <div className="col-start-1 row-start-2 min-h-0 overflow-hidden flex flex-col">
              <TransactionInfoCard />
            </div>

            {/* Column 2: Demografi Keanggotaan */}
            <div className="col-start-2 row-start-1 row-span-2 min-h-0 overflow-hidden flex flex-col">
              <MembershipStatsCard isActive={currentSlide === 1} />
            </div>

            {/* Column 3: Administrasi & Keterlambatan */}
            <div className="col-start-3 row-start-1 min-h-0 overflow-hidden flex flex-col">
              {isPusat ? (
                <AdminTransactionsCard />
              ) : (
                <div className="grid grid-cols-2 gap-1.5 h-full min-h-0">
                  <BebasPustakaCard />
                  <AdminTransactionsCard />
                </div>
              )}
            </div>
            <div className="col-start-3 row-start-2 min-h-0 overflow-hidden flex flex-col">
              <LateBooksList isActive={currentSlide === 1} />
            </div>
          </div>

          {/* ============ SLIDE 3: KATEGORI TUGAS AKHIR ============ */}
          <div className="w-full shrink-0 h-full flex flex-col gap-1.5 px-2 py-1.5 overflow-hidden">
            <section className="grid grid-cols-3 gap-1.5 flex-[4] min-h-0">
              <div className="min-h-0 overflow-hidden flex flex-col">
                <InternalResourcesCard />
              </div>
              <div className="col-span-2 min-h-0 overflow-hidden flex flex-col">
                <AcademicWorkChart isActive={currentSlide === 2} />
              </div>
            </section>
            <section className="grid grid-cols-1 gap-1.5 flex-[5] min-h-0">
              <div className="min-h-0 overflow-hidden flex flex-col">
                <LatestAcademicWorks isActive={currentSlide === 2} />
              </div>
            </section>
          </div>

          {/* ============ SLIDE 4: KONTAK ============ */}
          <div className="w-full shrink-0 h-full overflow-hidden">
            <ContactSlide />
          </div>
        </div>

        {/* Slide Indicators */}
        <div className="flex gap-1.5 justify-center pb-1.5 z-10 shrink-0">
          {Array.from({ length: slideCount }).map((_, idx) => (
            <button
              key={idx}
              onClick={() => setCurrentSlide(idx)}
              className={`h-1.5 rounded-full transition-all ${
                currentSlide === idx ? "bg-green-700 w-5" : "bg-gray-400 w-1.5 hover:bg-gray-500"
              }`}
            />
          ))}
        </div>
      </main>

      {/* RUNNING TICKER */}
      <RunningTicker />

      {/* FOOTER */}
      <Footer />
    </div>
  );
}
