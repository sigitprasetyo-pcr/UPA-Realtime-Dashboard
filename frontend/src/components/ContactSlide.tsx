import { Phone, Mail, MapPin, Globe, QrCode } from "lucide-react";

export function ContactSlide() {
  return (
    <div className="w-full h-full flex items-center justify-center p-3 sm:p-6 md:p-8 bg-gradient-to-br from-white to-green-50/50 overflow-y-auto md:overflow-hidden">
      <div className="bg-white rounded-2xl md:rounded-3xl shadow-xl w-full max-w-5xl flex flex-col md:flex-row overflow-hidden border border-green-100 my-auto">
        
        {/* Left Side: Info */}
        <div className="flex-1 p-5 sm:p-8 md:p-12 flex flex-col justify-center bg-green-800 text-white relative overflow-hidden">
          {/* Decorative Background */}
          <div className="absolute top-[-20%] right-[-10%] w-96 h-96 bg-green-700/50 rounded-full blur-3xl" />
          <div className="absolute bottom-[-20%] left-[-10%] w-80 h-80 bg-green-600/30 rounded-full blur-3xl" />

          <div className="relative z-10">
            <h2 className="text-2xl sm:text-3xl md:text-4xl font-black mb-1 md:mb-2 tracking-tight">Hubungi Kami</h2>
            <p className="text-green-100 mb-6 md:mb-10 text-sm sm:text-base md:text-lg">Unit Penunjang Akademik (UPA) Perpustakaan</p>

            <div className="space-y-4 md:space-y-6">
              <div className="flex items-center gap-3 md:gap-4">
                <div className="w-10 h-10 md:w-12 md:h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <MapPin className="h-5 w-5 md:h-6 md:w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-sm md:text-lg">Alamat</p>
                  <p className="text-green-100 text-xs md:text-base">Kampus Bina Widya KM. 12,5 Simpang Baru, Pekanbaru, Riau</p>
                </div>
              </div>

              <div className="flex items-center gap-3 md:gap-4">
                <div className="w-10 h-10 md:w-12 md:h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Phone className="h-5 w-5 md:h-6 md:w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-sm md:text-lg">Telepon / WhatsApp</p>
                  <p className="text-green-100 text-xs md:text-base">+62 812-3456-7890</p>
                </div>
              </div>

              <div className="flex items-center gap-3 md:gap-4">
                <div className="w-10 h-10 md:w-12 md:h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Mail className="h-5 w-5 md:h-6 md:w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-sm md:text-lg">Email</p>
                  <p className="text-green-100 text-xs md:text-base">perpustakaan@unri.ac.id</p>
                </div>
              </div>

              <div className="flex items-center gap-3 md:gap-4">
                <div className="w-10 h-10 md:w-12 md:h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Globe className="h-5 w-5 md:h-6 md:w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-sm md:text-lg">Website</p>
                  <p className="text-green-100 text-xs md:text-base">lib.unri.ac.id</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side: QR Code */}
        <div className="w-full md:w-2/5 p-6 sm:p-8 md:p-12 flex flex-col items-center justify-center bg-white relative">
          <div className="text-center mb-5 md:mb-8">
            <h3 className="text-xl md:text-2xl font-black text-gray-800 mb-1 md:mb-2">Pindai untuk Info</h3>
            <p className="text-gray-500 text-xs md:text-sm">Akses layanan perpustakaan dengan cepat melalui smartphone Anda.</p>
          </div>
          
          <div className="relative p-4 sm:p-6 bg-white rounded-2xl md:rounded-3xl shadow-lg border border-gray-100">
            {/* Corner Markers */}
            <div className="absolute top-0 left-0 w-6 h-6 md:w-8 md:h-8 border-t-4 border-l-4 border-green-600 rounded-tl-xl" />
            <div className="absolute top-0 right-0 w-6 h-6 md:w-8 md:h-8 border-t-4 border-r-4 border-green-600 rounded-tr-xl" />
            <div className="absolute bottom-0 left-0 w-6 h-6 md:w-8 md:h-8 border-b-4 border-l-4 border-green-600 rounded-bl-xl" />
            <div className="absolute bottom-0 right-0 w-6 h-6 md:w-8 md:h-8 border-b-4 border-r-4 border-green-600 rounded-br-xl" />
            
            {/* QR Code Placeholder */}
            <div className="w-36 h-36 sm:w-44 sm:h-44 md:w-48 md:h-48 bg-gray-50 rounded-xl flex items-center justify-center border-2 border-dashed border-gray-200">
              <QrCode className="w-24 h-24 sm:w-28 sm:h-28 md:w-32 md:h-32 text-gray-400" />
            </div>
          </div>
          
          <p className="mt-5 md:mt-8 font-bold text-green-700 tracking-widest uppercase text-xs md:text-sm">
            #LiterasiUntukNegeri
          </p>
        </div>

      </div>
    </div>
  );
}
