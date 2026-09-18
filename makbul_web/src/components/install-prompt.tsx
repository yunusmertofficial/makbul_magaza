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

export default function InstallPrompt() {
  const [visible, setVisible] = useState(true);
  const [isIOS, setIsIOS] = useState(false);
  const [deferredPrompt, setDeferredPrompt] =
    useState<BeforeInstallPromptEvent | null>(null);
  const [showHelp, setShowHelp] = useState(false);

  useEffect(() => {
    const standalone =
      window.matchMedia("(display-mode: standalone)").matches ||
      ("standalone" in navigator && Boolean((navigator as Navigator & { standalone?: boolean }).standalone));
    const ios = /iPad|iPhone|iPod/.test(navigator.userAgent);

    const frame = window.requestAnimationFrame(() => {
      setIsIOS(ios);
      setVisible(!standalone);
    });

    const capturePrompt = (event: Event) => {
      event.preventDefault();
      setDeferredPrompt(event as BeforeInstallPromptEvent);
    };
    const hideAfterInstall = () => setVisible(false);

    window.addEventListener("beforeinstallprompt", capturePrompt);
    window.addEventListener("appinstalled", hideAfterInstall);

    return () => {
      window.cancelAnimationFrame(frame);
      window.removeEventListener("beforeinstallprompt", capturePrompt);
      window.removeEventListener("appinstalled", hideAfterInstall);
    };
  }, []);

  const install = async () => {
    if (!deferredPrompt) {
      setShowHelp(true);
      return;
    }

    await deferredPrompt.prompt();
    const choice = await deferredPrompt.userChoice;
    setDeferredPrompt(null);
    if (choice.outcome === "accepted") setVisible(false);
  };

  if (!visible) return null;

  return (
    <div className="install-overlay" role="dialog" aria-modal="true" aria-labelledby="install-title">
      <div className="install-sheet">
        <button className="install-close" type="button" onClick={() => setVisible(false)} aria-label="Pencereyi kapat">
          ×
        </button>
        <div className="install-logo">
          <Image src="/logo.png" alt="" width={70} height={70} priority />
        </div>
        <div className="install-copy">
          <span className="install-kicker">Hızlı erişim</span>
          <h2 id="install-title">Makbul&apos;ü ana ekranına ekle</h2>
          <p>Ürün aramaya uygulama gibi, tek dokunuşla ulaş.</p>
        </div>

        {showHelp && (
          <div className="install-help">
            {isIOS ? (
              <p>Safari&apos;de alttaki <strong>Paylaş</strong> simgesine dokun, ardından <strong>Ana Ekrana Ekle</strong> seçeneğini seç.</p>
            ) : (
              <p>Tarayıcı menüsünü açıp <strong>Ana ekrana ekle</strong> veya <strong>Uygulamayı yükle</strong> seçeneğine dokun.</p>
            )}
          </div>
        )}

        <div className="install-actions">
          <button className="install-later" type="button" onClick={() => setVisible(false)}>Şimdi değil</button>
          <button className="install-primary" type="button" onClick={install}>
            <span aria-hidden="true">＋</span> Ana ekrana ekle
          </button>
        </div>
      </div>
    </div>
  );
}
