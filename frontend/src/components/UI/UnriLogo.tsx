import LogoUnri from "../../assets/LogoUnri - Slash.jpg";

interface UnriLogoProps {
  size?: "sm" | "md" | "lg";
}

export function UnriLogo({ size = "md" }: UnriLogoProps) {
  const sizes = {
    sm: "h-12 w-12",
    md: "h-14 w-14",
    lg: "h-16 w-16",
  };
  return (
    <img
      src={LogoUnri}
      alt="Logo Universitas Riau"
      className={`${sizes[size]} shrink-0 drop-shadow-md object-contain`}
    />
  );
}
