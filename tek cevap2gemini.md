
# Batman Belediyesi Mobil Uygulama Projesi - Geliştirme Raporu

**Proje Ekibi:**
- Enes (Proje Yöneticisi & Çekirdek Geliştirme)
- Ahmet (UI/UX Tasarım & Arayüz Geliştirme)
- Ceren (Veri Analizi & Servis Entegrasyon)

**Proje Süresi:** 10 Hafta

**Teslim Tarihi:** 15 Aralık 2025

---

## Genel Bakış

Bu rapor, "Batman Belediyesi Mobil Uygulaması" projemizin 10 haftalık geliştirme sürecini, Yazılım Mühendisliği Yaşam Döngüsü adımlarını temel alarak detaylandırmaktadır. Proje, tarafımca (Enes), Ahmet ve Ceren'den oluşan üç kişilik ekibimizle, hocamızın ve araştırma görevlimizin direktifleri doğrultusunda geliştirilmiştir. Amacımız, Batman Belediyesi'nin sunduğu hizmetleri mobil platforma taşıyarak vatandaşların bilgiye ve hizmetlere kolayca erişimini sağlamaktır. Proje boyunca maliyet gerektirmeyen, yerelde çalıştırılabilir ve yalın bir sistem kurma prensibine bağlı kaldık.

---

### **Hafta 1-2: Planlama ve Sistem Çözümlemesi**

#### **Süreç:**

Hocamızla ilk toplantımızı yaptıktan sonra proje hedeflerini netleştirmek için ekip olarak bir araya geldik. Projenin temel amacı, belediyenin web sitesinde var olan ancak mobil için optimize edilmemiş hizmetleri, modern ve kullanıcı dostu bir mobil uygulamada toplamaktı.

**1. Planlama:**

*   **Görev Dağılımı:** Aramızda hızlıca bir görev dağılımı yaptık. Ben (Enes), projenin genel mimarisini kurmaktan, Flutter iskeletini oluşturmaktan ve genel proje yönetiminden sorumlu oldum. Ahmet, uygulamanın tüm görsel tasarımını (wireframe, mockup) ve kullanıcı deneyimi (UX) akışlarını üstlendi. Ceren ise en kritik görevlerden biri olan, belediyenin web sitesinden veri çekme (web scraping) ve bu verileri uygulamada kullanılabilir hale getirme (servis mantığı) sorumluluğunu aldı.
*   **Zaman Çizelgesi:** 10 haftalık süreci modüllere ayırdık. İlk 2 hafta analiz ve planlama, sonraki 5 hafta ana özelliklerin geliştirilmesi, son 3 hafta ise test, optimizasyon ve raporlama olarak planlandı. İş takibi için Trello üzerinde basit bir proje panosu oluşturduk.
*   **Teknoloji Seçimi:** Projeyi cross-platform (hem iOS hem Android) geliştirebilmek için **Flutter** ve **Dart** dilini kullanmaya karar verdik. Bu seçim, tek bir kod tabanı ile hızlı geliştirme yapmamızı sağladı.

**2. Sistem Çözümlemesi:**

*   **Veri Kaynağı Analizi:** Ceren, belediyenin resmi web sitesi olan `batman.bel.tr`'yi baştan sona analiz etti. Haberler, duyurular, nöbetçi eczaneler, vefat edenler gibi dinamik verilerin hangi sayfalarda, hangi HTML yapıları içinde yer aldığını belgeledi. Bu analiz, veri çekme stratejimizin temelini oluşturdu. Bir API olmadığı için tüm veriyi web scraping ile alacağımız kesinleşti.
*   **Gereksinim Belirleme:** Kullanıcıların en çok ihtiyaç duyacağı hizmetleri önceliklendirdik:
    *   **Ana Sayfa:** Güncel haberlere, duyurulara ve temel hizmetlere hızlı erişim.
    *   **E-Belediye:** Tüm dijital hizmetlerin listelendiği bir merkez.
    *   **Haberler ve Duyurular:** Belediyeden gelen güncel bilgiler.
    *   **Nöbetçi Eczane:** Konum ve iletişim bilgileriyle birlikte günlük liste.
    *   **Vefat Edenler:** Güncel taziye bilgileri.
    *   **Kent Rehberi & E-İmar:** Web tabanlı harita servislerinin entegrasyonu.
    *   **Diğer Hizmetler:** Meclis kararları, online ödeme gibi diğer önemli linkler.

