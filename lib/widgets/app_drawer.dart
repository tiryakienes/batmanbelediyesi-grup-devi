import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2B5F8E),
                    Color(0xFF3A7EBF),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.account_balance,
                            color: Colors.white,
                            size: 50,
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BATMAN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'BELEDİYESİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildMenuItem(
              context,
              icon: Icons.home,
              title: 'Anasayfa',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildExpandableMenuItem(
              context,
              icon: Icons.business,
              title: 'Kurumsal',
              children: [
                'Başkan',
                'Tarihçe',
                'Organizasyon Şeması',
                'Birimler',
                'Meclis Üyeleri',
              ],
            ),
            _buildExpandableMenuItem(
              context,
              icon: Icons.construction,
              title: 'Projeler',
              children: [
                'Devam Eden Projeler',
                'Tamamlanan Projeler',
                'Planlanan Projeler',
              ],
            ),
            _buildExpandableMenuItem(
              context,
              icon: Icons.palette,
              title: 'Kültür Sanat',
              children: [
                'Etkinlikler',
                'Kültür Merkezleri',
                'Kütüphane',
                'Konser & Tiyatro',
              ],
            ),
            _buildMenuItem(
              context,
              icon: Icons.article,
              title: 'Haberler',
              onTap: () {
                Navigator.pop(context);
                // Navigate to news
              },
            ),
            _buildExpandableMenuItem(
              context,
              icon: Icons.update,
              title: 'Güncel',
              children: [
                'Duyurular',
                'İhaleler',
                'Etkinlik Takvimi',
              ],
            ),
            _buildExpandableMenuItem(
              context,
              icon: Icons.computer,
              title: 'E-Belediye',
              children: [
                'Online Ödeme',
                'Başvuru Sorgulama',
                'İstek & Şikayet',
                'E-İmar',
              ],
            ),
            _buildMenuItem(
              context,
              icon: Icons.phone,
              title: 'İletişim',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF2B5F8E)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildExpandableMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> children,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: Color(0xFF2B5F8E)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      children: children.map((child) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 72, right: 16),
          title: Text(
            child,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // Handle sub-item tap
          },
        );
      }).toList(),
    );
  }
}
