import 'package:flutter/material.dart';
import '../widgets/search_modal.dart';
import '../widgets/standard_app_bar.dart';
import 'announcements_screen.dart';
import 'pharmacy_screen.dart';
import 'city_guide_screen.dart';
import 'library_catalog_screen.dart';
import 'online_payment_screen.dart';
import 'online_services_screen.dart';
import 'e_imar_screen.dart';
import 'meclis_kararlari_screen.dart';
import 'vefat_edenler_screen.dart';
import 'batman_ulasim_screen.dart';
import 'nikah_islemleri_screen.dart';
import 'hayvan_sahiplenme_screen.dart';
import 'su_analiz_raporlari_screen.dart';
import 'contact_screen.dart';
import 'news_screen.dart';

class EMunicipalityScreen extends StatelessWidget {
  const EMunicipalityScreen({super.key});

  List<Map<String, dynamic>> _getAllServices() {
    return [
      {'title': 'Online Ödeme', 'icon': Icons.credit_card},
      {'title': 'Duyuru-İlan', 'icon': Icons.announcement},
      {'title': 'Kent Rehberi', 'icon': Icons.map},
      {'title': 'Online İşlemler', 'icon': Icons.language},
      {'title': 'E-İmar', 'icon': Icons.inbox},
      {'title': 'Meclis Kararları', 'icon': Icons.description},
      {'title': 'Batman Ulaşım', 'icon': Icons.directions_bus},
      {'title': 'Kütüphane Katalog', 'icon': Icons.menu_book},
      {'title': 'Nöbetçi Eczane', 'icon': Icons.local_pharmacy},
      {'title': 'Vefat Edenler', 'icon': Icons.person_off},
      {'title': 'İstek & Şikayet', 'icon': Icons.home},
      {'title': 'Nikah İşlemleri', 'icon': Icons.not_listed_location},
      {'title': 'Hayvan Sahiplenme', 'icon': Icons.home},
      {'title': 'Su Analiz Raporları', 'icon': Icons.water_drop},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final services = _getAllServices();

    return Scaffold(
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
          child: Column(
            children: [
              StandardAppBar(showBackButton: true),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'E-BELEDİYE İŞLEMLERİ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return _buildServiceItem(
                      context,
                      services[index]['title'] as String,
                      services[index]['icon'] as IconData,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF21659E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
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
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Color(0xFF21659E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        onTap: (index) {
          if (index == 0) {
            // Ana sayfaya dön
            Navigator.pop(context);
          } else if (index == 1) {
            // Zaten E-Belediye'deyiz, hiçbir şey yapma
          } else if (index == 2) {
            // Arama butonuna tıklandığında modal bottom sheet aç
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchModal(),
            );
          } else if (index == 3) {
            // Güncel butonuna tıklandığında NewsScreen'e git
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen()),
            );
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
                color: Color(0xFF21659E),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, color: Colors.white, size: 28),
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
