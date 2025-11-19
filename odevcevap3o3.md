# Batman Belediyesi Mobil Uygulaması

Merhaba Hocam,

Biz üç kişilik ekibimiz **Ahmet, Ben (Enes) ve Ceren** olarak dönem boyunca Batman Belediyesi mobil uygulamasını geliştirirken nasıl bir süreç izlediğimizi "samimi ama rapor tadında" sizinle paylaşmak istedik. Aşağıda 10 haftalık yolculuğumuzu Yazılım Mühendisliği Yaşam Döngüsü adımlarına oturtarak anlattık. Her hafta sonunda lab asistanınıza gönderdiğimiz mini‐raporları da özetledik.

---

## 1. Planlama ‑ Hafta 1
* **Toplantı & Hedef koyma** – Zoom’da ilk kickoff. Uygulamanın Batman halkına haber, etkinlik, online işlemler ve başkanlık duyuruları sunmasını istiyoruz.
* **Rol paylaşımı**  
  * Ahmet → Proje yöneticisi, sürüm takvimi, Git branching.  
  * Ben → Baş geliştirici (Flutter), CI/CD.  
  * Ceren → UI/UX & test senaryoları.
* **Kaynak tahmini** – 3 kişi × 8 saat/hafta ≈ 240 adam-saat, ₺0 altyapı (local/dev), sadece kişisel laptoplarımız.
* **Riskler** – Flutter öğrenme eğrisi, API bulunmaması ⇒ HTML parse + mock json.

## 2. Sistem Çözümleme ‑ Hafta 2
* **İş Gereksinimleri** – Belediye haberleri, meclis kararları PDF linkleri, e-belediye ödeme sayfası, harita ile ulaşım.
* **Kullanıcı Hikâyeleri**  
  1. "Vatandaş olarak en güncel duyuruları görebilmek istiyorum…"  
  2. "Ödeme ekranına güvenli bir şekilde yönlendirilmek istiyorum…"
* **Teknik Gereksinimler** – Flutter 3.19, Dart 3.9, minimum SDK 21, sadece HTTP & WebView, offline destek yok (scope küçültme).
* **Çıktı** – SRS dokümanı ve Miro’da akış diyagramı (lab sunumu).

## 3. Tasarım ‑ Hafta 3
* **Bilgi Mimarisi** – `lib/` altında `models`, `screens`, `widgets` klasörleri.
* **UI Wireframe** – Ceren Figma’da; Ahmet onayladı.
* **Uygulama Mimarisi** – Basit `Navigator` + stateless widget hiyerarşisi, state ihtiyacı sınırlı ⇒ Provider yerine setState.
* **Veri Katmanı** – `http` paketi ile REST + bazı HTML parse işlemleri (`html` paketi).
* **Güvenlik** – `url_launcher` üzerinden HTTPS kontrolleri, network_security_config.

## 4. Gerçekleştirim
### Hafta 4 – Kurulum & İskele
* Flutter proje oluşturuldu (`batmanbelediyesi`) ve GitHub repo açıldı.
* CI için GitHub Actions: `flutter test` + `flutter analyze`.

### Hafta 5 – Ana Ekran & Drawer
* `home_screen.dart` + `app_drawer.dart` tamamlandı, mock verilerle slider (`carousel_slider`) ve hızlı erişim kartları.

### Hafta 6 – İçerik Ekranları
* Duyurular, Haberler, Başkan Hakkında, Meclis Kararları listeleri.
* `announcement.dart`, `baskan.dart` modelleri.

### Hafta 7 – Servis Entegrasyonu
* Batman Belediyesi resmi site HTML’lerinden basit parse; CORS sorunu olmadığı için direkt `http.get()`
* `webview_flutter` ile e-Belediye ödeme ve e-İmar modülü.

## 5. Yazılım Doğrulama ve Geçerleme
### Hafta 8
* Widget testleri (`test/widget_test.dart`) güncellendi; 20 test, %78 coverage.
* Manuel QA – Ceren’in hazırladığı 15 senaryonun 13’ü geçti, 2 UI paddings düzeltildi.

## 6. Kurulum ve Bakım
### Hafta 9
* `release` flavor oluşturuldu, `appbundle` alınarak Google Play internal track’e yüklendi (sadece biz görebiliyoruz).
* Sürüm notları, gizlilik politikası draft.

### Hafta 10 – Kapanış & Sunum
* Proje retrospektifi – Notion sayfası; iyi: zamanında teslim, kötü: API yoktu, ders: adapter pattern kullanabilirdik.
* Laboratuvar sunumu: 10 slayt + canlı demo (apk local emulator).
* Bakım planı: 
  * Ayda bir dependency upgrade
  * Belediye RSS açarsa JSON servis adaptasyonu

---

## Yaşam Döngüsü Adımlarına Göre Özet Tablo
| Adım | Çıktılar | Sorumlu |
|------|----------|---------|
| Planlama | Proje planı, risk listesi | Ahmet |
| Sistem Analizi | SRS, kullanıcı hikâyeleri | Ben & Ceren |
| Tasarım | Figma wireframe, mimari diyagram | Ceren |
| Gerçekleştirim | Flutter kodu (`lib/`) | Ben |
| Doğrulama & Geçerleme | Test raporu, coverage | Ahmet & Ceren |
| Kurulum & Bakım | Play Store iç sürüm, bakım protokolü | Üçümüz |

---

### Kaynak Planı (Gerçekçi)
* İnsan: 3 öğrenci × 10 hafta × 8 saat ≈ **240 adam-saat**
* Donanım: Kendi laptoplarımız (M1 Mac, Windows i5, Ubuntu Ryzen) – ek maliyet ₺0
* Yazılım: Flutter SDK (ücretsiz), GitHub Student (ücretsiz private repo)

### Güvenlik & Kalite Politikası
1. Tüm HTTP istekleri HTTPS, SHA-256 pin yok → orta düzey.
2. Code Review: her PR’da en az bir göz (+flutter `analyze` yeşil).
3. Versiyonlama: SemVer `1.0.0+{build}`.
4. Yedek: GitHub + lokal TimeMachine.

---
Bu süreçte ekip olarak hep "ortak hareket" ettik. PR’larda sürekli etiketleşip, Zoom‐codereview yaptık. Uygulama fikrini ilk ben yazmış olsam da, her ekrana Ahmet’in backseat-driving yorumları ve Ceren’in piksel takıntısı damga vurdu 😊

Umarız raporumuz beklentilerinizi karşılar. Sunum dosyamız ve apk iç sürümü de hazır; lab saatinde paylaşacağız.

Sevgiler,

Ahmet – Enes – Ceren
