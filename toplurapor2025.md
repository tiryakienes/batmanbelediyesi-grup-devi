# BATMAN BELEDİYESİ TABANLI KURUMSAL WEB SİTESİ GELİŞTİRME PROJESİ

Takım: Enes • Ceren • Ahmet  
Süre: 7 Hafta (Hafta 1–7)  
Teslim: 15 Aralık 2025, 17:00  
Çalışma Şekli: Eşit görev dağılımı, eşit katkı (her hafta dönüşümlü mini liderlik)

---

## 0) Proje Özeti ve Kapsam
Batman Belediyesi kurumsal web sitesi örnek alınarak; planlama, sistem çözümleme, tasarım, gerçekleştirim, doğrulama-geçerleme, kurulum-bakım aşamalarının tamamını uyguladığımız kapsamlı bir yazılım mühendisliği projesi gerçekleştirdik. Çözümümüz; 
- Modern, responsive, erişilebilir kurumsal web deneyimi,
- Haberler, duyurular, nöbetçi eczane, vefat edenler ve e-belediye bağlantıları,
- Yerel ortamda çalıştırılabilen ve dış servis gerektirmeyen kurulum politikası,
- Sıkı versiyon kontrolü, teknik gözden geçirmeler ve düzenli lab rapor akışı üzerine kurgulanmıştır.

Not: Geliştirme Flutter tabanlıdır ve hem web (Flutter Web) hem mobil hedeflenebilir; proje isterleri gereği “web sitesi geliştirme” odağıyla ilerlenmiş, localden çalıştırılabilir yapı korunmuştur. Domain/hosting satın alınmamıştır.

---

## 1) Yazılım Yaşam Döngüsü Adımları ve Politikamız

### 1. Planlama
- Kapsam: Anasayfa, Kurumsal, Projeler, Kültür-Sanat, Haberler, Duyurular, E-Belediye bağlantıları, İletişim ve Arama.
- Kısıtlar: Yerel çalıştırma, ek maliyet yok, tek kaynak kurumsal site içeriği.
- Zaman: 7 haftalık sprint planı (aşağıda).
- İnsan kaynağı: 3 kişi, haftalık ~10-12 saat/kişi → toplam ~210-250 adam-saat.
- Maliyet: 0 TL (tüm araçlar ücretsiz).
- Risk matrisi ve mitigasyon: Site yapısındaki değişimler, ağ sorunları, erişilebilirlik ve performans riskleri için yedek seçiciler, hata yakalama ve optimizasyon politikaları.
- Politika: “İki haftada bir” lab raporu, her PR’da teknik gözden geçirme, her hafta retro ve planlama toplantısı.

### 2. Sistem Çözümleme
- Persona ve senaryolar (vatandaş odaklı): Haber okuma, eczane bulma, e-belediye hizmetlerine yönlenme, iletişime geçme.
- Gereksinimler: 
  - Fonksiyonel: Haber/duyuru listeleme, detay sayfaları, arama, yönlendirmeler.
  - Fonksiyonel olmayan: <3 sn ilk boyama, responsive tasarım, temel erişilebilirlik (kontrast, odak sırası, alternatif metinler), güvenli istekler (HTTPS hedef), modüler kod.
- Bilgi mimarisi ve site haritası: Üst menü, alt menü, içerik kategorileri, breadcrumb ve arama.
- Veri modeli: News, Announcement, Pharmacy, Obituary temel alanları belirlendi.

### 3. Tasarım
- UI/UX: Renk paleti (kurumsal mavi tonları), tipografi (Roboto), 4px grid, bileşen kütüphanesi (AppBar, Drawer, Card, Grid, TabBar).
- Wireframe → yüksek sadakat mockup → tıklanabilir prototip akışı.
- Erişilebilirlik: Kontrast kontrol, klavye ile gezilebilirlik, odak stilleri.
- Tasarım kararları: Minimal üst bar, “hikayeler”/kısayol butonları, slider, 4x2 hizmet grid’leri, yatay haber akışı.

### 4. Gerçekleştirim
- Teknolojiler: Flutter/Dart, HTTP ve HTML parse (webden açık içerik), URL yönlendirme, responsive layout.
- Mimari: Basit state + servis katmanı, feature-based dosya düzeni, yeniden kullanılabilir widget’lar.
- Versiyon kontrol: Git + feature branch + PR + code review. Conventional Commits.
- Güvenlik: Giriş verisi doğrulama, URL normalizasyonu, hatalarda kullanıcıya güvenli geri bildirim.

