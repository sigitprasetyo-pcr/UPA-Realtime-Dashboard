import { useEffect, useRef } from "react";
import { useLibraryStore } from "../store/useLibraryStore";
import { AlertTriangle } from "lucide-react";

export function EmergencyAlert() {
  const emergencyAlert = useLibraryStore((s) => s.settings.emergencyAlert);
  const audioCtxRef = useRef<AudioContext | null>(null);

  useEffect(() => {
    if (!emergencyAlert) {
      if (audioCtxRef.current) {
        audioCtxRef.current.close();
        audioCtxRef.current = null;
      }
      return;
    }

    // Play siren sound using Web Audio API (Synthesized Siren)
    const AudioContext = window.AudioContext || (window as any).webkitAudioContext;
    if (!AudioContext) return;

    const ctx = new AudioContext();
    audioCtxRef.current = ctx;

    const playSiren = () => {
      if (ctx.state === 'closed') return;
      
      const osc = ctx.createOscillator();
      const gainNode = ctx.createGain();

      osc.connect(gainNode);
      gainNode.connect(ctx.destination);

      osc.type = "square";
      const now = ctx.currentTime;

      // Siren frequency sweep (wailing sound)
      osc.frequency.setValueAtTime(600, now);
      osc.frequency.linearRampToValueAtTime(1200, now + 0.5);
      osc.frequency.linearRampToValueAtTime(600, now + 1.0);

      // Volume control
      gainNode.gain.setValueAtTime(0, now);
      gainNode.gain.linearRampToValueAtTime(0.1, now + 0.1);
      gainNode.gain.linearRampToValueAtTime(0.1, now + 0.9);
      gainNode.gain.linearRampToValueAtTime(0, now + 1.0);

      osc.start(now);
      osc.stop(now + 1.0);

      // Repeat the siren loop
      setTimeout(() => {
        if (ctx.state !== 'closed') {
          playSiren();
        }
      }, 1000);
    };

    playSiren();

    return () => {
      if (ctx.state !== 'closed') {
        ctx.close();
      }
    };
  }, [emergencyAlert]);

  if (!emergencyAlert) return null;

  return (
    <div className="fixed top-0 left-0 w-full z-[100] animate-fade-scale">
      <div className="text-white px-6 py-4 flex items-center justify-center gap-4 shadow-2xl border-b-4 animate-emergency-flash">
        <AlertTriangle className="w-8 h-8 animate-ping text-yellow-300" />
        <h2 className="text-xl md:text-2xl font-extrabold tracking-wide uppercase">
          {emergencyAlert}
        </h2>
        <AlertTriangle className="w-8 h-8 animate-ping text-yellow-300" />
      </div>
    </div>
  );
}
