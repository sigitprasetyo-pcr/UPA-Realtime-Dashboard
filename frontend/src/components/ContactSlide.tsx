import { Phone, Mail, MapPin, Globe, QrCode } from "lucide-react";

export function ContactSlide() {
  return (
    <div className="w-full h-full flex items-center justify-center p-8 bg-gradient-to-br from-white to-green-50/50">
      <div className="bg-white rounded-3xl shadow-xl w-full max-w-5xl h-full max-h-[80vh] flex overflow-hidden border border-green-100">
        
        {/* Left Side: Info */}
        <div className="flex-1 p-12 flex flex-col justify-center bg-green-800 text-white relative overflow-hidden">
          {/* Decorative Background */}
          <div className="absolute top-[-20%] right-[-10%] w-96 h-96 bg-green-700/50 rounded-full blur-3xl" />
          <div className="absolute bottom-[-20%] left-[-10%] w-80 h-80 bg-green-600/30 rounded-full blur-3xl" />

          <div className="relative z-10">
            <h2 className="text-4xl font-black mb-2 tracking-tight">Hubungi Kami</h2>
            <p className="text-green-100 mb-10 text-lg">Unit Penunjang Akademik (UPA) Perpustakaan</p>

            <div className="space-y-6">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <MapPin className="h-6 w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-lg">Alamat</p>
                  <p className="text-green-100">Kampus Bina Widya KM. 12,5 Simpang Baru, Pekanbaru, Riau</p>
                </div>
              </div>

              <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Phone className="h-6 w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-lg">Telepon / WhatsApp</p>
                  <p className="text-green-100">+62 812-3456-7890</p>
                </div>
              </div>

              <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Mail className="h-6 w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-lg">Email</p>
                  <p className="text-green-100">perpustakaan@unri.ac.id</p>
                </div>
              </div>

              <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-white/10 rounded-xl flex items-center justify-center shrink-0">
                  <Globe className="h-6 w-6 text-green-200" />
                </div>
                <div>
                  <p className="font-bold text-lg">Website</p>
                  <p className="text-green-100">lib.unri.ac.id</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Side: QR Code */}
        <div className="w-2/5 p-12 flex flex-col items-center justify-center bg-white relative">
          <div className="text-center mb-8">
            <h3 className="text-2xl font-black text-gray-800 mb-2">Pindai untuk Info</h3>
            <p className="text-gray-500 text-sm">Akses layanan perpustakaan dengan cepat melalui smartphone Anda.</p>
          </div>
          
          <div className="relative p-6 bg-white rounded-3xl shadow-lg border border-gray-100">
            {/* Corner Markers */}
            <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-green-600 rounded-tl-xl" />
            <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-green-600 rounded-tr-xl" />
            <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-green-600 rounded-bl-xl" />
            <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-green-600 rounded-br-xl" />
            
            {/* QR Code Placeholder (Using an icon for now, ideally an image) */}
            <div className="w-48 h-48 bg-gray-50 rounded-xl flex items-center justify-center border-2 border-dashed border-gray-200">
              <QrCode className="w-32 h-32 text-gray-400" />
            </div>
          </div>
          
          <p className="mt-8 font-bold text-green-700 tracking-widest uppercase text-sm">
            #LiterasiUntukNegeri
          </p>
        </div>

      </div>
    </div>
  );
}
