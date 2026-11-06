import { create } from "zustand";
import { persist } from "zustand/middleware";

interface AdminUser {
  id: string;
  email: string;
}

interface AdminStore {
  isAuthenticated: boolean;
  user: AdminUser | null;
  isLoading: boolean;
  error: string | null;
  login: (email: string, password: string) => Promise<boolean>;
  logout: () => Promise<void>;
  checkSession: () => Promise<void>;
}

export const useAdminStore = create<AdminStore>()(
  persist(
    (set) => ({
      isAuthenticated: false,
      user: null,
      isLoading: false,
      error: null,

      login: async (email: string, password: string) => {
        set({ isLoading: true, error: null });
        const normalizedEmail = (email || '').trim().toLowerCase();
        const normalizedPass = (password || '').trim();

        // 1. Coba verifikasi ke API Backend XAMPP (tabel `users`)
        const slimsApi = import.meta.env.VITE_SLIMS_API_URL || 'http://localhost/upa-api/index.php';
        try {
          const res = await fetch(`${slimsApi}?endpoint=login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: normalizedEmail, password: normalizedPass }),
            signal: AbortSignal.timeout(5000),
          });

          if (res.ok) {
            const data = await res.json();
            if (data.status === 'success' && data.user) {
              set({
                isAuthenticated: true,
                user: { id: String(data.user.id), email: data.user.email },
                isLoading: false,
                error: null,
              });
              return true;
            } else {
              set({ isLoading: false, error: data.message || "Email atau password salah", isAuthenticated: false });
              return false;
            }
          }
        } catch (apiErr) {
          console.warn("[AdminStore] Login API request error, fallback to default verification:", apiErr);
        }

        // 2. Fallback darurat (jika Apache XAMPP belum aktif)
        const isDefaultAdmin =
          (normalizedEmail === 'admin' || normalizedEmail === 'admin@upa.unri.ac.id') &&
          (normalizedPass === 'admin' || normalizedPass === 'admin123' || normalizedPass === 'password');

        if (isDefaultAdmin) {
          const adminUser: AdminUser = {
            id: 'local-admin-1',
            email: normalizedEmail.includes('@') ? normalizedEmail : `${normalizedEmail}@upa.unri.ac.id`,
          };
          set({ isAuthenticated: true, user: adminUser, isLoading: false, error: null });
          return true;
        }

        set({ isLoading: false, error: "Username atau password salah", isAuthenticated: false, user: null });
        return false;
      },

      logout: async () => {
        set({ isAuthenticated: false, user: null, error: null });
      },

      checkSession: async () => {
        // Session persisted via zustand persist middleware
      },
    }),
    {
      name: "admin-auth-storage",
      partialize: (state) => ({ isAuthenticated: state.isAuthenticated, user: state.user }),
    }
  )
);
