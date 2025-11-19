import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';
import '../models/announcement.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final String announcementUrl;
  final String announcementTitle;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementUrl,
    required this.announcementTitle,
  });

  @override
  State<AnnouncementDetailScreen> createState() => _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  bool _isLoading = true;
  AnnouncementDetail? _announcementDetail;

  @override
  void initState() {
    super.initState();
    _loadAnnouncementDetail();
  }

  Future<void> _loadAnnouncementDetail() async {
    try {
      final response = await http.get(
        Uri.parse(widget.announcementUrl),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        try {
          // Başlık
          final titleElement = document.querySelector('.page-banner-title h3');
          final title = titleElement?.text.trim() ?? widget.announcementTitle;

          // Tarih
          final dateElement = document.querySelector('.portfolio-details-content-title span');
          final date = dateElement?.text.trim() ?? '';

          // İçerik
          final contentElement = document.querySelector('.portfolio-details-content-text');
          String content = '';
          if (contentElement != null) {
            content = contentElement.text
                .trim()
                .replaceAll(RegExp(r'\s+'), ' ')
                .replaceAll(RegExp(r'\n\s*\n'), '\n\n');
          }

          // Dökümanlar
          final documentElements = document.querySelectorAll('.sidebar-widget-list-inner ul li a');
          final List<Document> documents = [];

          for (var element in documentElements) {
            final docTitle = element.text.trim();
            var docUrl = element.attributes['href'] ?? '';

            // URL'yi tam yap
            if (docUrl.isNotEmpty && !docUrl.startsWith('http')) {
              docUrl = 'https://www.batman.bel.tr$docUrl';
            }

            if (docTitle.isNotEmpty && docUrl.isNotEmpty) {
              // İkonu kaldır
              final cleanTitle = docTitle.replaceAll(RegExp(r'\s*$'), '');
              documents.add(Document(
                title: cleanTitle,
                url: docUrl,
              ));
            }
          }

          setState(() {
            _announcementDetail = AnnouncementDetail(
              title: title,
              date: date,
              content: content,
              documents: documents,
            );
            _isLoading = false;
          });
        } catch (e) {
          debugPrint('Parse hatası: $e');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Duyuru detayı yüklenirken hata: $e');
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
              _buildAppBar(context),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2B5F8E),
                        ),
                      )
                    : _announcementDetail == null
                        ? _buildErrorView()
                        : _buildContent(),
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
                'Duyuru Detayı',
                style: TextStyle(
                  color: Color(0xFF2B5F8E),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.share, color: Color(0xFF2B5F8E), size: 24),
              onPressed: () => _shareAnnouncement(),
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
            'Duyuru detayı yüklenemedi',
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
              _loadAnnouncementDetail();
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

  Widget _buildContent() {
    if (_announcementDetail == null) return SizedBox();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Duyuru Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.campaign, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'RESMİ DUYURU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Tarih
            if (_announcementDetail!.date.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 14, color: Color(0xFF2B5F8E)),
                    SizedBox(width: 6),
                    Text(
                      _announcementDetail!.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2B5F8E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            // Başlık
            Text(
              _announcementDetail!.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B5F8E),
                height: 1.3,
              ),
            ),

            SizedBox(height: 20),

            Divider(color: Colors.grey.shade300, thickness: 1),

            SizedBox(height: 20),

            // İçerik
            if (_announcementDetail!.content.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  _announcementDetail!.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),

            // Dökümanlar
            if (_announcementDetail!.documents.isNotEmpty) ...[
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.folder_open, color: Color(0xFF2B5F8E)),
                    SizedBox(width: 8),
                    Text(
                      'Dökümanlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B5F8E),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              ...List.generate(
                _announcementDetail!.documents.length,
                (index) {
                  final doc = _announcementDetail!.documents[index];
                  return _buildDocumentCard(doc);
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
    );
  }

  Widget _buildDocumentCard(Document doc) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openDocument(doc.url),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red.shade700,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B5F8E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'PDF Döküman',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.download,
                  color: Color(0xFF2B5F8E),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openDocument(String url) async {
    final Uri launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openInBrowser() async {
    final Uri launchUri = Uri.parse(widget.announcementUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareAnnouncement() async {
    final Uri launchUri = Uri.parse(widget.announcementUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }
}
