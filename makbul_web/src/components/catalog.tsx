"use client";

import Image from "next/image";
import { useMemo, useState } from "react";
import InstallPrompt from "@/components/install-prompt";

type Product = {
  id: string;
  code: string;
  name: string;
  category: string;
  imageUrl: string;
};

type CatalogProps = {
  products: Product[];
};

const PAGE_SIZE = 24;

function normalizeSearch(value: string) {
  return value
    .toLocaleLowerCase("tr-TR")
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .replaceAll("ı", "i")
    .trim();
}

function SearchIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="m21 21-4.35-4.35m2.35-5.15a7.5 7.5 0 1 1-15 0 7.5 7.5 0 0 1 15 0Z" />
    </svg>
  );
}

function PackageIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path d="m12 3 8 4.5v9L12 21l-8-4.5v-9L12 3Z" />
      <path d="m4.3 7.7 7.7 4.4M12 12v9" />
    </svg>
  );
}

export default function Catalog({ products }: CatalogProps) {
  const [query, setQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("Tümü");
  const [visibleCount, setVisibleCount] = useState(PAGE_SIZE);
  const [failedImages, setFailedImages] = useState<Set<string>>(new Set());
  const [searchFocused, setSearchFocused] = useState(false);

  const categories = useMemo(() => {
    const counts = new Map<string, number>();
    for (const product of products) {
      counts.set(product.category, (counts.get(product.category) ?? 0) + 1);
    }
    return [...counts.entries()];
  }, [products]);

  const filteredProducts = useMemo(() => {
    const normalizedQuery = normalizeSearch(query);

    return products.filter((product) => {
      const matchesCategory =
        selectedCategory === "Tümü" || product.category === selectedCategory;
      const searchable = normalizeSearch(`${product.name} ${product.code}`);
      return matchesCategory && searchable.includes(normalizedQuery);
    });
  }, [products, query, selectedCategory]);

  const visibleProducts = filteredProducts.slice(0, visibleCount);
  const searchSuggestions = useMemo(() => {
    const normalizedQuery = normalizeSearch(query);
    if (!normalizedQuery) return [];

    return products
      .filter((product) =>
        normalizeSearch(`${product.name} ${product.code}`).includes(normalizedQuery),
      )
      .slice(0, 6);
  }, [products, query]);

  const updateCategory = (category: string) => {
    setSelectedCategory(category);
    setVisibleCount(PAGE_SIZE);
  };

  const updateQuery = (value: string) => {
    setQuery(value);
    setVisibleCount(PAGE_SIZE);
  };

  const registerImageError = (id: string) => {
    setFailedImages((current) => new Set(current).add(id));
  };

  const chooseSuggestion = (product: Product) => {
    setQuery(product.name);
    setSelectedCategory("Tümü");
    setVisibleCount(PAGE_SIZE);
    setSearchFocused(false);
    window.setTimeout(() => {
      document.getElementById("urunler")?.scrollIntoView({ behavior: "smooth" });
    }, 50);
  };

  return (
    <div className="site-shell">
      <InstallPrompt />
      <header className="site-header">
        <a className="brand" href="#top" aria-label="Makbul Mağazası ana sayfa">
          <span className="brand-logo">
            <Image src="/logo.png" alt="Makbul Mağazası" width={52} height={52} priority />
          </span>
          <span>
            <strong>Makbul Mağazası</strong>
            <small>Ürün kataloğu</small>
          </span>
        </a>
        <a className="header-link" href="#urunler">
          Ürünleri keşfet
          <span aria-hidden="true">↓</span>
        </a>
      </header>

      <div className="owner-banner" role="note" aria-label="Site sahiplik bilgisi">
        <span className="owner-banner-icon" aria-hidden="true">✓</span>
        <div className="owner-banner-content">
          <p>Bu uygulama <strong>Yuşa Emin Mert&apos;e</strong> aittir.</p>
          <span className="owner-banner-divider" aria-hidden="true" />
          <p className="owner-manager">
            <span>Bölge Yöneticisi</span>
            <strong>Ümit Terzi</strong>
          </p>
        </div>
      </div>

      <main id="top">
        <section className="hero" aria-labelledby="hero-title">
          <div className="hero-glow hero-glow-one" />
          <div className="hero-glow hero-glow-two" />
          <div className="hero-content">
            <p className="eyebrow">
              <span /> Taptaze lezzetler
            </p>
            <h1 id="hero-title">
              Aradığın ürünü <em>kolayca bul.</em>
            </h1>
            <p className="hero-copy">
              Ürün adına veya koduna göre ara, kategorileri keşfet ve Makbul
              lezzetlerine tek ekrandan ulaş.
            </p>

            <div className="search-wrap">
              <label className="search-box">
                <span className="search-icon"><SearchIcon /></span>
                <span className="sr-only">Ürün ara</span>
                <input
                  type="search"
                  role="combobox"
                  aria-expanded={searchFocused && query.length > 0}
                  aria-controls="search-suggestions"
                  aria-autocomplete="list"
                  value={query}
                  onChange={(event) => updateQuery(event.target.value)}
                  onFocus={() => setSearchFocused(true)}
                  onBlur={() => window.setTimeout(() => setSearchFocused(false), 120)}
                  onKeyDown={(event) => {
                    if (event.key === "Enter" && searchSuggestions[0]) {
                      event.preventDefault();
                      chooseSuggestion(searchSuggestions[0]);
                    }
                    if (event.key === "Escape") setSearchFocused(false);
                  }}
                  placeholder="Ürün adı veya kodu ile ara..."
                  autoComplete="off"
                />
                {query && (
                  <button type="button" onClick={() => updateQuery("")} aria-label="Aramayı temizle">
                    ×
                  </button>
                )}
              </label>

              {searchFocused && query.trim() && (
                <div className="search-suggestions" id="search-suggestions" role="listbox">
                  {searchSuggestions.length > 0 ? (
                    searchSuggestions.map((product) => (
                      <button
                        type="button"
                        role="option"
                        aria-selected="false"
                        className="suggestion-item"
                        key={product.id}
                        onMouseDown={(event) => event.preventDefault()}
                        onClick={() => chooseSuggestion(product)}
                      >
                        <span className="suggestion-image">
                          {product.imageUrl && !failedImages.has(product.id) ? (
                            <Image
                              src={product.imageUrl}
                              alt=""
                              fill
                              sizes="48px"
                              onError={() => registerImageError(product.id)}
                            />
                          ) : (
                            <PackageIcon />
                          )}
                        </span>
                        <span className="suggestion-copy">
                          <strong>{product.name}</strong>
                          <small>{product.category}</small>
                        </span>
                        <span className="suggestion-code">{product.code}</span>
                      </button>
                    ))
                  ) : (
                    <p className="no-suggestion">Bu aramayla eşleşen ürün bulunamadı.</p>
                  )}
                </div>
              )}
            </div>

            <div className="hero-stats" aria-label="Katalog özeti">
              <div><strong>{products.length}</strong><span>ürün</span></div>
              <i />
              <div><strong>{categories.length}</strong><span>kategori</span></div>
              <i />
              <div><strong>Hızlı</strong><span>arama</span></div>
            </div>
          </div>

          <div className="hero-visual" aria-hidden="true">
            <div className="visual-ring ring-one" />
            <div className="visual-ring ring-two" />
            <div className="logo-orbit">
              <Image src="/logo.png" alt="" width={152} height={152} priority />
            </div>
            <span className="floating-chip chip-one">Kuruyemiş</span>
            <span className="floating-chip chip-two">Kuru meyve</span>
            <span className="floating-chip chip-three">Baharat</span>
          </div>
        </section>

        <section className="catalog" id="urunler" aria-labelledby="catalog-title">
          <div className="section-heading">
            <div>
              <p className="eyebrow"><span /> Katalog</p>
              <h2 id="catalog-title">Ürünlerimizi keşfet</h2>
            </div>
            <p>
              <strong>{filteredProducts.length}</strong> ürün gösteriliyor
            </p>
          </div>

          <div className="category-list" aria-label="Ürün kategorileri">
            <button
              type="button"
              className={selectedCategory === "Tümü" ? "active" : ""}
              onClick={() => updateCategory("Tümü")}
            >
              Tümü <span>{products.length}</span>
            </button>
            {categories.map(([category, count]) => (
              <button
                type="button"
                className={selectedCategory === category ? "active" : ""}
                onClick={() => updateCategory(category)}
                key={category}
              >
                {category} <span>{count}</span>
              </button>
            ))}
          </div>

          {visibleProducts.length > 0 ? (
            <>
              <div className="product-grid">
                {visibleProducts.map((product) => (
                  <article className="product-card" key={product.id}>
                    <div className="product-image">
                      {product.imageUrl && !failedImages.has(product.id) ? (
                        <Image
                          src={product.imageUrl}
                          alt={product.name}
                          fill
                          sizes="(max-width: 640px) 50vw, (max-width: 1000px) 33vw, 25vw"
                          onError={() => registerImageError(product.id)}
                        />
                      ) : (
                        <span className="image-placeholder"><PackageIcon /></span>
                      )}
                      <span className="category-badge">{product.category}</span>
                    </div>
                    <div className="product-info">
                      <h3>{product.name}</h3>
                      <div className="product-code">
                        <span>Ürün kodu</span>
                        <strong>{product.code}</strong>
                      </div>
                    </div>
                  </article>
                ))}
              </div>

              {visibleCount < filteredProducts.length && (
                <div className="load-more-wrap">
                  <button type="button" className="load-more" onClick={() => setVisibleCount((count) => count + PAGE_SIZE)}>
                    Daha fazla ürün göster
                    <span aria-hidden="true">↓</span>
                  </button>
                </div>
              )}
            </>
          ) : (
            <div className="empty-state">
              <span><SearchIcon /></span>
              <h3>Aradığın ürünü bulamadık</h3>
              <p>Farklı bir ürün adı veya kodu deneyebilirsin.</p>
              <button type="button" onClick={() => { updateQuery(""); updateCategory("Tümü"); }}>
                Filtreleri temizle
              </button>
            </div>
          )}
        </section>
      </main>

      <footer>
        <div className="footer-brand">
          <Image src="/logo.png" alt="" width={38} height={38} />
          <span><strong>Makbul Mağazası</strong><small>Ürün kataloğu</small></span>
        </div>
        <p>Ürün kataloğu · Tüm hakları saklıdır.</p>
        <a href="#top">Yukarı dön ↑</a>
      </footer>
    </div>
  );
}
