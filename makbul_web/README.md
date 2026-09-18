# Makbul Mağazası Web Kataloğu

Veritabanı gerektirmeyen, statik olarak yayınlanabilen ürün kataloğu. Mevcut Flutter uygulamasındaki ürünler `src/data/products.json` dosyasına aktarılmıştır.

## Çalıştırma

```bash
npm install
npm run dev
```

Tarayıcıdan `http://localhost:3000` adresini açın.

## Üretim çıktısı

```bash
npm run build
```

Yayınlanmaya hazır statik dosyalar `out` klasöründe oluşturulur. Bu klasör herhangi bir statik barındırma hizmetine yüklenebilir.

## Ürünleri güncelleme

Ürünleri doğrudan `src/data/products.json` içinde düzenleyebilirsiniz. Flutter tarafındaki ana liste değişirse veriyi yeniden aktarmak için:

```bash
npm run migrate:data
```

Ardından siteyi yeniden derleyip yayınlamak gerekir.
