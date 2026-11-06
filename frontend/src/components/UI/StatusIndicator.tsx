interface StatusIndicatorProps {
  online?: boolean;
  size?: "sm" | "md" | "lg";
}

export function StatusIndicator({ online = true, size = "md" }: StatusIndicatorProps) {
  const dotSize = {
    sm: "h-2 w-2",
    md: "h-3 w-3",
    lg: "h-4 w-4",
  }[size];

  return (
    <span className="relative inline-flex shrink-0">
      <span
        className={`absolute inline-flex ${dotSize} rounded-full opacity-60 ${
          online ? "bg-unri-green-500" : "bg-yellow-500"
        }`}
        style={{
          animation: "ping 2s cubic-bezier(0, 0, 0.2, 1) infinite",
        }}
      />
      <span
        className={`relative inline-flex ${dotSize} rounded-full ${
          online ? "bg-unri-green-500" : "bg-yellow-500"
        }`}
      />
    </span>
  );
}
