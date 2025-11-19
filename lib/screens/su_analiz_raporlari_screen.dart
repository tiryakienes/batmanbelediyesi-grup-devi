import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/standard_app_bar.dart';

class SuAnalizRaporlariScreen extends StatelessWidget {
  const SuAnalizRaporlariScreen({super.key});

  // PDF raporları listesi
  final List<Map<String, String>> _raporlar = const [
    {
      'title': 'Analiz Raporu 1',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-1-523220250621033822.pdf',
    },
    {
      'title': 'Analiz Raporu 2',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-2-233720250621034202.pdf',
    },
    {
      'title': 'Analiz Raporu 3',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-3-582320250621034211.pdf',
    },
    {
      'title': 'Analiz Raporu 4',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-4-512020250621034219.pdf',
    },
    {
      'title': 'Analiz Raporu 5',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-5-329920250621034231.pdf',
    },
    {
      'title': 'Analiz Raporu 6',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-6-560720250621034239.pdf',
    },
    {
      'title': 'Analiz Raporu 7',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-7-337620250621034249.pdf',
    },
    {
      'title': 'Analiz Raporu 8',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-8-473320250621034301.pdf',
    },
    {
      'title': 'Analiz Raporu 9',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-9-221720250621034310.pdf',
    },
    {
      'title': 'Analiz Raporu 10',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-10-678820250621034317.pdf',
    },
    {
      'title': 'Analiz Raporu 11',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-11-786620250621034326.pdf',
    },
    {
      'title': 'Analiz Raporu 12',
      'url': 'https://www.batman.bel.tr/upload/dosya/duyuru/analiz-raporu-12-974720250621034333.pdf',
    },
  ];

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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Başlık ve açıklama kartı
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1976D2),
                                Color(0xFF2196F3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.water_drop,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'İçme Suyu',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Analiz Raporları',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.9),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Divider(color: Colors.white.withValues(alpha: 0.3)),
                              SizedBox(height: 12),
                              Text(
                                'Batman Belediyesi içme suyu analiz raporları aşağıda yer almaktadır.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Raporlar başlığı
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
                                'Su Analiz Raporları',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B5F8E),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2B5F8E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_raporlar.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // PDF listesi
                        ...List.generate(
                          _raporlar.length,
                          (index) {
                            final rapor = _raporlar[index];
                            return _buildPdfCard(
                              context,
                              rapor['title']!,
                              rapor['url']!,
                              index + 1,
                            );
                          },
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
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
          Icon(Icons.water_drop, color: Color(0xFF1976D2), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Su Analiz Raporları',
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

  Widget _buildPdfCard(BuildContext context, String title, String url, int number) {
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
          onTap: () => _openPdf(url),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // PDF ikonu
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
                // Başlık ve açıklama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B5F8E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.water_drop,
                            size: 12,
                            color: Colors.blue.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'İçme Suyu Analiz Raporu',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // İndir ikonu
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.download,
                    color: Color(0xFF2B5F8E),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPdf(String url) async {
    final Uri launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }
}

