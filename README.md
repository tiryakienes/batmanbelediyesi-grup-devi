# batmanbelediyesi-grup-devi

Batman Belediyesi için geliştirilmiş modern bir mobil uygulama. **Gerçek Batman Belediyesi web sitesi** tasarımından esinlenerek oluşturulmuştur.

## 🎨 Özellikler

### Ana Sayfa (Home Screen)
- **Üst Bar**: 
  - Sol: Menü butonu (Drawer açar)
  - Orta: Batman Belediyesi logosu ve yazısı
  - Sağ: Bildirimler ikonu
- **Carousel Slider**: Otomatik kaydırmalı duyuru ve etkinlik banner'ları (3 adet)
- **Instagram Stories Tarzı Butonlar**: Dairesel hızlı erişim butonları
  - Instagram hikayeleri gibi gradient border
  - Başkan (fotoğraf ile)
  - Haberler (tıklanabilir)
  - Etkinlikler
  - Yatay kaydırma ile genişletilebilir
- **Sık Kullanılan Hizmetler**: Kaydırılabilir (swipeable) sayfa yapısı
  - PageView ile sayfalama (her sayfada 8 buton)
  - Sayfa göstergeleri (dots)
  - 4x2 grid düzeni
  - Küçük, kompakt buton tasarımı
  **Sayfa 1 (8 buton):**
  1. Borç Ödeme
  2. Başvuru Sorgulama
  3. ÇTV Beyan Bildirimi
  4. Bildirim Durum Sorgulama
  5. İstek - Şikayet - Öneri
  6. Emlak Beyan Bildirimi
  7. İlan Reklam Bildirimi
  8. Ruhsat Sorgulama
  
  **Sayfa 2 (6 buton):**
  9. Online Ödeme
  10. Duyuru-İlan
  11. Kent Rehberi
  12. Batman Ulaşım
  13. Kütüphane Katalog
  14. Nöbetçi Eczane

- **Haberler & Duyurular**: Kaydrılabilir haber kartları (Canlı Veri!)
  - **Web scraping**: https://www.batman.bel.tr/haber adresinden gerçek haberler
  - Yatay scroll (horizontal ListView)
  - İki kart yan yana görünür
  - Her kart: Görsel + Başlık + Tarih (internetten yüklenir)
  - "TÜMÜ" butonu ile haberler sayfasına geçiş
  - İlk 4 haber otomatik yüklenir
  - Loading state (CircularProgressIndicator)

### Drawer Menü (Üst Navigasyon)
- **Anasayfa**
- **Kurumsal** ▼
  - Başkan
  - Tarihçe
  - Organizasyon Şeması
  - Birimler
  - Meclis Üyeleri
- **Projeler** ▼
  - Devam Eden Projeler
  - Tamamlanan Projeler
  - Planlanan Projeler
- **Kültür Sanat** ▼
  - Etkinlikler
  - Kültür Merkezleri
  - Kütüphane
  - Konser & Tiyatro
- **Haberler**
- **Güncel** ▼
  - Duyurular
  - İhaleler
  - Etkinlik Takvimi
- **E-Belediye** ▼
  - Online Ödeme
  - Başvuru Sorgulama
  - İstek & Şikayet
  - E-İmar
- **İletişim**

### Haberler Sayfası
- **Gerçek zamanlı veri**: https://www.batman.bel.tr/haber
- **Web scraping**: http + html paketleri ile
- **HTML parsing**: .blog-card CSS selector
- Tab Bar ile Haberler ve Duyurular sekmeli yapı
- Görsel, başlık, açıklama ve tarih bilgisi (canlı)
- Her haber kartı tıklanabilir (haber detay sayfasına yönlendirir)
- Görseller internetten yüklenir (Image.network)
- Pull-to-refresh özelliği (RefreshIndicator)
- Hata yönetimi (internet bağlantısı, parse hatası)
- Loading state (CircularProgressIndicator)
- Boş durum yönetimi (haber yoksa)

