import { create } from "zustand";
import { persist } from "zustand/middleware";
import { supabase } from "../lib/supabase";
import type { User } from "@supabase/supabase-js";

interface AdminStore {
  isAuthenticated: boolean;
  user: User | null;
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
        try {
          const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password,
          });

          if (error) {
            set({ isLoading: false, error: error.message, isAuthenticated: false, user: null });
            return false;
          }

          set({ isAuthenticated: true, user: data.user, isLoading: false, error: null });
          return true;
        } catch (err: any) {
          set({ isLoading: false, error: "Gagal terhubung ke server", isAuthenticated: false });
          return false;
        }
      },

      logout: async () => {
        await supabase.auth.signOut();
        set({ isAuthenticated: false, user: null, error: null });
      },

      checkSession: async () => {
        const { data } = await supabase.auth.getSession();
        if (data.session?.user) {
          set({ isAuthenticated: true, user: data.session.user });
        } else {
          set({ isAuthenticated: false, user: null });
        }
      },
    }),
    {
      name: "admin-auth-storage",
      partialize: (state) => ({ isAuthenticated: state.isAuthenticated }),
    }
  )
);
