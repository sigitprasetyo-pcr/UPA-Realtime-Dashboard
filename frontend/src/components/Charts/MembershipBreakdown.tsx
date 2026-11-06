import { useState } from "react";
import { useLibraryStore } from "../../store/useLibraryStore";
import { Users, ChevronDown } from "lucide-react";
import { formatNumber } from "../../utils/formatters";
import type { MembershipByDemographic, MembershipByFaculty } from "../../types";

type BreakdownType = "faculty" | "gender" | "program" | "age";

export function MembershipBreakdown() {
  const stats = useLibraryStore((s) => s.stats);
  const [activeTab, setActiveTab] = useState<BreakdownType>("faculty");

  const getBreakdownData = () => {
    switch (activeTab) {
      case "faculty":
        return stats.membership_by_faculty;
      case "gender":
        return stats.membership_by_gender;
      case "program":
        return stats.membership_by_program;
      case "age":
        return stats.membership_by_age;
    }
  };

  const getTabLabel = (tab: BreakdownType) => {
    switch (tab) {
      case "faculty":
        return "Fakultas";
      case "gender":
        return "Jenis Kelamin";
      case "program":
        return "Program";
      case "age":
        return "Umur";
    }
  };

  const getTabColors = (tab: BreakdownType) => {
    switch (tab) {
      case "faculty":
        return "from-cyan-500 to-blue-500";
      case "gender":
        return "from-purple-500 to-pink-500";
      case "program":
        return "from-indigo-500 to-cyan-500";
      case "age":
        return "from-teal-500 to-green-500";
    }
  };

  const data = getBreakdownData();
  const total = data.reduce((sum, item) => sum + item.count, 0);
  const maxValue = Math.max(...data.map((item) => item.count), 1);

  return (
    <div className="kpi-card flex flex-col animate-fade-in overflow-hidden">
      <div className="kpi-card-header shrink-0">
        <div className="h-6 w-1.5 rounded-full bg-cyan-500" />
        <Users className="h-5 w-5 text-cyan-600" strokeWidth={2.2} />
        <span className="kpi-title text-cyan-700 tracking-wider">
          KEANGGOTAAN
        </span>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 px-3 pt-3 border-b-2 border-gray-100 shrink-0 overflow-x-auto">
        {(["faculty", "gender", "program", "age"] as BreakdownType[]).map(
          (tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`text-xs font-bold px-3 py-2 whitespace-nowrap border-b-2 transition-all rounded-t-lg ${
                activeTab === tab
                  ? `border-cyan-500 bg-gradient-to-r ${getTabColors(tab)} text-white`
                  : "border-transparent text-gray-700 hover:text-gray-900 hover:bg-gray-100"
              }`}
            >
              {getTabLabel(tab)}
            </button>
          )
        )}
      </div>

      {/* Content */}
      <div className="flex-1 p-3 overflow-y-auto min-h-0">
        <div className="space-y-2.5">
          {data && data.length > 0 ? (
            data.map((item, idx) => {
              const category = "category" in item ? item.category : (item as MembershipByFaculty).faculty;
              const percentage = (item.count / total) * 100;
              const barPercentage = (item.count / maxValue) * 100;

              const colors = {
                faculty: "from-cyan-400 to-blue-600",
                gender: "from-purple-400 to-pink-600",
                program: "from-indigo-400 to-cyan-600",
                age: "from-teal-400 to-green-600",
              };

              return (
                <div key={idx} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <p className="text-sm font-semibold text-gray-900">
                      {category}
                    </p>
                    <div className="text-right">
                      <p className="text-sm font-bold text-cyan-700">
                        {formatNumber(item.count)}
                      </p>
                      <p className="text-xs text-gray-500">
                        {percentage.toFixed(1)}%
                      </p>
                    </div>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-3 overflow-hidden shadow-sm">
                    <div
                      className={`bg-gradient-to-r ${colors[activeTab]} h-full rounded-full transition-all duration-500`}
                      style={{ width: `${barPercentage}%` }}
                    />
                  </div>
                </div>
              );
            })
          ) : (
            <div className="text-center text-sm text-gray-500 py-8">
              Belum ada data keanggotaan
            </div>
          )}

          {/* Total Summary */}
          {data && data.length > 0 && (
            <div className="mt-4 pt-3 border-t-2 border-gray-200 bg-gradient-to-r from-cyan-50 to-blue-50 rounded-lg p-3">
              <div className="flex justify-between items-center">
                <p className="text-sm font-bold text-gray-900">Total Kategori</p>
                <p className="text-lg font-bold text-cyan-700">
                  {formatNumber(total)}
                </p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
