import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/baskan.dart';
import '../widgets/standard_app_bar.dart';

class BaskanScreen extends StatefulWidget {
  const BaskanScreen({super.key});

  @override
  State<BaskanScreen> createState() => _BaskanScreenState();
}

class _BaskanScreenState extends State<BaskanScreen> {
  bool _isLoading = true;
  Baskan? _baskan;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadBaskanInfo();
  }

  Future<void> _loadBaskanInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/es-baskan'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        // Başkan fotoğrafı
        final imgElement = document.querySelector('.card-img-top');
        final fotoUrl = imgElement?.attributes['src'] ?? '';
        final fullFotoUrl = fotoUrl.startsWith('http')
            ? fotoUrl
            : 'https://www.batman.bel.tr$fotoUrl';

        // İsim ve ünvan
        final cardBody = document.querySelector('.card-body');
        final h2Element = cardBody?.querySelector('h2');
        final pElement = cardBody?.querySelector('p');
        
        final isim = h2Element?.text.trim() ?? '';
        final unvan = pElement?.text.trim() ?? '';

        // Özgeçmiş
        final cardFooter = document.querySelector('.card-footer');
        final ozgecmisContent = cardFooter?.querySelectorAll('p');
        String ozgecmis = '';
        
        if (ozgecmisContent != null && ozgecmisContent.length > 1) {
          // İlk p etiketi "Özgeçmiş" başlığı, geri kalanı içerik
          for (var i = 1; i < ozgecmisContent.length; i++) {
            // HTML etiketlerini temizle, sadece metni al
            String text = ozgecmisContent[i].text.trim();
            if (text.isNotEmpty) {
              ozgecmis += "$text\n\n";
            }
          }
        }

        if (isim.isNotEmpty) {
          setState(() {
            _baskan = Baskan(
              isim: isim,
              unvan: unvan,
              fotoUrl: fullFotoUrl,
              ozgecmis: ozgecmis,
            );
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Başkan bilgileri bulunamadı';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Veriler yüklenemedi';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Başkan bilgisi yükleme hatası: $e');
      setState(() {
        _errorMessage = 'Bağlantı hatası oluştu';
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
              _buildPageTitle(),
              Expanded(child: _buildBody()),
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
          Icon(Icons.account_circle, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Belediye Başkanı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadBaskanInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Başkan bilgileri yükleniyor...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadBaskanInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2B5F8E),
                foregroundColor: Colors.white,
              ),
              child: Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    if (_baskan == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Başkan bilgisi bulunamadı',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F3F6),
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Başkan Kartı
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Fotoğraf Bölümü
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 400,
                          maxHeight: 400,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFC9D9E9),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _baskan!.fotoUrl.isNotEmpty
                              ? Image.network(
                                  _baskan!.fotoUrl,
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
                                    return Container(
                                      height: 300,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 300,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  // İsim ve Ünvan Bölümü
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _baskan!.isim,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004080),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          _baskan!.unvan,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  // Özgeçmiş Bölümü
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Özgeçmiş',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004080),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _baskan!.ozgecmis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

