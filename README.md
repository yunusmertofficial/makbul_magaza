# Makbul Mağaza

Makbul ürünlerini kod veya isimle bulmak için hazırlanmış mobil uygulama ve statik web kataloğu.

## Projeler

- `lib/`: Flutter uygulaması
- `makbul_web/`: Next.js tabanlı, veritabanı gerektirmeyen web kataloğu

## Web kataloğunu çalıştırma

```bash
cd makbul_web
npm install
npm run dev
```

Tarayıcıdan `http://localhost:3000` adresini açın.

Statik üretim çıktısı almak için:

```bash
npm run build
```

## Flutter uygulamasını çalıştırma

```bash
flutter pub get
flutter run
```
