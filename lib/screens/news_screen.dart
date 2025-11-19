import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'news_detail_screen.dart';
import 'announcement_detail_screen.dart';
import 'contact_screen.dart';
import 'e_municipality_screen.dart';
import '../widgets/search_modal.dart';
import '../widgets/standard_app_bar.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  bool _isLoadingAnnouncements = true;
  List<Map<String, dynamic>> _news = [];
  List<Map<String, dynamic>> _announcements = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadNews();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/haber'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<Map<String, dynamic>> newsList = [];

        // Haber kartlarını bul (.blog-card)
        final cards = document.querySelectorAll('.blog-card');

        for (var card in cards) {
          try {
            // Başlık
            final titleElement = card.querySelector('.blog-card-content h4 a');
            final title = titleElement?.text.trim() ?? '';
            
            // Haber detay linki
            final linkUrl = titleElement?.attributes['href'] ?? '';
            
            // Açıklama (description)
            final descElement = card.querySelector('.blog-card-content div p');
            final description = descElement?.text.trim() ?? '';
            
            // Tarih
            final dateElement = card.querySelector('.blog-card-date a');
            final date = dateElement?.text.trim() ?? '';
            
            // Resim
            final imageElement = card.querySelector('.blog-card-image img');
            final imageUrl = imageElement?.attributes['src'] ?? '';
            final fullImageUrl = imageUrl.startsWith('http') 
                ? imageUrl 
                : 'https://www.batman.bel.tr$imageUrl';

            if (title.isNotEmpty) {
              newsList.add({
                'title': title,
                'description': description,
                'date': date,
                'image': fullImageUrl,
                'url': linkUrl.startsWith('http') 
                    ? linkUrl 
                    : 'https://www.batman.bel.tr$linkUrl',
              });
            }
          } catch (e) {
            debugPrint('Haber kartı parse hatası: $e');
            continue;
          }
        }

        setState(() {
          _news = newsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Haberler yüklenirken bir hata oluştu.');
      }
    } catch (e) {
      debugPrint('Haberler yüklenirken hata: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('İnternet bağlantısını kontrol edin.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              _loadNews();
            },
            child: Text('Tekrar Dene'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              StandardAppBar(showBackButton: true),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNewsList(),
                    _buildAnnouncementsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF21659E),
              Color(0xFF3A7BB0),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        tabs: [
          Tab(text: 'HABERLER'),
          Tab(text: 'DUYURULAR'),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'Henüz haber bulunmamaktadır',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _loadNews();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF21659E),
              ),
              child: Text('Yenile'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        await _loadNews();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          return _buildNewsCard(_news[index]);
        },
      ),
    );
  }

  Future<void> _loadAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/duyuru-ilan'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<Map<String, dynamic>> announcementsList = [];

        // Duyuru kartlarını bul
        final cards = document.querySelectorAll('.blog-card');

        for (var card in cards) {
          try {
            // Başlık ve URL
            final titleElement = card.querySelector('.blog-card-content h4 a');
            final title = titleElement?.text.trim() ?? '';
            var url = titleElement?.attributes['href'] ?? '';

            // URL'yi tam yap
            if (url.isNotEmpty && !url.startsWith('http')) {
              url = 'https://www.batman.bel.tr$url';
            }

            // Tarih
            final dateElement = card.querySelector('.blog-card-date a');
            final date = dateElement?.text.trim() ?? '';

            // Görsel - Sabit duyuru görseli
            final imageUrl = 'https://www.batman.bel.tr/assets/image/bg/duyuru.jpg';

            if (title.isNotEmpty && url.isNotEmpty) {
              announcementsList.add({
                'title': title,
                'date': date,
                'url': url,
                'image': imageUrl,
              });
            }
          } catch (e) {
            debugPrint('Duyuru parse hatası: $e');
          }
        }

        setState(() {
          _announcements = announcementsList;
          _isLoadingAnnouncements = false;
        });
      } else {
        setState(() {
          _isLoadingAnnouncements = false;
        });
      }
    } catch (e) {
      debugPrint('Duyurular yüklenirken hata: $e');
      setState(() {
        _isLoadingAnnouncements = false;
      });
    }
  }

  Widget _buildAnnouncementsList() {
    if (_isLoadingAnnouncements) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (_announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64, color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'Henüz duyuru bulunmamaktadır',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoadingAnnouncements = true;
                });
                _loadAnnouncements();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF21659E),
              ),
              child: Text('Yenile'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoadingAnnouncements = true;
        });
        await _loadAnnouncements();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          return _buildAnnouncementCard(_announcements[index]);
        },
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> newsItem) {
    return GestureDetector(
      onTap: () => _openNewsDetail(newsItem['url'], newsItem['title']),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Resim
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade300,
                child: newsItem['image'] != null && newsItem['image'].isNotEmpty
                    ? Image.network(
                        newsItem['image'],
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
            // İçerik
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF21659E),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            newsItem['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF21659E),
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

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    return GestureDetector(
      onTap: () => _openAnnouncementDetail(announcement['url'], announcement['title']),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Resim
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade300,
                child: Image.network(
                  announcement['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.campaign,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            // İçerik
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF21659E),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            announcement['date'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF21659E),
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

  void _openNewsDetail(String url, String title) {
    if (url.isEmpty) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(
          newsUrl: url,
          newsTitle: title,
        ),
      ),
    );
  }

  void _openAnnouncementDetail(String url, String title) {
    if (url.isEmpty) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailScreen(
          announcementUrl: url,
          announcementTitle: title,
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
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Color(0xFF21659E),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        onTap: (index) {
          if (index == 0) {
            // Anasayfa'ya dön - tüm sayfaları kapat ve ana sayfaya dön
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            // E-Belediye sayfasına git - önce ana sayfaya dön, sonra E-Belediye'ye git
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EMunicipalityScreen()),
            );
          } else if (index == 2) {
            // Arama butonuna tıklandığında modal bottom sheet aç
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => SearchModal(),
            );
          } else if (index == 3) {
            // Zaten Güncel sayfasındayız, hiçbir şey yapma
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
