// Supabase Mock Client (Nonaktif - Murni SLiMS & XAMPP Local)
export const supabase = {
  auth: {
    signInWithPassword: async () => ({ data: { user: null, session: null }, error: null }),
    signOut: async () => {},
    getSession: async () => ({ data: { session: null }, error: null }),
  },
  from: () => ({
    select: () => ({
      eq: () => ({
        single: async () => ({ data: null, error: null }),
      }),
    }),
    upsert: () => ({
      select: async () => ({ data: null, error: null }),
    }),
  }),
};
