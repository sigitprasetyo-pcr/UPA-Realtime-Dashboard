import { useEffect, useState } from "react";

interface RealTimeClock {
  dateString: string;
  timeString: string;
  timeStringNoTz: string;
  weekday: string;
}

const WEEKDAYS_ID = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
const MONTHS_ID = [
  "Januari", "Februari", "Maret", "April", "Mei", "Juni",
  "Juli", "Agustus", "September", "Oktober", "November", "Desember",
];

function pad(n: number) {
  return n.toString().padStart(2, "0");
}

function formatClock(d: Date): RealTimeClock {
  const weekday = WEEKDAYS_ID[d.getDay()];
  const day = d.getDate();
  const month = MONTHS_ID[d.getMonth()];
  const year = d.getFullYear();
  const dateString = `${weekday}, ${day} ${month} ${year}`;

  const hh = pad(d.getHours());
  const mm = pad(d.getMinutes());
  const ss = pad(d.getSeconds());
  return {
    dateString,
    timeString: `${hh}:${mm}:${ss} WIB`,
    timeStringNoTz: `${hh}:${mm}:${ss}`,
    weekday,
  };
}

export function useRealTimeClock(): RealTimeClock {
  const [now, setNow] = useState<RealTimeClock>(() => formatClock(new Date()));

  useEffect(() => {
    const id = window.setInterval(() => {
      setNow(formatClock(new Date()));
    }, 1000);
    return () => window.clearInterval(id);
  }, []);

  return now;
}
