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

  const [touchStart, setTouchStart] = useState<number | null>(null);
  const [touchEnd, setTouchEnd] = useState<number | null>(null);

  const minSwipeDistance = 50;

  const onTouchStart = (e: React.TouchEvent) => {
    setTouchEnd(null);
    setTouchStart(e.targetTouches[0].clientX);
  };

  const onTouchMove = (e: React.TouchEvent) => {
    setTouchEnd(e.targetTouches[0].clientX);
  };

  const onTouchEnd = () => {
    if (!touchStart || !touchEnd) return;
    const distance = touchStart - touchEnd;
    if (distance > minSwipeDistance) {
      setCurrentSlide((prev) => (prev + 1) % slideCount);
    } else if (distance < -minSwipeDistance) {
      setCurrentSlide((prev) => (prev - 1 + slideCount) % slideCount);
    }
  };

  const SLIDE_TABS = [
    { id: 0, title: "Koleksi", icon: "📚" },
    { id: 1, title: "Keanggotaan", icon: "👥" },
    { id: 2, title: "Tugas Akhir", icon: "🎓" },
    { id: 3, title: "Kontak", icon: "📞" },
  ];

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
    <div className="w-full h-full md:w-screen md:h-screen flex flex-col overflow-x-hidden md:overflow-hidden bg-[#f8faf8]">
      {/* HEADER */}
      <Header />

      {/* MOBILE CATEGORY TABS (visible only on mobile/small screens) */}
      <div className="flex md:hidden items-center justify-between bg-white border-b border-unri-green-100 px-2 py-1.5 shrink-0 gap-1.5 overflow-x-auto shadow-xs">
        {SLIDE_TABS.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setCurrentSlide(tab.id)}
            className={`flex-1 flex items-center justify-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold transition-all whitespace-nowrap ${
              currentSlide === tab.id
                ? "bg-unri-green-600 text-white shadow-sm"
                : "bg-gray-100 text-gray-700 hover:bg-gray-200"
            }`}
          >
            <span>{tab.icon}</span>
            <span>{tab.title}</span>
          </button>
        ))}
      </div>

      {/* MAIN CONTENT - SLIDE CONTAINER */}
      <main
        className="flex-1 min-h-0 flex flex-col overflow-hidden relative"
        onTouchStart={onTouchStart}
        onTouchMove={onTouchMove}
        onTouchEnd={onTouchEnd}
      >
        <div 
          className="flex-1 min-h-0 flex w-full transition-transform duration-700 md:duration-1000 ease-[cubic-bezier(0.25,1,0.5,1)]"
          style={{ transform: `translateX(-${currentSlide * 100}%)` }}
        >
          {/* ============ SLIDE 1: KATEGORI KOLEKSI & AKTIVITAS ============ */}
          <div className="w-full shrink-0 h-full flex flex-col gap-2 md:gap-1.5 p-2 md:px-2 md:py-1.5 overflow-y-auto md:overflow-hidden">
            <section className="flex flex-col md:grid md:grid-cols-3 gap-2 md:gap-1.5 md:flex-[3] min-h-0">
              <div className="min-h-0 md:overflow-hidden flex flex-col">
                <CollectionCard isActive={currentSlide === 0} />
              </div>
              <div className="md:col-span-2 min-h-[260px] md:min-h-0 md:overflow-hidden flex flex-col">
                <ActivityTrendChart isActive={currentSlide === 0} />
              </div>
            </section>
            <section className="flex flex-col md:grid md:grid-cols-3 gap-2 md:gap-1.5 md:flex-[4] min-h-0">
              <div className="md:col-span-2 min-h-[280px] md:min-h-0 md:overflow-hidden flex flex-col">
                <CollectionClassChart isActive={currentSlide === 0} />
              </div>
              <div className="min-h-0 md:overflow-hidden flex flex-col">
                <PopularCollections />
              </div>
            </section>
          </div>

          {/* ============ SLIDE 2: KATEGORI KEANGGOTAAN & TRANSAKSI ============ */}
          <div className="w-full shrink-0 h-full flex flex-col md:grid md:grid-cols-3 md:grid-rows-2 gap-2 md:gap-1.5 p-2 md:px-2 md:py-1.5 overflow-y-auto md:overflow-hidden">
            {/* Column 1: Kunjungan & Info Sirkulasi */}
            <div className="md:col-start-1 md:row-start-1 min-h-0 md:overflow-hidden flex flex-col">
              <VisitorsCard />
            </div>
            <div className="md:col-start-1 md:row-start-2 min-h-0 md:overflow-hidden flex flex-col">
              <TransactionInfoCard />
            </div>

            {/* Column 2: Demografi Keanggotaan */}
            <div className="md:col-start-2 md:row-start-1 md:row-span-2 min-h-[460px] md:min-h-0 md:overflow-hidden flex flex-col">
              <MembershipStatsCard isActive={currentSlide === 1} />
            </div>

            {/* Column 3: Administrasi & Keterlambatan */}
            <div className="md:col-start-3 md:row-start-1 min-h-0 md:overflow-hidden flex flex-col">
              {isPusat ? (
                <AdminTransactionsCard />
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 gap-1.5 h-full min-h-0">
                  <BebasPustakaCard />
                  <AdminTransactionsCard />
                </div>
              )}
            </div>
            <div className="md:col-start-3 md:row-start-2 min-h-[260px] md:min-h-0 md:overflow-hidden flex flex-col">
              <LateBooksList isActive={currentSlide === 1} />
            </div>
          </div>

          {/* ============ SLIDE 3: KATEGORI TUGAS AKHIR ============ */}
          <div className="w-full shrink-0 h-full flex flex-col gap-2 md:gap-1.5 p-2 md:px-2 md:py-1.5 overflow-y-auto md:overflow-hidden">
            <section className="flex flex-col md:grid md:grid-cols-3 gap-2 md:gap-1.5 md:flex-[4] min-h-0">
              <div className="min-h-0 md:overflow-hidden flex flex-col">
                <InternalResourcesCard />
              </div>
              <div className="md:col-span-2 min-h-[260px] md:min-h-0 md:overflow-hidden flex flex-col">
                <AcademicWorkChart isActive={currentSlide === 2} />
              </div>
            </section>
            <section className="flex flex-col md:grid md:grid-cols-1 gap-2 md:gap-1.5 md:flex-[5] min-h-0">
              <div className="min-h-0 md:overflow-hidden flex flex-col">
                <LatestAcademicWorks isActive={currentSlide === 2} />
              </div>
            </section>
          </div>

          {/* ============ SLIDE 4: KONTAK ============ */}
          <div className="w-full shrink-0 h-full overflow-y-auto md:overflow-hidden">
            <ContactSlide />
          </div>
        </div>

        {/* Slide Indicators */}
        <div className="flex gap-1.5 justify-center py-1 z-10 shrink-0">
          {Array.from({ length: slideCount }).map((_, idx) => (
            <button
              key={idx}
              onClick={() => setCurrentSlide(idx)}
              aria-label={`Slide ${idx + 1}`}
              className={`h-1.5 rounded-full transition-all ${
                currentSlide === idx ? "bg-unri-green-700 w-6" : "bg-gray-300 w-2 hover:bg-gray-400"
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
