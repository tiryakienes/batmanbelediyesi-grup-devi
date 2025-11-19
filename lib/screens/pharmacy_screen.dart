import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../widgets/standard_app_bar.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _pharmacies = [];

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/nobetci-eczane'),
      );

      if (response.statusCode == 200) {
        // HTML'i parse et
        final document = html_parser.parse(response.body);
        final List<Map<String, dynamic>> pharmacies = [];

        // Eczane kartlarını bul
        final cards = document.querySelectorAll('.event-card');
        
        debugPrint('Toplam bulunan eczane kartı: ${cards.length}');

        for (var i = 0; i < cards.length; i++) {
          try {
            final card = cards[i];
            
            // Eczane adı ve ilçe
            final titleElement = card.querySelector('.event-card-title h4');
            final titleText = titleElement?.text.trim() ?? '';
            
            // "ECZANE ADI - İlçe" formatından ayır
            final parts = titleText.split(' - ');
            final name = parts.isNotEmpty ? parts[0].trim() : '';
            final district = parts.length > 1 ? parts[1].trim() : '';

            // Adres
            final addressElement = card.querySelector('.event-card-info ul li:first-child span');
            var address = addressElement?.text.trim() ?? '';
            // İkon metnini temizle
            address = address.replaceAll(RegExp(r'\s+'), ' ').trim();

            // Telefon - birden fazla yerde arayalım
            var phone = '';
            final phoneElement = card.querySelector('a[href^="tel:"]');
            if (phoneElement != null) {
              phone = phoneElement.text.trim();
            } else {
              // Alternatif: tel: içeren herhangi bir link
              final allLinks = card.querySelectorAll('a');
              for (var link in allLinks) {
                final href = link.attributes['href'] ?? '';
                if (href.contains('tel:')) {
                  phone = link.text.trim();
                  break;
                }
              }
            }
            
            // Telefon numarası yoksa, metin içinde ara
            if (phone.isEmpty) {
              final phoneText = card.querySelector('.event-card-info ul li:nth-child(2) span');
              if (phoneText != null) {
                phone = phoneText.text.trim();
              }
            }

            // Harita linki - birden fazla yöntemle ara
            String latitude = '';
            String longitude = '';
            
            // Yöntem 1: maps.google.com linki
            final mapElement = card.querySelector('a[href*="maps.google.com"]');
            var mapUrl = mapElement?.attributes['href'] ?? '';
            
            // Yöntem 2: Eğer bulunamazsa tüm linklerde ara
            if (mapUrl.isEmpty) {
              final allLinks = card.querySelectorAll('a');
              for (var link in allLinks) {
                final href = link.attributes['href'] ?? '';
                if (href.contains('maps') || href.contains('google')) {
                  mapUrl = href;
                  break;
                }
              }
            }
            
            // Koordinatları çıkar - daha esnek regex
            if (mapUrl.isNotEmpty) {
              // q= parametresinden sonra virgülle ayrılmış sayıları bul
              final coordMatch = RegExp(r'q=([\d.]+)[\s,]+([\d.]+)').firstMatch(mapUrl);
              if (coordMatch != null) {
                latitude = coordMatch.group(1)?.trim() ?? '';
                longitude = coordMatch.group(2)?.trim() ?? '';
                debugPrint('Koordinatlar bulundu: $latitude, $longitude');
              } else {
                // Alternatif: herhangi iki koordinat formatı
                final altMatch = RegExp(r'([\d.]{7,})[,\s]+([\d.]{7,})').firstMatch(mapUrl);
                if (altMatch != null) {
                  latitude = altMatch.group(1)?.trim() ?? '';
                  longitude = altMatch.group(2)?.trim() ?? '';
                  debugPrint('Alternatif koordinatlar bulundu: $latitude, $longitude');
                }
              }
            }

            // En az isim varsa eczaneyi ekle (diğer bilgiler eksik olabilir)
            if (name.isNotEmpty) {
              pharmacies.add({
                'name': name,
                'district': district.isEmpty ? 'Merkez' : district,
                'address': address.isEmpty ? 'Adres bilgisi yok' : address,
                'phone': phone.isEmpty ? 'Telefon bilgisi yok' : phone,
                'latitude': latitude,
                'longitude': longitude,
              });
              debugPrint('Eczane ${i + 1} eklendi: $name - $phone');
            } else {
              debugPrint('Eczane ${i + 1} atlandı: İsim bulunamadı');
            }
          } catch (e) {
            debugPrint('Kart ${i + 1} parse hatası: $e');
            continue;
          }
        }

        debugPrint('Toplam eklenen eczane: ${pharmacies.length}');

        setState(() {
          _pharmacies = pharmacies;
          _isLoading = false;
        });
      } else {
        // Hata durumunda
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Veriler yüklenirken bir hata oluştu.');
      }
    } catch (e) {
      debugPrint('Eczane verileri yüklenirken hata: $e');
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
              _loadPharmacies(); // Tekrar dene
            },
            child: Text('Tekrar Dene'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Sayfayı kapat
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
              StandardAppBar(showBackButton: true),
              _buildPageTitle(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2B5F8E),
                        ),
                      )
                    : _buildPharmacyList(),
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
          Icon(Icons.local_pharmacy, color: Color(0xFF2B5F8E), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nöbetçi Eczane',
                  style: TextStyle(
                    color: Color(0xFF2B5F8E),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }

  Widget _buildPharmacyList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _pharmacies.length,
      itemBuilder: (context, index) {
        return _buildPharmacyCard(_pharmacies[index]);
      },
    );
  }

  Widget _buildPharmacyCard(Map<String, dynamic> pharmacy) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2ECC71),
                  Color(0xFF27AE60),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_pharmacy,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pharmacy['district'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFF2B5F8E),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pharmacy['address'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Phone
                InkWell(
                  onTap: pharmacy['phone'] != 'Telefon bilgisi yok' 
                      ? () => _makePhoneCall(pharmacy['phone'])
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: pharmacy['phone'] != 'Telefon bilgisi yok'
                            ? Color(0xFF2B5F8E)
                            : Colors.grey,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        pharmacy['phone'],
                        style: TextStyle(
                          fontSize: 14,
                          color: pharmacy['phone'] != 'Telefon bilgisi yok'
                              ? Color(0xFF2B5F8E)
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                
                // Map button
                if (pharmacy['latitude'].isNotEmpty && pharmacy['longitude'].isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openMap(
                        pharmacy['latitude'],
                        pharmacy['longitude'],
                      ),
                      icon: Icon(Icons.map, size: 20),
                      label: Text('Haritada Görüntüle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2B5F8E),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 20, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(
                            'Konum bilgisi yok',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMap(String lat, String lng) async {
    final Uri launchUri = Uri.parse(
      'https://maps.google.com/maps?q=$lat,$lng',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }
}
