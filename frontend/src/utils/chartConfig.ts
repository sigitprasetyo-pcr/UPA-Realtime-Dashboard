import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
  type ChartOptions,
} from "chart.js";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler,
);

export const TV_FONT = "'Plus Jakarta Sans', 'Poppins', 'Inter', sans-serif";

ChartJS.defaults.font.family = TV_FONT;
ChartJS.defaults.font.size = 12;
ChartJS.defaults.color = "#374151";

export function buildLineChartOptions(yMax = 60): ChartOptions<"line"> {
  return {
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      duration: 500,
      easing: "easeOutQuart",
    },
    interaction: { mode: "index", intersect: false },
    plugins: {
      legend: {
        position: "bottom",
        align: "start",
        labels: {
          boxWidth: 10,
          boxHeight: 10,
          padding: 10,
          usePointStyle: true,
          pointStyle: "circle",
          font: { size: 11, weight: 600, family: TV_FONT },
        },
      },
      tooltip: {
        backgroundColor: "#14532d",
        titleFont: { size: 12, family: TV_FONT, weight: 700 },
        bodyFont: { size: 11, family: TV_FONT },
        padding: 10,
        cornerRadius: 8,
        borderColor: "#16a34a",
        borderWidth: 1,
      },
    },
    scales: {
      x: {
        grid: { display: false },
        ticks: {
          font: { size: 10, weight: 600, family: TV_FONT },
          color: "#166534",
        },
        border: { color: "#bbf7d0" },
      },
      y: {
        beginAtZero: true,
        max: yMax,
        ticks: {
          stepSize: 15,
          font: { size: 10, family: TV_FONT, weight: 500 },
          color: "#4b5563",
        },
        grid: { color: "rgba(22, 163, 74, 0.08)" },
        border: { color: "#bbf7d0" },
      },
    },
  };
}

export function buildBarChartOptions(horizontal = false): ChartOptions<"bar"> {
  return {
    indexAxis: horizontal ? "y" : "x",
    responsive: true,
    maintainAspectRatio: false,
    animation: {
      [horizontal ? "x" : "y"]: {
        duration: 800,
        easing: "easeOutQuart",
        delay: (context: any) => {
          if (context.type === "data") {
            return 500 + context.dataIndex * 150; // 500ms base + 150ms stagger
          }
          return 0;
        },
      }
    },
    plugins: {
      legend: { display: false },
      tooltip: {
        backgroundColor: "#78350f",
        titleFont: { size: 13, family: TV_FONT, weight: 700 },
        bodyFont: { size: 12, family: TV_FONT },
        padding: 12,
        cornerRadius: 10,
      },
    },
    scales: horizontal
      ? {
          x: {
            beginAtZero: true,
            ticks: {
              font: { size: 11, family: TV_FONT, weight: 500 },
              color: "#4b5563",
            },
            grid: { color: "rgba(202, 138, 4, 0.08)" },
            border: { color: "#fde68a" },
          },
          y: {
            grid: { display: false },
            ticks: {
              font: { size: 12, family: TV_FONT, weight: 700 },
              color: "#166534",
            },
            border: { color: "#fde68a" },
          },
        }
      : {
          x: {
            grid: { display: false },
            ticks: {
              font: { size: 11, family: TV_FONT, weight: 600 },
              color: "#166534",
            },
            border: { color: "#bbf7d0" },
          },
          y: {
            beginAtZero: true,
            ticks: {
              font: { size: 11, family: TV_FONT, weight: 500 },
              color: "#4b5563",
            },
            grid: { color: "rgba(22, 163, 74, 0.08)" },
            border: { color: "#bbf7d0" },
          },
        },
  };
}

export function buildDonutOptions(): ChartOptions<"doughnut"> {
  return {
    responsive: true,
    maintainAspectRatio: false,
    cutout: "72%",
    animation: {
      duration: 900,
      easing: "easeOutQuart",
      delay: (context: any) => {
        if (context.type === "data" && context.mode === "default") return 500;
        return 0;
      },
    },
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        backgroundColor: "#14532d",
        titleFont: { size: 13, family: TV_FONT, weight: 700 },
        bodyFont: { size: 12, family: TV_FONT },
        padding: 12,
        cornerRadius: 10,
      },
    },
  };
}
