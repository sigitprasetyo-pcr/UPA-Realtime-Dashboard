import { useEffect } from "react";
import { BrowserRouter as Router, Routes, Route, useLocation } from "react-router-dom";
import Home from "@/pages/Home";
import CollectionPage from "@/pages/CollectionPage";
import MembershipPage from "@/pages/MembershipPage";
import AcademicWorksPage from "@/pages/AcademicWorksPage";
import Login from "@/pages/Login";
import AdminConfig from "@/pages/AdminConfig";

import { PopupNotification } from "@/components/PopupNotification";
import { EmergencyAlert } from "@/components/EmergencyAlert";
import { useAdminStore } from "@/store/useAdminStore";

function GlobalOverlays() {
  const location = useLocation();
  const isHidden = location.pathname.startsWith('/admin') || location.pathname.startsWith('/login');
  
  if (isHidden) return null;

  return (
    <>
      <EmergencyAlert />
      <PopupNotification />
    </>
  );
}

export default function App() {
  const checkSession = useAdminStore((s) => s.checkSession);

  useEffect(() => {
    checkSession();
  }, [checkSession]);

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/collection" element={<CollectionPage />} />
        <Route path="/membership" element={<MembershipPage />} />
        <Route path="/academic-works" element={<AcademicWorksPage />} />
        <Route path="/login" element={<Login />} />
        <Route path="/admin" element={<AdminConfig />} />
      </Routes>
      <GlobalOverlays />
    </Router>
  );
}
