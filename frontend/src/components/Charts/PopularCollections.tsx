import { useLibraryStore } from "../../store/useLibraryStore";
import { TrendingUp, BookOpen } from "lucide-react";
import { formatNumber } from "../../utils/formatters";

export function PopularCollections() {
  const stats = useLibraryStore((s) => s.stats);

  const maxBorrows = Math.max(
    ...(stats.popular_collections?.map((c) => c.borrowCount) || [100]),
    100
  );

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden h-full">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-amber-500" />
        <TrendingUp className="h-5 w-5 text-amber-600" strokeWidth={2.2} />
        <span className="text-[12px] font-black text-amber-700 tracking-widest uppercase">
          KOLEKSI POPULER
        </span>
      </div>

      <div className="flex-1 overflow-hidden relative min-h-0">
        {stats.popular_collections && stats.popular_collections.length > 0 ? (
          <div 
            className="absolute top-0 left-0 w-full animate-marquee-vertical"
            style={{ 
              animationDuration: "25s",
            }}
          >
            {/* Block 1 */}
            <div className="flex flex-col gap-2 p-2.5">
              {stats.popular_collections.map((collection, idx) => {
                const percentage = (collection.borrowCount / maxBorrows) * 100;
                const medals = ["🥇", "🥈", "🥉", "⭐", "✨"];
                const medal = medals[idx] || "📚";

                return (
                  <div
                    key={`b1-${collection.id}`}
                    className="bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-xl px-3 py-2 flex flex-col justify-center shadow-sm"
                  >
                    <div className="flex items-center justify-between gap-2 mb-1.5">
                      <div className="flex items-center gap-1.5 flex-1 min-w-0">
                        <span className="text-base shrink-0">{medal}</span>
                        <p className="text-sm font-bold text-gray-900 truncate">
                          {collection.title}
                        </p>
                      </div>
                      <div className="flex items-center gap-1 shrink-0 bg-white/50 px-2 py-0.5 rounded-md border border-amber-100">
                        <span className="text-sm font-black text-amber-700">
                          {formatNumber(collection.borrowCount)}
                        </span>
                        <span className="text-[11px] text-gray-500 font-semibold">kali</span>
                      </div>
                    </div>
                    <div className="w-full bg-amber-200/50 rounded-full h-2 overflow-hidden shadow-inner">
                      <div
                        className="bg-gradient-to-r from-amber-400 via-orange-400 to-amber-600 h-full rounded-full transition-all duration-1000"
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
            {/* Block 2 (duplicate for seamless loop) */}
            <div className="flex flex-col gap-2 p-2.5">
              {stats.popular_collections.map((collection, idx) => {
                const percentage = (collection.borrowCount / maxBorrows) * 100;
                const medals = ["🥇", "🥈", "🥉", "⭐", "✨"];
                const medal = medals[idx] || "📚";

                return (
                  <div
                    key={`b2-${collection.id}`}
                    className="bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-xl px-3 py-2 flex flex-col justify-center shadow-sm"
                  >
                    <div className="flex items-center justify-between gap-2 mb-1.5">
                      <div className="flex items-center gap-1.5 flex-1 min-w-0">
                        <span className="text-base shrink-0">{medal}</span>
                        <p className="text-sm font-bold text-gray-900 truncate">
                          {collection.title}
                        </p>
                      </div>
                      <div className="flex items-center gap-1 shrink-0 bg-white/50 px-2 py-0.5 rounded-md border border-amber-100">
                        <span className="text-sm font-black text-amber-700">
                          {formatNumber(collection.borrowCount)}
                        </span>
                        <span className="text-[11px] text-gray-500 font-semibold">kali</span>
                      </div>
                    </div>
                    <div className="w-full bg-amber-200/50 rounded-full h-2 overflow-hidden shadow-inner">
                      <div
                        className="bg-gradient-to-r from-amber-400 via-orange-400 to-amber-600 h-full rounded-full transition-all duration-1000"
                        style={{ width: `${percentage}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center py-8 text-center">
            <div className="w-12 h-12 rounded-full bg-amber-100 flex items-center justify-center mb-2">
              <BookOpen className="h-6 w-6 text-amber-600" />
            </div>
            <p className="text-sm font-semibold text-gray-700">
              Belum Ada Data
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