İlk iki haftanın sonunda, ne yapacağımızı, nasıl yapacağımızı ve kimin ne yapacağını net bir şekilde belirlemiştik. Sağlam bir planla yola çıkmaya hazırdık.

---

### **Hafta 3-4: Tasarım ve Gerçekleştirim (İlk Adımlar)**

#### **Süreç:**

Planlama aşaması biter bitmez hemen işe koyulduk. Ahmet tasarımları hazırlarken, ben de projenin kod temelini atmaya başladım.

**3. Tasarım:**

*   **Arayüz Tasarımı (UI/UX):** Ahmet, Figma üzerinde uygulamanın wireframe ve mockup'larını hazırladı. Batman Belediyesi'nin kurumsal kimliğine uygun, mavi ve beyaz tonlarının hakim olduğu, modern ve sade bir tasarım dili benimsedik. Ana sayfa, hizmetler listesi ve alt navigasyon barı gibi temel bileşenlerin tasarımları bu aşamada netleşti. Kullanıcı akışlarını olabildiğince basit tuttuk.
*   **Mimari Tasarım:** Ben, projenin klasör yapısını oluşturdum: `screens` (her bir sayfa için), `widgets` (tekrar kullanılabilir arayüz bileşenleri), `models` (veri yapıları için) ve `services` (veri çekme mantığı için) şeklinde bir yapı kurdum. Bu, projenin ilerleyen zamanlarda karmaşıklaşmasını önleyecek ve ekip olarak daha organize çalışmamızı sağlayacaktı.

**4. Gerçekleştirim (Implementation):**

*   **Proje Kurulumu:** Flutter projesini oluşturdum, `pubspec.yaml` dosyasına ilk bağımlılıklarımızı (`http`, `html`, `flutter_lints`) ekledim. Projenin ana giriş noktası olan `main.dart` dosyasını ve temel tema ayarlarını yapılandırdım.
*   **İlk Ekranlar:** Ahmet'in tasarımlarına dayanarak, `HomeScreen` (Ana Sayfa) ve `EMunicipalityScreen` (E-Belediye) için statik arayüzleri kodladım. `StandardAppBar` ve alt navigasyon barı gibi tekrar kullanılacak widget'ları `widgets` klasörü altında oluşturdum.
*   **Veri Servislerinin Başlangıcı:** Ceren, `http` paketi ile web sitesine ilk isteği gönderip `html` paketiyle gelen HTML içeriğini ayrıştırmak için ilk denemelerini yaptı. Özellikle haberler sayfasının yapısını çözerek, haber başlığı, resmi ve tarihini çekebilen bir fonksiyon yazdı. Bu, projenin en heyecan verici anlarından biriydi, çünkü artık canlı veriyle çalışmaya başlayabilecektik.

Bu iki haftanın sonunda, elimizde çalışan ama içi boş bir uygulama iskeleti ve haberleri web'den çekebilen bir servisimiz vardı.

---

### **Hafta 5-6: Gerçekleştirim (Ana Fonksiyonlar)**

#### **Süreç:**

Artık iskeletimiz hazırdı ve içini doldurma vakti gelmişti. Bu iki hafta, projenin en yoğun ve verimli geçtiği dönem oldu.

**4. Gerçekleştirim (Devam):**

