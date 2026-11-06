import { useEffect, useRef, useState } from "react";

export function useCountAnimation(
  target: number,
  durationMs = 700,
  decimals = 0,
): { value: number; delta: number } {
  const [value, setValue] = useState(target);
  const rafRef = useRef<number | null>(null);
  const fromRef = useRef(target);
  const startRef = useRef<number>(performance.now());
  const deltaRef = useRef(0);

  useEffect(() => {
    const from = value;
    const to = target;
    if (from === to) {
      deltaRef.current = 0;
      return;
    }
    fromRef.current = from;
    startRef.current = performance.now();
    deltaRef.current = to - from;

    const easeOutCubic = (t: number) => 1 - Math.pow(1 - t, 3);

    const tick = (now: number) => {
      const elapsed = now - startRef.current;
      const p = Math.min(1, elapsed / durationMs);
      const eased = easeOutCubic(p);
      const current = fromRef.current + (to - fromRef.current) * eased;
      setValue(decimals > 0 ? parseFloat(current.toFixed(decimals)) : Math.round(current));
      if (p < 1) {
        rafRef.current = requestAnimationFrame(tick);
      } else {
        rafRef.current = null;
      }
    };
    if (rafRef.current) cancelAnimationFrame(rafRef.current);
    rafRef.current = requestAnimationFrame(tick);

    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [target, durationMs, decimals]);

  return { value, delta: deltaRef.current };
}
