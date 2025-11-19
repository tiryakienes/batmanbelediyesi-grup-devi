import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // İLETİŞİM Başlığı
                  Text(
                    'İLETİŞİM',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF21659E),
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 20),
                  // İletişim Kartları
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactCard(
                          'İLETİŞİM\nMERKEZİ',
                          Icons.contact_support,
                          Color(0xFFE91E63),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildContactCard(
                          'WHATSAPP\nDESTEK HATTI',
                          Icons.chat,
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactCard(
                          'HİZMET\nBİNALARI',
                          Icons.business,
                          Color(0xFF673AB7),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildContactCard(
                          'ULAŞIM\nBİLGİLERİ',
                          Icons.alt_route,
                          Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // SOSYAL MEDYA Başlığı
                  Text(
                    'SOSYAL MEDYA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF21659E),
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Sosyal Medya Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: Color(0xFF1877F2),
                        onTap: () {
                          _launchURL('https://www.facebook.com/btmnbld');
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.camera_alt,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFCAF45),
                            Color(0xFFFF5E5E),
                            Color(0xFFE1306C),
                            Color(0xFFC13584),
                            Color(0xFF833AB4),
                          ],
                        ),
                        onTap: () {
                          _launchURL('https://www.instagram.com/btmnbld');
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.play_arrow,
                        color: Color(0xFFFF0000),
                        onTap: () {
                          _launchURL('https://www.youtube.com/@BatmanBelediyesiWebTv');
                        },
                      ),
                      _buildSocialButton(
                        icon: Icons.close,
                        color: Colors.black,
                        onTap: () {
                          _launchURL('https://x.com/btmnbld');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // Ayırıcı çizgi
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF21659E),
                          Color(0xFF3A7BB0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  // E-POSTA
                  _buildInfoRow(
                    icon: Icons.email,
                    title: 'E-POSTA',
                    content: 'bilgi@batman.bel.tr',
                  ),
                  SizedBox(height: 20),
                  // TELEFON
                  _buildInfoRow(
                    icon: Icons.phone,
                    title: 'TELEFON',
                    content: '0488 213 27 59',
                  ),
                  SizedBox(height: 20),
                  // ADRES
                  _buildInfoRow(
                    icon: Icons.location_on,
                    title: 'ADRES',
                    content: 'Şirinevler, Atatürk Blv. no:2',
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(String title, IconData icon, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Kart tıklama işlemi
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    Color? color,
    Gradient? gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF21659E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 5),
              Text(
                content,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF21659E),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

