import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/app_drawer.dart';
import '../widgets/search_modal.dart';
import '../widgets/standard_app_bar.dart';
import 'e_municipality_screen.dart';
import 'news_screen.dart';
import 'pharmacy_screen.dart';
import 'announcements_screen.dart';
import 'city_guide_screen.dart';
import 'library_catalog_screen.dart';
import 'online_payment_screen.dart';
import 'online_services_screen.dart';
import 'e_imar_screen.dart';
import 'meclis_kararlari_screen.dart';
import 'vefat_edenler_screen.dart';
import 'baskan_screen.dart';
import 'batman_ulasim_screen.dart';
import 'nikah_islemleri_screen.dart';
import 'hayvan_sahiplenme_screen.dart';
import 'su_analiz_raporlari_screen.dart';
import 'contact_screen.dart';
import 'etkinlik_stories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _carouselIndex = 0;
  int _servicesPageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final PageController _servicesPageController = PageController();
  bool _isLoadingNews = true;
  List<Map<String, dynamic>> _homeNews = [];
  String? _etkinlikCircleImageUrl;
  List<Map<String, dynamic>> _carouselItems = [];
  bool _isLoadingCarousel = true;

  @override
  void initState() {
    super.initState();
    _loadHomeNews();
    _loadEtkinlikCircleImage();
    _seedCarouselItemsIfEmpty();
    _listenToCarouselItems();
  }

  void _listenToCarouselItems() {
    FirebaseFirestore.instance
        .collection('carouselItems')
        .orderBy('id')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _carouselItems = snapshot.docs.map((doc) => doc.data()).toList();
          _isLoadingCarousel = false;
        });
      }
    }, onError: (error) {
      debugPrint('Carousel items dinleme hatası: $error');
      if (mounted) {
        setState(() {
          _isLoadingCarousel = false;
        });
      }
    });
  }

  Future<void> _seedCarouselItemsIfEmpty() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('carouselItems')
          .limit(1)
          .get();
      if (snap.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        final col = FirebaseFirestore.instance.collection('carouselItems');
        batch.set(col.doc('1'), {
          'id': '1',
          'title': 'Yutong Taş Oyma Sanatı',
          'imageUrl': '',
        });
        batch.set(col.doc('2'), {
          'id': '2',
          'title': 'Web Projesi',
          'imageUrl': '',
        });
        batch.set(col.doc('3'), {
          'id': '3',
          'title': 'Kültür Etkinlikleri',
          'imageUrl': '',
        });
        await batch.commit();
        debugPrint('Carousel items seeded successfully');
      }
    } catch (e) {
      debugPrint('Carousel items seed hatası: $e');
    }
  }

  @override
  void dispose() {
    _servicesPageController.dispose();
    super.dispose();
  }

  Future<void> _loadEtkinlikCircleImage() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('etkinlikler')
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() {
          _etkinlikCircleImageUrl = snap.docs.first.data()['imageUrl'] as String?;
        });
      }
    } catch (e) {
      debugPrint('Etkinlik circle görseli yükleme hatası: $e');
    }
  }


  Future<void> _loadHomeNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/haber'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<Map<String, dynamic>> newsList = [];
        final cards = document.querySelectorAll('.blog-card');

        // İlk 4 haberi al
        for (var i = 0; i < cards.length && i < 4; i++) {
          final card = cards[i];
          try {
            final titleElement = card.querySelector('.blog-card-content h4 a');
            final title = titleElement?.text.trim() ?? '';
            
            final dateElement = card.querySelector('.blog-card-date a');
            final date = dateElement?.text.trim() ?? '';
            
            final imageElement = card.querySelector('.blog-card-image img');
            final imageUrl = imageElement?.attributes['src'] ?? '';
            final fullImageUrl = imageUrl.startsWith('http') 
                ? imageUrl 
                : 'https://www.batman.bel.tr$imageUrl';

            if (title.isNotEmpty) {
              newsList.add({
                'title': title,
                'date': date,
                'image': fullImageUrl,
              });
            }
          } catch (e) {
            debugPrint('Haber parse hatası: $e');
            continue;
          }
        }

        setState(() {
          _homeNews = newsList;
          _isLoadingNews = false;
        });
      } else {
        setState(() {
          _isLoadingNews = false;
        });
      }
    } catch (e) {
      debugPrint('Ana sayfa haberleri yüklenirken hata: $e');
      setState(() {
        _isLoadingNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF21659E),
              Color(0xFF1A5185),
              Color(0xFF3A7BB0),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: _currentIndex == 0 ? _buildHomePage() : _buildOtherPages(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomePage() {
    return Builder(
      builder: (context) {
        return Column(
          children: [
            StandardAppBar(showBackButton: false),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoriesSection(),
                SizedBox(height: 20),
                _buildCarousel(),
                SizedBox(height: 25),
                _buildServicesSection(),
                SizedBox(height: 30),
                _buildNewsSection(),
                SizedBox(height: 20),
              ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildStoriesSection() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildStoryItem(
            'Başkan',
            Icons.account_circle,
            hasImage: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BaskanScreen()),
              );
            },
          ),
          SizedBox(width: 16),
          _buildStoryItem(
            'Haberler',
            Icons.article,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreen()),
              );
            },
          ),
          SizedBox(width: 16),
          _buildStoryItem(
            'Etkinlikler',
            Icons.event,
            networkImageUrl: _etkinlikCircleImageUrl,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EtkinlikStoriesScreen()),
              );
            },
          ),
          SizedBox(width: 16),
          _buildStoryItem(
            'Konum',
            Icons.location_on,
            onTap: () async {
              const url = 'https://maps.app.goo.gl/bqqTivtC2vodupSP8';
              final ok = await launchUrlString(url, mode: LaunchMode.externalApplication);
              if (!ok) {
                debugPrint('URL açılamadı: $url');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(
    String label,
    IconData icon, {
    bool hasImage = false,
    String? networkImageUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF833AB4),
                  Color(0xFFFD1D1D),
                  Color(0xFFFCAF45),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF21659E),
                      Color(0xFF3A7BB0),
                    ],
                  ),
                ),
                child: hasImage
                    ? ClipOval(
                        child: Image.asset(
                          'assets/images/mayor.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 32,
                            );
                          },
                        ),
                      )
                    : (networkImageUrl != null && networkImageUrl.isNotEmpty)
                        ? ClipOval(
                            child: Image.network(
                              networkImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 32,
                                );
                              },
                            ),
                          )
                        : Icon(
                            icon,
                            color: Colors.white,
                            size: 32,
                          ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final allServices = _getAllServices();
    final servicesPerPage = 8;
    final totalPages = (allServices.length / servicesPerPage).ceil();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIK KULLANILAN HİZMETLER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EMunicipalityScreen()),
                  );
                },
                child: Text(
                  'TÜMÜ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildServicesPageView(allServices, servicesPerPage, totalPages),
          SizedBox(height: 16),
          _buildServicesPageIndicator(totalPages),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    if (_isLoadingCarousel) {
      return SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_carouselItems.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _carouselItems.length,
          itemBuilder: (context, index, realIndex) {
            final data = _carouselItems[index];
            final title = (data['title'] ?? '') as String;
            final imageUrl = (data['imageUrl'] ?? '') as String;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1B8A5A),
                        Color(0xFF2FAB7F),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                );
              },
              options: CarouselOptions(
                height: 180,
                viewportFraction: 0.85,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enableInfiniteScroll: _carouselItems.length > 1,
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                pauseAutoPlayOnTouch: true,
                pauseAutoPlayOnManualNavigate: true,
                onPageChanged: (index, reason) {
                  if (mounted) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            AnimatedSmoothIndicator(
              activeIndex: _carouselIndex,
              count: _carouselItems.length,
              effect: WormEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: Colors.white,
                dotColor: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HABERLER & DUYURULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsScreen()),
                  );
                },
                child: Text(
                  'TÜMÜ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        _isLoadingNews
            ? SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : _homeNews.isEmpty
                ? SizedBox(
                    height: 220,
                    child: Center(
                      child: Text(
                        'Haberler yüklenemedi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _homeNews.length,
                      itemBuilder: (context, index) {
                        final news = _homeNews[index];
                        return _buildNewsCard(
                          news['title'] as String,
                          news['date'] as String,
                          news['image'] as String,
                          index,
                        );
                      },
                    ),
                  ),
      ],
    );
  }


  Widget _buildNewsCard(String title, String date, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsScreen()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Color(0xFF2B5F8E),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF2B5F8E),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllServices() {
    return [
      {'title': 'Online Ödeme', 'icon': Icons.credit_card},
      {'title': 'Duyuru-İlan', 'icon': Icons.announcement},
      {'title': 'Kent Rehberi', 'icon': Icons.map},
      {'title': 'Online İşlemler', 'icon': Icons.language},
      {'title': 'E-İmar', 'icon': Icons.inbox},
      {'title': 'Meclis Kararları', 'icon': Icons.description},
      {'title': 'Batman Ulaşım', 'icon': Icons.directions_bus},
      {'title': 'Kütüphane\nKatalog', 'icon': Icons.menu_book},
      {'title': 'Nöbetçi\nEczane', 'icon': Icons.local_pharmacy},
      {'title': 'Vefat Edenler', 'icon': Icons.person_off},
      {'title': 'İstek & Şikayet', 'icon': Icons.home},
      {'title': 'Nikah İşlemleri', 'icon': Icons.not_listed_location},
      {'title': 'Hayvan Sahiplenme', 'icon': Icons.home},
      {'title': 'Su Analiz Raporları', 'icon': Icons.water_drop},
    ];
  }

  Widget _buildServicesPageView(List<Map<String, dynamic>> allServices, int servicesPerPage, int totalPages) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _servicesPageController,
        onPageChanged: (index) {
          setState(() {
            _servicesPageIndex = index;
          });
        },
        itemCount: totalPages,
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * servicesPerPage;
          final endIndex = (startIndex + servicesPerPage > allServices.length)
              ? allServices.length
              : startIndex + servicesPerPage;
          final pageServices = allServices.sublist(startIndex, endIndex);
          
          return _buildServicesGrid(pageServices);
        },
      ),
    );
  }

  Widget _buildServicesPageIndicator(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _servicesPageIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _servicesPageIndex == index 
                ? Colors.white 
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildServicesGrid(List<Map<String, dynamic>> services) {

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: services.length > 8 ? 8 : services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(
          services[index]['title'] as String,
          services[index]['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildServiceCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Kent Rehberi sayfasına yönlendirme
        if (title.contains('Kent Rehberi')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CityGuideScreen()),
          );
        }
        // Kütüphane Katalog sayfasına yönlendirme
        else if (title.contains('Kütüphane') && title.contains('Katalog')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LibraryCatalogScreen()),
          );
        }
        // Online Ödeme sayfasına yönlendirme
        else if (title.contains('Online') && title.contains('Ödeme')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlinePaymentScreen()),
          );
        }
        // Online İşlemler sayfasına yönlendirme
        else if (title.contains('Online') && title.contains('İşlemler')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnlineServicesScreen()),
          );
        }
        // E-İmar sayfasına yönlendirme
        else if (title.contains('E-İmar')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EImarScreen()),
          );
        }
        // Meclis Kararları sayfasına yönlendirme
        else if (title.contains('Meclis') && title.contains('Kararları')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MeclisKararlariScreen()),
          );
        }
        // Vefat Edenler sayfasına yönlendirme
        else if (title.contains('Vefat') && title.contains('Edenler')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VefatEdenlerScreen()),
          );
        }
        // Batman Ulaşım sayfasına yönlendirme
        else if (title.contains('Batman') && title.contains('Ulaşım')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BatmanUlasimScreen()),
          );
        }
        // Nöbetçi Eczane sayfasına yönlendirme
        else if (title.contains('Nöbetçi') || title.contains('Eczane')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PharmacyScreen()),
          );
        } 
        // Duyuru-İlan sayfasına yönlendirme
        else if (title.contains('Duyuru') || title.contains('İlan')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnnouncementsScreen()),
          );
        }
        // Nikah İşlemleri sayfasına yönlendirme
        else if (title.contains('Nikah') && title.contains('İşlemleri')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NikahIslemleriScreen()),
          );
        }
        // Hayvan Sahiplenme sayfasına yönlendirme
        else if (title.contains('Hayvan') && title.contains('Sahiplenme')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HayvanSahiplenmeScreen()),
          );
        }
        // Su Analiz Raporları sayfasına yönlendirme
        else if (title.contains('Su Analiz') || title.contains('Raporları')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SuAnalizRaporlariScreen()),
          );
        } 
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EMunicipalityScreen()),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF21659E),
              Color(0xFF3A7BB0),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherPages() {
    return Center(
      child: Text(
        ['Anasayfa', 'E-Belediye', 'Arama', 'Güncel', 'İletişim'][_currentIndex],
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Ana sayfaya dön
            setState(() {
              _currentIndex = 0;
            });
          } else if (index == 1) {
            // E-Belediye'ye git ve index'i güncelle
            setState(() {
              _currentIndex = 1;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EMunicipalityScreen()),
            ).then((_) {
              // Geri dönüldüğünde Ana Sayfa'ya ayarla
              setState(() {
                _currentIndex = 0;
              });
            });
          } else if (index == 2) {
            // Arama butonuna tıklandığında modal bottom sheet aç
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchModal(),
            );
          } else if (index == 3) {
            // Güncel butonuna tıklandığında NewsScreen'e git ve index'i güncelle
            setState(() {
              _currentIndex = 3;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen()),
            ).then((_) {
              // Geri dönüldüğünde Ana Sayfa'ya ayarla
              setState(() {
                _currentIndex = 0;
              });
            });
          } else if (index == 4) {
            // İletişim butonuna tıklandığında modal bottom sheet aç
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ContactScreen(),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Color(0xFF21659E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.desktop_windows),
            label: 'E-Belediye',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF21659E),
                    Color(0xFF3A7BB0),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF21659E).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 28),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Güncel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'İletişim',
          ),
        ],
      ),
    );
  }
}