### Haber Detay Sayfası
- **Gerçek zamanlı veri**: Her haberın kendi detay sayfasından
- **Web scraping**: Haber detay HTMLı'sini parse eder
- **HTML parsing**: .news-details-content-box, .page-banner-title selectors
- Ana görsel (büyük boyutta)
- Haber başlığı ve tarih
- Tam haber içeriği (tüm metin)
- Haber görselleri galerisi (grid layout)
- Galeri görselleri tıklanabilir (tarayıcıda açılır)
- "Web Sitesinde Aç" butonu
- Paylaş butonu (AppBar'da)
- Loading state ve hata yönetimi
- Geri dönüş butonu

### E-Belediye İşlemleri
- Tüm belediye hizmetlerinin listesi
- Borç Ödeme, Başvuru Sorgulama, ÇTV Beyan, vb.

### Nöbetçi Eczane Sayfası
- **Gerçek zamanlı veri**: https://www.batman.bel.tr/nobetci-eczane
- **Web scraping**: http + html paketleri ile
- **HTML parsing**: .event-card CSS selector
- Güncel nöbetçi eczane bilgileri (canlı)
- Eczane adı, ilçe, adres, telefon
- Telefon arama özelliği (tel: link)
- Haritada görüntüleme butonu (Google Maps)
- Yeşil gradient header tasarım
- Hata yönetimi (internet bağlantısı, parse hatası)
- Loading state (CircularProgressIndicator)

### Alt Navigasyon
- Anasayfa, E-Belediye, Arama (merkezi büyük buton), Güncel, İletişim

## 🚀 Kurulum

### Bağımlılıkları yükleyin:
```bash
flutter pub get
```

### Uygulamayı çalıştırın:
```bash
flutter run
```

## 📂 Proje Yapısı

```
lib/
├── main.dart                          # Ana uygulama giriş noktası
├── widgets/
│   └── app_drawer.dart                # Drawer menü (navigasyon)
└── screens/
    ├── home_screen.dart               # Ana sayfa (14 hizmet, web scraping haberler)
    ├── news_screen.dart               # Haberler sayfası (web scraping)
    ├── news_detail_screen.dart        # Haber detay sayfası (web scraping)
    ├── e_municipality_screen.dart     # E-Belediye işlemleri
    └── pharmacy_screen.dart           # Nöbetçi eczane (web scraping)
```

## 📦 Kullanılan Paketler

- `carousel_slider`: Banner slider için
- `smooth_page_indicator`: Carousel göstergeleri
- `url_launcher`: Link ve telefon açma
- `http`: Web'den veri çekme
- `html`: HTML parsing (web scraping)

## 🎯 Tamamlanan Özellikler

✅ **Web sitesine uygun tasarım** - Batman Belediyesi web sitesinden kopyalandı
✅ **Drawer menü** - 8 ana kategori, açılır alt menüler ile
✅ **Instagram stories butonlar** - Gradient border ile dairesel hızlı erişim
✅ **Kaydırılabilir hizmetler** - PageView ile swipeable sayfa sistemi
✅ **14 hizmet butonu** - 2 sayfa (8+6 buton), 4x2 grid
✅ **Sayfa göstergeleri** - Animated dots indicator
✅ **Carousel slider** - 3 banner ile otomatik kayma
✅ **Mavi renk teması** - Web sitesindeki lacivert/mavi tonlar
✅ **Modern AppBar** - Logo, menü ve bildirim ikonları
✅ **Bottom navigation** - 5 tab ile
✅ **Haberler sayfası** - Tab bar ile
✅ **E-Belediye sayfası** - Tüm 14 hizmet listesi
✅ **Responsive tasarım** - Farklı ekran boyutlarına uyumlu
✅ **Gradient efektler** - Butonlar ve banner'larda
✅ **Küçük kompakt butonlar** - Görseldeki gibi
✅ **Haberler & Duyurular** - Kaydrılabilir haber kartları
✅ **Yatay scroll haber listesi** - İkişer kart yan yana
✅ **Nöbetçi eczane sayfası** - Gerçek zamanlı web scraping
✅ **Haberler sayfası web scraping** - batman.bel.tr/haber
✅ **Haber detay sayfası** - Uygulama içinde tam haber görüntüleme
✅ **Haber detay web scraping** - Her haberın kendi sayfasından içerik çekme
✅ **Ana sayfa haberler web scraping** - İlk 4 haber otomatik yükleme
✅ **Web scraping** - http + html paketleri ile
✅ **HTML parsing** - CSS selectors (.blog-card, .event-card, .news-details-content-box)
✅ **Haber galeri görselleri** - Grid layout ile görsel galeri
✅ **Telefon arama** - url_launcher ile
✅ **Harita entegrasyonu** - Google Maps link
✅ **Haber paylaşma** - Share butonu ile
✅ **Image loading** - Network görseller, loading indicator
✅ **Pull-to-refresh** - Haberleri yenileme özelliği
✅ **Hata yönetimi** - Try-catch + error dialog + retry

## 🔜 Gelecek Özellikler (Backend için)

- API entegrasyonu
- Kullanıcı girişi
- Gerçek zamanlı hava durumu
- Push notification
- Form sistemleri
- Veritabanı entegrasyonu

## 📱 Platform Desteği

- ✅ Android
- ✅ iOS
- ✅ Web
