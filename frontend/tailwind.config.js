/** @type {import('tailwindcss').Config} */

export default {
  darkMode: "class",
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    container: {
      center: true,
    },
    extend: {
      colors: {
        unri: {
          green: {
            50: "#f0fdf4",
            100: "#dcfce7",
            200: "#bbf7d0",
            300: "#86efac",
            400: "#4ade80",
            500: "#16a34a",
            600: "#15803d",
            700: "#166534",
            800: "#14532d",
            900: "#052e16",
          },
          yellow: {
            50: "#fffbeb",
            100: "#fef3c7",
            200: "#fde68a",
            300: "#fcd34d",
            400: "#fbbf24",
            500: "#f59e0b",
            600: "#d97706",
            700: "#b45309",
            800: "#92400e",
            900: "#78350f",
          },
          red: {
            50: "#fef2f2",
            100: "#fee2e2",
            200: "#fecaca",
            300: "#fca5a5",
            400: "#f87171",
            500: "#ef4444",
            600: "#dc2626",
            700: "#b91c1c",
            800: "#991b1b",
            900: "#7f1d1d",
          },
        },
      },
      fontFamily: {
        sans: ["Plus Jakarta Sans", "Poppins", "Inter", "system-ui", "sans-serif"],
        display: ["Plus Jakarta Sans", "Poppins", "Inter", "sans-serif"],
      },
      animation: {
        "pulse-slow": "pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite",
        "marquee": "marquee 45s linear infinite",
        "count-up": "countUp 0.6s ease-out",
        "fade-in": "fadeIn 0.5s ease-out",
      },
      keyframes: {
        marquee: {
          "0%": { transform: "translateX(0%)" },
          "100%": { transform: "translateX(-50%)" },
        },
        fadeIn: {
          "0%": { opacity: "0", transform: "translateY(8px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
      },
      boxShadow: {
        card: "0 4px 20px -2px rgba(22, 163, 74, 0.08), 0 2px 8px -2px rgba(0, 0, 0, 0.05)",
        "card-lg": "0 8px 30px -4px rgba(22, 163, 74, 0.1), 0 4px 12px -4px rgba(0, 0, 0, 0.06)",
      },
    },
  },
  plugins: [],
};