### 5. Yazılım Doğrulama ve Geçerleme
- Test piramidi: Birim + widget + entegrasyon testleri, manuel uçtan uca akışlar.
- Doğrulama: Gereksinim izlenebilirliği, kullanıcı senaryoları üzerinden kabul.
- Performans: İlk yükleme süreleri, görsel optimizasyon, lazy opsiyonlar.
- Erişilebilirlik: Renk kontrastı ve odak akışı kontrolleri.

### 6. Kurulum ve Bakım
- Kurulum: Local geliştirme ve çalışma (Flutter Web/Mobile), hazır scriptler (dokümana dahil), ek servis yok.
- Bakım: Hata düzeltmeleri, içerik seçicilerinin güncellenmesi, performans iyileştirme, iki ayda bir minör refaktör.
- İzleme: Geliştirme sürümünde loglama ve manuel gözlem, ileri aşamada analitik/çökme raporları eklenebilir.

---

## 2) Haftalık Ayrıntılı İlerleme (7 Hafta)

### Hafta 1 — Proje Başlangıcı ve Versiyon Kontrolü
Mini Lider: Enes (Ceren ve Ahmet eşit görevde)
- Git kurulumu, global config, SSH anahtarları, repo oluşturma.
- Branch stratejisi: main (korumalı), develop, feature/*, fix/*; PR zorunlu, en az 2 onay.
- Commit mesaj standardı: Conventional Commits (feat, fix, docs, chore, refactor, test, perf).
- İş takibi: Kanban board (To Do, In Progress, Review, Done) ve iş kırılım listesi.
- Proje iskeleti ve README iskeleti oluşturuldu.
- Ekip toplantısı: Kapsam ve teslim tarihleri; lab asistanına başlangıç bildirimi.
Görev paylaşımı (eşit): 
- Enes: Repo/branch/PR şablonları, .gitignore
- Ceren: README taslağı, iş akışı şeması
- Ahmet: Görev kartları, risk kayıtlarının ilk sürümü
Çıktılar: Git repo, çalışma kuralları, başlangıç dokümantasyonu.

### Hafta 2 — Planlama ve Sistem Çözümleme
Mini Lider: Ceren (Enes ve Ahmet eşit görevde)
- Kurumsal web sitesi içerik envanteri (haber, duyuru, eczane, vefat, e-belediye).
- Persona ve kullanıcı hikayeleri (“vatandaş olarak …”).
- Fonksiyonel/olmayan gereksinimler; önceliklendirme (MoSCoW).
- Site haritası, bilgi mimarisi, temel akış diyagramları.
- Risk matrisi ve mitigasyon planı (site DOM değişimi, ağ kesintisi, performans, erişilebilirlik).
- 2 haftalık lab iş akış raporu gönderildi (Hafta 1–2 özet ve artefakt listesi).
Görev paylaşımı (eşit): 
- Enes: Gereksinim matrisi ve izlenebilirlik tablosu
- Ceren: Persona, kullanıcı senaryoları, site haritası
- Ahmet: Risk matrisi, MoSCoW önceliklendirme
Çıktılar: PRD, sistem analiz dokümanı, lab raporu #1.

### Hafta 3 — Tasarım (UI/UX) ve Bileşen Kütüphanesi
Mini Lider: Ahmet (Enes ve Ceren eşit görevde)
- Renk paleti, tipografi, 4px boşluk sistemi; bileşen envanteri (AppBar, Drawer, Card, Grid, TabBar, Carousel, Story buttons, Search modal).
- Wireframe → high-fidelity mockup’lar (Figma) → tıklanabilir prototip.
- Erişilebilirlik gereksinimleri gözetilerek kontrast ve odak hiyerarşisi belirlendi.
- Tasarımdan koda eşleme: komponent adları ve props sözleşmeleri.
Görev paylaşımı (eşit): 
- Enes: Header/Navigation, Carousel/Indicator tasarım spesleri
- Ceren: Kart/Tab yapı taşları, buton durumları
- Ahmet: Sayfa şablonları (Home, Haberler, İletişim), prototip bağlantıları
Çıktılar: Figma seti, tasarım sistemi, komponent sözlüğü.

### Hafta 4 — İskelet Uygulama, Navigasyon ve Responsive Grid
Mini Lider: Enes (Ceren ve Ahmet eşit görevde)
- Proje yapılandırması, çoklu sayfa yönlendirme, Drawer + Bottom Nav kombinasyonu.
- Responsive layout: 12 kolon grid mantığına karşılık gelen esnek genişlikler; küçük/orta/büyük kırılım noktaları için boyutsal kararlar.
- Anasayfa iskeleti: üst bar, hikaye butonları, slider, hizmet grid, yatay haber akışı placeholder.
- Erişilebilirlik: Semantik isimler, alternatif metin alanları, odak sırası testleri.
- 2 haftalık lab raporu gönderildi (Hafta 3–4: tasarım ve iskelet ilerleme).
Görev paylaşımı (eşit): 
- Enes: Router, global tema, layout helper’lar
- Ceren: Drawer ve üst navigasyon, grid komponentleri
- Ahmet: Home şablonu, placeholder içerik ve test sayfaları
Çıktılar: Çalışan iskelet, temel navigasyon, lab raporu #2.

### Hafta 5 — Dinamik Veri Entegrasyonu, Arama ve İçerik Akışları
Mini Lider: Ceren (Enes ve Ahmet eşit görevde)
- Haberler ve duyurular listeleri: HTTP GET ve HTML parsing ile içerik alanlarının çıkarılması; URL normalizasyonu (relative→absolute), hata yönetimi.
- Nöbetçi eczane ve vefat edenler listesi: Tablo ve kart yapılarından veri çıkarma; telefon/link alanları ve harita bağlantıları.
- Arama modal: Basit başlık/anahtar kelime filtreleme (istemci tarafı) ve sonuç listeleme.
- Performans: Lazy listeler, yükleme durumu göstergeleri, hata durum diyalogları.
Görev paylaşımı (eşit): 
- Enes: Haber/duyuru akışları, detay sayfası bağlamaları
- Ceren: Arama modal, URL/koordinat yardımcıları, hata/boş durum şablonları
- Ahmet: Eczane/vefat veri çıkarımı, harita/telefon kısayolları
Çıktılar: Dinamik liste ekranları, arama, hata/boş durum desenleri.

### Hafta 6 — Doğrulama, Test, Erişilebilirlik ve Performans
Mini Lider: Ahmet (Enes ve Ceren eşit görevde)
- Test piramidi: 
  - Birim testler (yardımcı fonksiyonlar: URL normalize, koordinat çıkarımı, metin temizleme),
  - Widget testleri (AppBar, kartlar, liste/sekme görünümü),
  - Entegrasyon akışları (haber → detay, arama, yönlendirmeler).
- Performans ölçüm: İlk boyama süresi, liste render performansı, görsel yükleme stratejileri.
- Erişilebilirlik gözden geçirme: Kontrast, odak sırası, klavye gezinebilirlik.
- 2 haftalık lab raporu gönderildi (Hafta 5–6: doğrulama ve metrikler).
Görev paylaşımı (eşit): 
- Enes: Entegrasyon testleri ve ölçüm betikleri
- Ceren: Widget testleri, kontrast/odak denetimi
- Ahmet: Birim testler, performans bulguları ve düzeltmeler
Çıktılar: Test raporu, hata listesi ve düzeltmeler, lab raporu #3.

### Hafta 7 — Dokümantasyon, Sunum ve Teslim Hazırlığı
Mini Lider: Enes (Ceren ve Ahmet eşit görevde)
- Teknik dokümantasyon: Kurulum kılavuzu, mimari ve komponent rehberi, bakım planı.
- Sunum: 20–30 slayt; problem-kapsam-çözüm, mimari-tasarım, canlı demo akışı, test sonuçları, sonuç ve gelecek planı.
- Son kontrol: Gereksinim izlenebilirliği, akışların tamlığı, hataların kapatılması, içerik/proofreading.
- Teslim paket listesi ve raporun nihai sürümü.
Görev paylaşımı (eşit): 
- Enes: Sunum akışı ve canlı demo senaryosu
- Ceren: Teknik rapor/kurulum/bakım bölümleri
- Ahmet: Mimari-erişilebilirlik-performans bölümleri ve görseller
Çıktılar: Nihai rapor, sunum, teslim paketleri.

---

## 3) Kaynak, Zaman ve Maliyet Planı
- İnsan kaynağı: 3 kişi × ~10–12 saat/hafta × 7 hafta ≈ 210–250 adam-saat.
- Donanım: Kişisel laptoplar.
- Yazılım: Flutter SDK, VS Code/Android Studio, tasarım araçları (ücretsiz), Git/GitHub.
- Maliyet: 0 TL (barındırma/domainsiz, lokal çalışma).
- Zaman çizelgesi: Yukarıdaki 7 haftalık sprint planı, 2 haftada bir lab raporu.

---

## 4) Takım Çalışması Politikası ve Uyum
- Eşit görev: Her hafta görevler üçe bölündü, mini liderlik döngüsel devredildi.
- Teknik gözden geçirme: Her PR en az iki onay sonrası birleşti.
- Toplantılar: Haftalık planlama ve retro, gerektiğinde ad-hoc teknik görüşmeler.
- Sorun çözümü: Takvim/uyum çatışmaları için asenkron çalışma ve net teslim saatleri; fikir ayrılıklarından konsensus notları.
- Sunum: Roller paylaşıldı; prova ve zaman yönetimi yapıldı.

---

## 5) Güvenlik ve Uygulama Prosedürleri
- Yerel geliştirme: Dışa açık API anahtarı yok; gizli bilgiler depolanmadı.
- HTTP istekleri: HTTPS hedefleri ve hata yönetimi; beklenmeyen DOM değişimleri için esnek seçiciler.
- Girdi doğrulama: Kullanıcı girdileri sanitize edildi (arama vs.).
- Kod kalitesi: Lint kuralları, pre-commit denetimleri önerisi, PR inceleme kontrol listesi.

---

## 6) Test Stratejisi ve Sonuçları (Özet)
- Birim testler: URL normalizasyonu, koordinat çıkarımı, tarih/metin temizliği.
- Widget testleri: AppBar, Drawer, kart render, sekmeli yapı, boş/hata durumları.
- Entegrasyon: Haber → detay gezinme, arama akışı, yönlendirmeler.
- Performans: İlk yükleme <3 sn hedefi; görsel gecikmelerde yükleyici göstergeleri.
- Erişilebilirlik: Kontrast ve odak akışı doğrulandı; temel klavye gezilebilirlik sağlandı.

---

## 7) Kurulum ve Çalıştırma (Yerel)
- Gereksinimler: Flutter SDK, bir tarayıcı (web) veya emülatör/cihaz (mobil).
- Adımlar:
  1) Bağımlılıklar: `flutter pub get`
  2) Web için çalıştırma: `flutter run -d chrome`
  3) Mobil için çalıştırma: `flutter run`
- Not: Herhangi bir web servis/hosting satın alımı yoktur; tüm çalışma lokal ortamda yapılır.

---

## 8) Teslimatlar ve Dokümantasyon
- Bu rapor (toplurapor2025.md)
- Teknik dokümantasyon (kurulum, mimari, bakım)
- Sunum dosyası (20–30 slayt) ve demo akışı
- Test raporu ve metrik özeti
- Versiyon kontrol geçmişi, PR’lar ve kod inceleme notları
- Lab iş akış raporları (Hafta 1–2, 3–4, 5–6)

---

## 9) Risk Matrisi (Özet) ve Mitigasyon
- Site DOM değişimi → Alternatif CSS seçicileri ve hızlı düzeltme rehberi.
- Ağ/erişim sorunları → Hata diyalogları, tekrar dene aksiyonları.
- Erişilebilirlik eksikleri → Kontrast/odak denetimleri, manuel test kontrol listesi.
- Performans → Görsel yükleme stratejileri, iskelet ekranlar, liste optimizasyonları.

---

## 10) Eşit Katkı Beyanı
Enes, Ceren ve Ahmet; planlama, analiz, tasarım, gerçekleştirim, doğrulama-geçerleme ve kurulum-bakım aşamalarında eşit derece görev almış ve haftalık görev dağılımı dengeli şekilde yapılmıştır. Mini liderlik haftadan haftaya dönüşümlü atanmış, PR incelemeleri ve lab raporları ortak sorumluluk olarak yürütülmüştür.

---

## Ek: Gantt Benzeri Metin Çizelgesi
- Hafta 1: Başlangıç, Git ve kurallar
- Hafta 2: Planlama + Analiz
- Hafta 3: Tasarım ve bileşen sistemi
- Hafta 4: İskelet, navigasyon, responsive grid
- Hafta 5: Dinamik veri, arama, içerik akışları
- Hafta 6: Test, performans, erişilebilirlik, lab raporu
- Hafta 7: Dokümantasyon, sunum, son teslim hazırlığı