*   **Ana Sayfa Dinamizmi:** Ceren'in hazırladığı haber servisini, benim kodladığım `HomeScreen` arayüzüne entegre ettik. Ana sayfada artık belediyenin sitesindeki son haberler dinamik olarak görünüyordu. Ahmet, `carousel_slider` paketini kullanarak ana sayfaya kayan bir banner alanı ekledi ve `smooth_page_indicator` ile şık bir sayfa göstergesi entegre etti.
*   **Nöbetçi Eczane Modülü:** Bu modül beklediğimizden biraz daha zorlayıcı oldu. Ceren, eczane verilerini çekerken sadece isim ve adresi değil, aynı zamanda telefon ve harita koordinatlarını da ayrıştırmayı başardı. Ben bu verileri alıp `pharmacy_screen.dart` içinde listeledim. Ahmet'in tasarladığı kart yapısı sayesinde her eczane için "Ara" ve "Haritada Göster" butonları ekledik. `url_launcher` paketi sayesinde bu butonlar, tek tıkla arama yapabiliyor veya harita uygulamasını açabiliyordu.
*   **Duyurular ve Meclis Kararları:** Ceren, haberlere benzer bir mantıkla `announcements_screen.dart` ve `meclis_kararlari_screen.dart` için veri çekme servislerini yazdı. Meclis kararları sayfasında, kararları yıllara göre gruplayarak akordiyon bir menü içinde sunduk. Bu, kullanıcıların aradıkları döneme ait kararlara kolayca ulaşmasını sağladı.
*   **Kod Kalitesi:** Bu süreçte `flutter_lints` paketinin önerilerine uyarak kod kalitemizi yüksek tutmaya çalıştık. Üçümüz de birbirimizin kodlarını gözden geçirerek (code review) olası hataları erken fark etmeye çalıştık.

Bu dönemin sonunda uygulama, sadece bir iskelet olmaktan çıkıp yaşayan, çalışan ve gerçek verilerle beslenen bir yapıya bürünmüştü.

---

### **Hafta 7-8: Gerçekleştirim (WebView ve Kalan Modüller) & Doğrulama**

#### **Süreç:**

Projenin ana özellikleri bitmişti. Geriye kalan, WebView gerektiren karmaşık sayfalar ve diğer küçük hizmetlerin entegrasyonuydu.

**4. Gerçekleştirim (Son Dokunuşlar):**

*   **WebView Entegrasyonları:** "Kent Rehberi" ve "E-İmar" gibi sayfalar, belediyenin web sitesinde zaten interaktif harita servisleri olarak sunuluyordu. Bu servisleri sıfırdan yazmak yerine, `webview_flutter` paketini kullanarak doğrudan uygulama içine gömdük. Bu sayede hem zamandan kazandık hem de kullanıcıları uygulamadan çıkarmamış olduk. `CityGuideScreen` ve `EImarScreen` bu şekilde hayata geçti. WebView'ların yüklenirken boş görünmemesi için Ahmet, şık yüklenme animasyonları tasarladı.
*   **Vefat Edenler Modülü:** Ceren, `vefat_edenler_screen.dart` için web sitesindeki tablodan veri çeken servisi tamamladı. Bu modülde isim, tarih, defin yeri ve taziye yeri gibi detaylı bilgileri ayrıştırarak, arayüzde düzenli bir şekilde listeledik.
*   **Dış Linkler:** "Online Ödeme" ve "Kütüphane Katalog" gibi doğrudan belediyenin farklı alt alan adlarına giden hizmetler için `url_launcher` kullanarak bu sayfaları kullanıcının varsayılan tarayıcısında açmasını sağladık. Bu, güvenlik ve kullanım kolaylığı açısından en mantıklı yaklaşımdı.

**5. Yazılım Doğrulama ve Geçerleme (İlk Testler):**

*   **Birim ve Widget Testleri:** Kod tarafında, özellikle Ceren'in yazdığı veri ayrıştırma (parsing) fonksiyonları için basit birim testleri yazmaya başladık. Bu testler, belediyenin web sitesi yapısı değiştiğinde hataları hızlıca yakalamamıza yardımcı olacaktı. Ahmet de oluşturduğu custom widget'lar için birkaç temel widget testi yazdı.
*   **Manuel Testler:** Uygulamayı farklı ekran boyutlarındaki Android emülatörlerinde çalıştırarak ilk manuel testlerimizi yaptık. Menüler arası geçişleri, butonların çalışıp çalışmadığını, veri yükleme durumlarını kontrol ettik. Bu testler sırasında birkaç küçük görsel hata ve navigasyon sorunu tespit edip düzelttik.

