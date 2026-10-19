import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { useAdminStore } from "../store/useAdminStore";
import { Mail, Lock, ArrowLeft, AlertCircle, Eye, EyeOff, Loader2 } from "lucide-react";
import LogoUnri from "../assets/LogoUnri - Slash.jpg";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const { login, isLoading, error } = useAdminStore();
  const navigate = useNavigate();

  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    const success = await login(email, password);
    if (success) {
      navigate("/admin", { state: { loginSuccess: true } });
    }
  };

  const handleSSO = () => {
    setToastMessage("Login SSO UNRI saat ini belum tersedia di lingkungan lokal.");
    setTimeout(() => setToastMessage(null), 3000);
  };

  return (
    <div className="min-h-screen bg-[#f4f6f8] flex items-center justify-center p-4 sm:p-8 font-sans">
      {toastMessage && (
        <div className="fixed top-5 z-50 bg-white border border-gray-200 shadow-xl px-6 py-4 rounded-xl flex items-center gap-3 animate-fade-in-up">
          <AlertCircle className="w-5 h-5 text-amber-500" />
          <p className="text-gray-700 font-medium text-sm">{toastMessage}</p>
        </div>
      )}
      <div className="flex flex-col md:flex-row bg-white rounded-[2rem] shadow-2xl overflow-hidden max-w-5xl w-full min-h-[600px]">
        
        {/* Left Panel - Dark Background */}
        <div className="w-full md:w-5/12 bg-unri-green-900 text-white p-10 md:p-12 flex flex-col justify-between relative overflow-hidden hidden md:flex">
          {/* Decorative Circles */}
          <div className="absolute top-[-20%] left-[-20%] w-[80%] h-[80%] rounded-full bg-white/5 blur-3xl pointer-events-none"></div>
          <div className="absolute top-[20%] right-[-30%] w-[80%] h-[80%] rounded-full bg-yellow-400/10 blur-3xl pointer-events-none"></div>
          
          <div className="relative z-10">
            <div className="flex items-center gap-3 mb-6">
              <img src={LogoUnri} alt="UNRI" className="w-10 h-10 object-contain bg-white rounded-full p-1 shadow-md" />
              <span className="font-bold text-xl tracking-wide">Perpustakaan</span>
            </div>
            <h1 className="text-4xl lg:text-5xl font-extrabold leading-tight mb-4 text-white">
              Dashboard<br/><span className="text-yellow-400">Realtime.</span>
            </h1>
            <p className="text-unri-green-100/80 text-base leading-relaxed">
              Akses panel admin untuk mengelola tampilan, fitur, dan memantau statistik kunjungan layanan perpustakaan secara langsung.
            </p>
          </div>

          {/* Illustration/Graphic */}
          <div className="relative z-10 flex-1 flex items-center justify-center mt-8 mb-8">
            <div className="relative w-full max-w-[320px]">
              <div className="absolute inset-0 bg-yellow-400 rounded-full opacity-20 blur-2xl"></div>
              <img 
                src="/login-image.png" 
                alt="Library Area" 
                className="relative z-10 w-full h-auto rounded-2xl shadow-2xl border-4 border-white/20 transform rotate-[-3deg] hover:rotate-0 transition-transform duration-500 object-cover"
              />
            </div>
          </div>

          <div className="relative z-10">
            <p className="text-xs text-unri-green-200/50">
              &copy; {new Date().getFullYear()} UPA Perpustakaan Universitas Riau
            </p>
          </div>
        </div>

        {/* Right Panel - Login Form */}
        <div className="w-full md:w-7/12 p-8 sm:p-12 lg:p-16 flex flex-col bg-white relative">
          
          <Link to="/" className="absolute top-8 right-8 flex items-center gap-2 text-gray-400 hover:text-gray-600 transition-colors font-medium text-sm">
            Kembali <ArrowLeft className="w-4 h-4" />
          </Link>

          <div className="max-w-sm w-full mx-auto flex-1 flex flex-col justify-center">
            
            <div className="mb-8">
              <h2 className="text-3xl font-bold text-gray-900 mb-2">Log in ke Admin.</h2>
              <p className="text-gray-500 text-sm">
                Selamat datang kembali! Silakan masuk dengan data kredensial Anda.
              </p>
            </div>

            {/* SSO Button (Match reference layout) */}
            <button 
              type="button"
              onClick={handleSSO}
              className="w-full flex items-center justify-center gap-3 bg-white border border-gray-200 hover:bg-gray-50 text-gray-700 font-semibold py-2.5 px-4 rounded-xl shadow-sm transition-colors mb-6"
            >
              <img src={LogoUnri} alt="UNRI" className="w-6 h-6 object-contain rounded-full shadow-sm" />
              <span>Login dengan SSO UNRI</span>
            </button>

            <div className="flex items-center gap-4 mb-6">
              <div className="flex-1 h-px bg-gray-200"></div>
              <span className="text-xs text-gray-400 font-medium uppercase tracking-wider">atau</span>
              <div className="flex-1 h-px bg-gray-200"></div>
            </div>

            {error && (
              <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl flex items-center gap-3 mb-6 animate-bounce-in">
                <AlertCircle className="w-5 h-5 shrink-0" />
                <span className="text-sm font-medium">{error}</span>
              </div>
            )}

            <form onSubmit={handleLogin} className="space-y-5">
              <div>
                <label className="block text-gray-700 text-xs font-bold mb-2 ml-1">
                  Email
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-gray-400">
                    <Mail className="w-5 h-5" />
                  </div>
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="bg-gray-50 border border-gray-100 text-gray-900 rounded-xl w-full pl-12 pr-4 py-3.5 focus:outline-none focus:ring-2 focus:ring-unri-green-500 focus:bg-white transition-all font-medium"
                    placeholder="admin@upa.unri.ac.id"
                    required
                  />
                </div>
              </div>
              
              <div>
                <label className="block text-gray-700 text-xs font-bold mb-2 ml-1">
                  Password
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-gray-400">
                    <Lock className="w-5 h-5" />
                  </div>
                  <input
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="bg-gray-50 border border-gray-100 text-gray-900 rounded-xl w-full pl-12 pr-12 py-3.5 focus:outline-none focus:ring-2 focus:ring-unri-green-500 focus:bg-white transition-all font-medium"
                    placeholder="••••••••"
                    required
                  />
                  <button 
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600"
                  >
                    {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                  </button>
                </div>
              </div>

              <div className="flex items-center justify-between mt-4">
                <label className="flex items-center gap-2 cursor-pointer">
                  <input type="checkbox" className="w-4 h-4 text-unri-green-600 border-gray-300 rounded focus:ring-unri-green-500" />
                  <span className="text-sm text-gray-600 font-medium">Remember me</span>
                </label>
                <button type="button" className="text-sm font-semibold text-unri-green-600 hover:text-unri-green-700">
                  Lupa password?
                </button>
              </div>

              <button
                type="submit"
                disabled={isLoading}
                className="w-full bg-[#fa7855] hover:bg-[#e86744] disabled:opacity-60 disabled:cursor-not-allowed text-white font-bold py-3.5 px-4 rounded-xl shadow-[0_8px_20px_rgba(250,120,85,0.3)] transform transition-all active:translate-y-1 mt-6 text-[15px] tracking-wide flex items-center justify-center gap-2"
              >
                {isLoading ? (
                  <><Loader2 className="w-5 h-5 animate-spin" /> Memverifikasi...</>
                ) : (
                  'LOGIN'
                )}
              </button>
            </form>
            
            <div className="mt-8 text-center">
              <p className="text-sm text-gray-500 font-medium">
                Belum punya akun admin? <button type="button" className="text-unri-green-600 font-bold hover:underline">Hubungi IT</button>
              </p>
            </div>
            
          </div>
        </div>
      </div>
    </div>
  );
}
