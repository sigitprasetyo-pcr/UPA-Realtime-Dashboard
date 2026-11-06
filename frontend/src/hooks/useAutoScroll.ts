import { useEffect, useRef } from "react";

export interface UseAutoScrollOptions {
  baseSpeed?: number;
  pauseAtEndsMs?: number;
}

// No-op auto-scroll hook: returns a ref but doesn't perform any animation.
// This preserves existing API but cancels all auto scrolling.
export function useAutoScroll<T extends HTMLElement>(_options: UseAutoScrollOptions = {}) {
  const containerRef = useRef<T | null>(null);

  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    // Ensure any leftover transforms are cleared so native scrolling works
    const content = el.firstElementChild as HTMLElement | null;
    if (content) {
      content.style.transform = "";
      content.style.willChange = "auto";
    }
  }, []);

  return containerRef;
}

