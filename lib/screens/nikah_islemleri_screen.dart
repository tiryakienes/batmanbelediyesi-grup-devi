import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/standard_app_bar.dart';

class NikahIslemleriScreen extends StatelessWidget {
  const NikahIslemleriScreen({super.key});

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
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(),
                      SizedBox(height: 16),
                      _buildRequiredDocumentsCard(),
                      SizedBox(height: 16),
                      _buildForeignersCard(),
                      SizedBox(height: 16),
                      _buildApplicationRulesCard(),
                    ],
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
          Icon(Icons.favorite, color: Color(0xFFE91E63), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Nikah İşlemleri',
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

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE91E63),
            Color(0xFFF06292),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'BATMAN BELEDİYESİ\nEVLENDİRME MEMURLUĞU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildInfoRow(Icons.location_on, 'Hürriyet Mahallesi Şerzan Kurt Parkı içinde'),
          SizedBox(height: 12),
          InkWell(
            onTap: () => _makePhoneCall('0488 231 27 77'),
            child: _buildInfoRow(Icons.phone, '0488 231 27 77', isClickable: true),
          ),
          SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, 'Hafta içi: 09:00-11:00 / 13:00-16:00'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isClickable = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
              decoration: isClickable ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredDocumentsCard() {
    return _buildSectionCard(
      title: 'GEREKLİ OLAN BELGELER',
      icon: Icons.description,
      color: Color(0xFF2B5F8E),
      children: [
        _buildBulletPoint('Aile Hekimliğinden fotoğraflı sağlık raporu'),
        _buildBulletPoint(
          'Nüfus Cüzdan Fotokopisi (Çiftlerin son medeni hali işlenmiş fotoğraflı nüfus cüzdanları, T.C Kimlik numarası olmayan ve yıpranmış nüfus cüzdanları kabul edilmemektedir)',
        ),
        _buildBulletPoint(
          'Beş (5) adet renkli vesikalık fotoğraf (Fotokopi fotoğraf kabul edilmemektedir. Verilecek fotoğrafların ön cepheden vesikalık, sivil giysilerle çekilmiş olması ve kişinin son halini göstermesi bakımından son altı ay içerisinde çekilmiş olması gerekir)',
        ),
        _buildBulletPoint(
          'Batman Evlendirme Memurluğu\'na evlilik müracaatları hafta içi her gün 09:00-11:00 ile 13:00-16:00 saatleri arasında kabul edilmektedir',
        ),
      ],
    );
  }

  Widget _buildForeignersCard() {
    return _buildSectionCard(
      title: 'YABANCILAR İÇİN EVLENME EHLİYET BELGESİ',
      icon: Icons.public,
      color: Color(0xFF4CAF50),
      children: [
        _buildBulletPoint('Doğum kayıt belgesi'),
        _buildBulletPoint('Bekarlık belgesi'),
        _buildBulletPoint('Pasaport'),
        SizedBox(height: 8),
        Text(
          'Bu belgeler yetkili makamlarca kişinin; adını, soyadını, anne-baba adı ile doğum tarihi ve doğum yerini medeni durumunu (evlenmesine engel halinin bulunup bulunmadığını) gösterir şekilde düzenlenmiş ve usulüne göre tasdik edilmiş olmalıdır.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        SizedBox(height: 12),
        _buildImportantNote('Belgelerin geçerlilik süresi 6 (altı) aydır'),
        _buildImportantNote('Pasaport ve vize süresinin dolmamış olması gerekir'),
      ],
    );
  }

  Widget _buildApplicationRulesCard() {
    return _buildSectionCard(
      title: 'EVLENME BAŞVURU KURALLARI',
      icon: Icons.rule,
      color: Color(0xFFFF9800),
      children: [
        _buildImportantNote(
          'On sekiz yaşını doldurmuş, mahkemece koruma altına alınmamış olan erkek ve kadın başka bir kimsenin rızası veya iznine bağlı olmaksızın evlenir.',
        ),
        SizedBox(height: 12),
        _buildBulletPoint(
          'Onyedi yaşını tamamlayan erkek ve kadın anne-baba izni, anne-baba yok ise vasi veya vesayet makamının izni ile evlenebilir',
        ),
        _buildBulletPoint(
          'Onaltı yaşını dolduran kadın ve erkek hakimin izni ile evlenebilir',
        ),
        _buildBulletPoint(
          'Onbeş yaşında olanlar hiçbir şekilde evlenemez',
        ),
        SizedBox(height: 12),
        Text(
          'VEKALET İLE MÜRACAAT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '4721 Sayılı Türk Medeni Kanunun 134. maddesinde: Birbiriyle evlenecek erkek ve kadın evlendirme memurluğuna birlikte başvururlar. Çiftlerin başvuru esnasında aynı yerde değillerse, evlenecek kişi müracaat işlemini vekil olarak atadığı kişi vasıtasıyla da yürütülebilir.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        SizedBox(height: 8),
        _buildImportantNote(
          'Noterden FOTOĞRAFLI ÖZEL VEKALETNAME düzenlenmesi ve bu vekaletnamede vekalet veren ile vekili ve evleneceği kişinin tam kimlik bilgileri ile nüfus cüzdan fotokopilerinin yer alması şarttır.',
        ),
        _buildImportantNote('Vekalet ile evlenme yapılamaz.'),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
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
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Color(0xFF2B5F8E),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote(String text) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.amber.shade800, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.5,
              ),
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
}