Artık elimizde tüm özellikleri tamamlanmış, test edilmeye hazır bir beta sürümü vardı.

---

### **Hafta 9-10: Son Testler, Optimizasyon ve Raporlama**

#### **Süreç:**

Son iki haftayı tamamen projemizi cilalamaya, hataları ayıklamaya ve teslimata hazır hale getirmeye ayırdık.

**5. Yazılım Doğrulama ve Geçerleme (Kapsamlı Testler):**

*   **Kullanıcı Kabul Testleri:** Birkaç arkadaşımızdan uygulamayı kullanmalarını ve geri bildirimde bulunmalarını istedik. Bu sayede, bizim fark etmediğimiz bazı kullanım zorluklarını ve mantıksal hataları gördük. Örneğin, bir arkadaşımız haber detayından geri geldiğinde listenin en başına döndüğünü söyledi, bu gibi küçük ama can sıkıcı UX sorunlarını düzelttik.
*   **Hata ve İstisna Yönetimi:** İnternet bağlantısı olmadığında veya web sitesinden veri çekilemediğinde uygulamanın çökmemesi, bunun yerine kullanıcıya "İnternet bağlantınızı kontrol edin" veya "Veriler yüklenemedi, lütfen tekrar deneyin" gibi bilgilendirici mesajlar göstermesi için hata yönetimini (`try-catch` blokları, hata ekranları) güçlendirdik.
*   **Performans Optimizasyonu:** Uygulamanın açılış hızını ve listelerin kaydırma performansını iyileştirmek için birkaç optimizasyon yaptık. Özellikle resimlerin `loadingBuilder` kullanarak yüklenmesi, listelerin daha akıcı çalışmasını sağladı. Veri çekme işlemlerini `FutureBuilder` ve `setState` ile yöneterek arayüzün sadece gerektiğinde güncellenmesini sağladık.

**6. Kurulum ve Bakım Planlaması:**

*   **Kurulum:** Proje gereksinimleri doğrultusunda bir market yayını gerekmediği için, projeyi "kurulum" adımı olarak hocamızın ve araştırma görevlimizin yerel makinelerinde kolayca çalıştırabilmeleri için hazırladık. `README.md` dosyasını detaylı bir şekilde yazdık. Bu dosyada projenin ne olduğu, nasıl çalıştırılacağı ve proje yapısı hakkında bilgiler verdik.
*   **Bakım Politikası:** Projemizin en büyük zaafı, veri kaynağı olarak web scraping kullanmasıdır. Belediyenin web sitesinde yapılacak herhangi bir HTML yapısal değişikliği, uygulamamızın veri çeken modüllerinin bozulmasına neden olabilir. Bakım planımızda, bu durumu şu şekilde ele aldık:
    1.  **Periyodik Kontroller:** Ayda bir, sitenin ilgili sayfalarının HTML yapısının değişip değişmediği manuel olarak kontrol edilecek.
    2.  **Hata Raporlama Mekanizması (Varsayımsal):** Eğer uygulama yayınlansaydı, kullanıcıların "veri yüklenemiyor" hatası aldığında bunu raporlayabileceği basit bir mekanizma eklenirdi.
    3.  **Esnek Parser'lar:** Ceren'in yazdığı parsing kodlarını, küçük HTML değişikliklerinden etkilenmeyecek şekilde olabildiğince esnek tutmaya çalıştık (Örn: `id` yerine `class` seçiciler kullanmak).

Bu 10 haftalık süreç, ekip olarak bizim için harika bir öğrenme ve uygulama deneyimi oldu. Planlama aşamasından başlayarak, analiz, tasarım, kodlama, test ve son hazırlıklara kadar her adımda birlikte çalıştık. Ahmet'in tasarımları projeye ruh katarken, Ceren'in teknik becerisi projenin veri damarlarını oluşturdu. Ben de bu iki harika ekip arkadaşını koordine ederek ve projenin iskeletini sağlam tutarak süreci yönettim. Ortaya çıkan üründen ve ekip olarak gösterdiğimiz performanstan gurur duyuyoruz.
