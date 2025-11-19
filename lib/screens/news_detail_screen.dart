import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsUrl;
  final String newsTitle;

  const NewsDetailScreen({
    super.key,
    required this.newsUrl,
    required this.newsTitle,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _newsDetail = {};

  @override
  void initState() {
    super.initState();
    _loadNewsDetail();
  }

  Future<void> _loadNewsDetail() async {
    try {
      final response = await http.get(
        Uri.parse(widget.newsUrl),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        
        // Haber detay bilgileri
        try {
          // Başlık
          final titleElement = document.querySelector('.page-banner-title h3');
          final title = titleElement?.text.trim() ?? widget.newsTitle;
          
          // Tarih
          final dateElement = document.querySelector('.news-details-box-date a');
          final date = dateElement?.text.trim() ?? '';
          
          // Ana görsel
          final imageElement = document.querySelector('.news-details-box-image img');
          final imageUrl = imageElement?.attributes['src'] ?? '';
          final fullImageUrl = imageUrl.startsWith('http') 
              ? imageUrl 
              : 'https://www.batman.bel.tr$imageUrl';
          
          // Galeri görselleri - İçerikten ÖNCE al (çünkü sonra sileceğiz)
          final galleryElements = document.querySelectorAll('.havlightbox-gallery a');
          
          // İçerik - Tüm paragrafları al
          final contentBox = document.querySelector('.news-details-content-box');
          String content = '';
          
          if (contentBox != null) {
            // İlk h4 başlığını atla (zaten title'da var)
            final h4 = contentBox.querySelector('h4');
            if (h4 != null) {
              h4.remove();
            }
            
            // <hr> ve sonrasını kaldır (haber görselleri kısmı)
            final hr = contentBox.querySelector('hr');
            if (hr != null) {
              var node = hr;
              while (node.nextElementSibling != null) {
                node.nextElementSibling!.remove();
              }
              hr.remove();
            }
            
            // Kalan içeriği al - HTML decode ile birlikte
            content = contentBox.text
                .trim()
                .replaceAll(RegExp(r'\s+'), ' ') // Çoklu boşlukları tek boşluğa indir
                .replaceAll(RegExp(r'\n\s*\n'), '\n\n'); // Paragraf aralarını düzenle
          }
          
          // Galeri görsellerini listeye ekle
          final List<String> galleryImages = [];
          for (var element in galleryElements) {
            final href = element.attributes['href'] ?? '';
            if (href.isNotEmpty) {
              final fullUrl = href.startsWith('http') 
                  ? href 
                  : 'https://www.batman.bel.tr$href';
              galleryImages.add(fullUrl);
            }
          }

          setState(() {
            _newsDetail = {
              'title': title,
              'date': date,
              'image': fullImageUrl,
              'content': content,
              'gallery': galleryImages,
            };
            _isLoading = false;
          });
        } catch (e) {
          debugPrint('Parse hatası: $e');
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('Haber detayı yüklenirken bir hata oluştu.');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Haber detayı yüklenirken bir hata oluştu.');
      }
    } catch (e) {
      debugPrint('Haber detayı yüklenirken hata: $e');
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
              _loadNewsDetail();
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
              _buildAppBar(context),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2B5F8E),
                        ),
                      )
                    : _newsDetail.isEmpty
                        ? _buildErrorView()
                        : _buildNewsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF2B5F8E), size: 24),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Haber Detayı',
                style: TextStyle(
                  color: Color(0xFF2B5F8E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.share, color: Color(0xFF2B5F8E), size: 24),
              onPressed: () => _shareNews(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Haber detayı yüklenemedi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadNewsDetail();
            },
            icon: Icon(Icons.refresh),
            label: Text('Tekrar Dene'),
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

  Widget _buildNewsContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ana görsel
          if (_newsDetail['image'] != null && _newsDetail['image'].isNotEmpty)
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Image.network(
                _newsDetail['image'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.image, size: 80, color: Colors.grey),
                  );
                },
              ),
            ),
          
          // İçerik
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarih
                if (_newsDetail['date'] != null && _newsDetail['date'].isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF21659E), Color(0xFF3A7BB0)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          _newsDetail['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: 16),
                
                // Başlık
                Text(
                  _newsDetail['title'] ?? widget.newsTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B5F8E),
                    height: 1.3,
                  ),
                ),
                
                SizedBox(height: 20),
                
                // İçerik
                if (_newsDetail['content'] != null && _newsDetail['content'].isNotEmpty)
                  Text(
                    _newsDetail['content'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                
                // Galeri
                if (_newsDetail['gallery'] != null && (_newsDetail['gallery'] as List).isNotEmpty) ...[
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFF2B5F8E)),
                        SizedBox(width: 8),
                        Text(
                          'Haber Görselleri',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B5F8E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: (_newsDetail['gallery'] as List).length,
                    itemBuilder: (context, index) {
                      final imageUrl = (_newsDetail['gallery'] as List)[index];
                      return GestureDetector(
                        onTap: () => _openImage(imageUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.grey.shade300,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(Icons.image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                
                SizedBox(height: 30),
                
                // Web sitesinde aç butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openInBrowser(),
                    icon: Icon(Icons.open_in_browser),
                    label: Text('Web Sitesinde Aç'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B5F8E),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openImage(String imageUrl) async {
    final Uri launchUri = Uri.parse(imageUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInBrowser() async {
    final Uri launchUri = Uri.parse(widget.newsUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareNews() async {
    // Basit bir paylaşma - URL'yi kopyalama veya paylaşma
    final Uri launchUri = Uri.parse(widget.newsUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }
}
