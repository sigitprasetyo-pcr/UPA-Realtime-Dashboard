import { useCountAnimation } from "../../hooks/useCountAnimation";
import { formatNumber, formatNumberDecimal } from "../../utils/formatters";

interface AnimatedNumberProps {
  value: number;
  className?: string;
  style?: React.CSSProperties;
  decimals?: number;
  durationMs?: number;
  showDelta?: boolean;
  deltaColorClass?: string;
}

export function AnimatedNumber({
  value,
  className = "",
  style,
  decimals = 0,
  durationMs = 700,
  showDelta = false,
  deltaColorClass = "text-unri-green-600",
}: AnimatedNumberProps) {
  const { value: displayValue, delta } = useCountAnimation(value, durationMs, decimals);

  return (
    <span className="inline-flex items-baseline gap-1">
      <span className={className} style={style}>
        {decimals > 0 ? formatNumberDecimal(displayValue, decimals) : formatNumber(displayValue)}
      </span>
      {showDelta && delta > 0 && (
        <span
          className={`text-xs font-bold animate-count-up align-top ${deltaColorClass}`}
          style={{ animationDuration: "1.2s", animationFillMode: "forwards" }}
        >
          +{decimals > 0 ? formatNumberDecimal(delta, decimals) : formatNumber(Math.round(delta))}
        </span>
      )}
    </span>
  );
}
