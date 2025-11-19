import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/announcement.dart';
import 'announcement_detail_screen.dart';
import '../widgets/standard_app_bar.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  bool _isLoading = true;
  List<Announcement> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/duyuru-ilan'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<Announcement> announcements = [];

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
              announcements.add(Announcement(
                title: title,
                date: date,
                url: url,
                imageUrl: imageUrl,
              ));
            }
          } catch (e) {
            debugPrint('Duyuru parse hatası: $e');
          }
        }

        setState(() {
          _announcements = announcements;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Duyurular yüklenirken hata: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              StandardAppBar(showBackButton: true),
              _buildPageTitle(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2B5F8E),
                        ),
                      )
                    : _announcements.isEmpty
                        ? _buildEmptyView()
                        : _buildAnnouncementsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.campaign, color: Color(0xFF2B5F8E), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Duyuru-İlan',
              style: TextStyle(
                color: Color(0xFF2B5F8E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'Henüz duyuru bulunmuyor',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadAnnouncements();
            },
            icon: Icon(Icons.refresh),
            label: Text('Yenile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2B5F8E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        await _loadAnnouncements();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return _buildAnnouncementCard(announcement);
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnouncementDetailScreen(
                  announcementUrl: announcement.url,
                  announcementTitle: announcement.title,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Görsel
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                  child: Stack(
                    children: [
                      Image.network(
                        announcement.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.campaign,
                              size: 60,
                              color: Color(0xFF2B5F8E).withValues(alpha: 0.3),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.campaign, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'DUYURU',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // İçerik
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tarih
                    if (announcement.date.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: Color(0xFF2B5F8E)),
                            SizedBox(width: 6),
                            Text(
                              announcement.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2B5F8E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 12),
                    
                    // Başlık
                    Text(
                      announcement.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B5F8E),
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Detay butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Detayları Gör',
                          style: TextStyle(
                            color: Color(0xFF2B5F8E),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFF2B5F8E),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
