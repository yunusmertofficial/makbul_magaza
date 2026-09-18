"use client";

import Image from "next/image";
import { useEffect, useState } from "react";

type InstallChoice = {
  outcome: "accepted" | "dismissed";
  platform: string;
};

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>;
  userChoice: Promise<InstallChoice>;
}

declare global {
  interface Window {
    __makbulInstallPrompt?: BeforeInstallPromptEvent | null;
  }
}

export default function InstallPrompt() {
  const [visible, setVisible] = useState(false);
  const [deferredPrompt, setDeferredPrompt] =
    useState<BeforeInstallPromptEvent | null>(null);

  useEffect(() => {
    const standalone = window.matchMedia("(display-mode: standalone)").matches;
    if (standalone) return;

    const showInstall = () => {
      const prompt = window.__makbulInstallPrompt;
      if (!prompt) return;
      setDeferredPrompt(prompt);
      setVisible(true);
    };
    const hideAfterInstall = () => setVisible(false);
    const frame = window.requestAnimationFrame(showInstall);

    window.addEventListener("makbul-install-ready", showInstall);
    window.addEventListener("appinstalled", hideAfterInstall);

    return () => {
      window.cancelAnimationFrame(frame);
      window.removeEventListener("makbul-install-ready", showInstall);
      window.removeEventListener("appinstalled", hideAfterInstall);
    };
  }, []);

  const install = async () => {
    if (!deferredPrompt) return;

    await deferredPrompt.prompt();
    await deferredPrompt.userChoice;
    window.__makbulInstallPrompt = null;
    setDeferredPrompt(null);
    setVisible(false);
  };

  if (!visible || !deferredPrompt) return null;

  return (
    <div className="install-overlay" role="dialog" aria-modal="true" aria-labelledby="install-title">
      <div className="install-sheet">
        <button className="install-close" type="button" onClick={() => setVisible(false)} aria-label="Pencereyi kapat">
          ×
        </button>
        <div className="install-logo">
          <Image src="/logo-192.png" alt="" width={70} height={70} priority />
        </div>
        <div className="install-copy">
          <span className="install-kicker">Uygulama hazır</span>
          <h2 id="install-title">Makbul Mağazası&apos;nı yükle</h2>
          <p>Butona dokunduğunda tarayıcının güvenli yükleme penceresi açılacak.</p>
        </div>

        <div className="install-actions install-actions-ready">
          <button className="install-later" type="button" onClick={() => setVisible(false)}>Şimdi değil</button>
          <button className="install-primary" type="button" onClick={install}>
            <span aria-hidden="true">↓</span> Yükle
          </button>
        </div>
      </div>
    </div>
  );
}
