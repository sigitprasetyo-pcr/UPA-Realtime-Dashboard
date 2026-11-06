export interface LateBook {
  id: string;
  memberName: string;
  nim: string;
  photo?: string;
  title: string;
  daysLate: number;
  fine: number;
  faculty: string;
}

export interface PopularCollection {
  id: string;
  title: string;
  author: string;
  borrowCount: number;
  class: string;
}

export interface AcademicWorkDetail {
  id: string;
  title: string;
  author: string;
  nim: string;
  type: "ta_d3" | "skripsi_s1" | "tesis_s2" | "disertasi_s3";
  submissionDate: string;
  faculty: string;
}

export interface MembershipByFaculty {
  faculty: string;
  count: number;
}

export interface MembershipByDemographic {
  category: string;
  count: number;
}

export interface AdminTransaction {
  type: "peminjaman" | "pengembalian" | "validasi" | "bebas_pustaka" | "pendaftaran" | "pembayaran_denda";
  count: number;
}

export interface LibraryStats {
  // Kunjungan (Visitors)
  visit_main_door: number;
  visit_circulation_room: number;
  visit_thesis_room: number;
  visit_multimedia_room: number;
  visit_reference_room: number;
  total_visitors_today: number;

  // Transaksi (Transactions)
  borrowing_today: number;
  returning_today: number;
  validation_today: number;
  free_pass_today: number;
  registration_today: number;
  fine_payment_today: number;
  administration_today: number;
  total_transactions_today: number;

  // Koleksi (Collection)
  total_book_titles: number;
  total_copies: number;
  available_circulation: number;
  availability_percent: number;
  total_internal_resources: number;
  popular_collections: PopularCollection[];

  // Total Transaksi Keseluruhan
  total_borrowing_all: number;
  total_returning_all: number;
  total_extension_all: number;
  books_currently_borrowed: number;
  members_currently_borrowing: number;
  overdue_books: number;
  late_books: LateBook[];

  // Keanggotaan (Membership)
  member_visitors: number;
  reading_card_visitors: number;
  general_visitors: number;
  membership_by_faculty: MembershipByFaculty[];
  membership_by_gender: MembershipByDemographic[];
  membership_by_program: MembershipByDemographic[];
  membership_by_age: MembershipByDemographic[];

  // Tugas Akhir (Academic Works)
  ta_d3: number;
  skripsi_s1: number;
  tesis_s2: number;
  disertasi_s3: number;
  academic_works: AcademicWorkDetail[];

  // Admin Breakdown
  admin_transactions: AdminTransaction[];

  // Hourly Data
  hourly_visitors: number[];
  hourly_borrowing: number[];
  hourly_returning: number[];
  hourly_administration: number[];

  // Collection by Class
  collection_by_class: Record<string, number>;

  last_updated: string;
  system_status: "online" | "offline";
}

export type HourlyLabel = "08:00" | "09:00" | "10:00" | "11:00" | "12:00" | "13:00" | "14:00" | "15:00" | "16:00";

export const HOURLY_LABELS: HourlyLabel[] = [
  "08:00",
  "09:00",
  "10:00",
  "11:00",
  "12:00",
  "13:00",
  "14:00",
  "15:00",
  "16:00",
];
