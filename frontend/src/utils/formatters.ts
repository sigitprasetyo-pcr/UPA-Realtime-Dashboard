export function formatNumber(n: number): string {
  if (!Number.isFinite(n)) return "0";
  return n.toLocaleString("id-ID");
}

export function formatNumberDecimal(n: number, digits = 1): string {
  if (!Number.isFinite(n)) return "0";
  return n.toLocaleString("id-ID", {
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  });
}

export function maskNimWithFaculty(nim: string, faculty: string): string {
  if (!nim || nim.length <= 4) return `${faculty} - ****`;
  const visiblePart = nim.slice(0, -4);
  return `${faculty} - ${visiblePart}****`;
}
