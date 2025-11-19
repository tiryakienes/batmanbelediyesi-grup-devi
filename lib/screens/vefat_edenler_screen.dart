import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import '../models/vefat_eden.dart';
import '../widgets/standard_app_bar.dart';

class VefatEdenlerScreen extends StatefulWidget {
  const VefatEdenlerScreen({super.key});

  @override
  State<VefatEdenlerScreen> createState() => _VefatEdenlerScreenState();
}

class _VefatEdenlerScreenState extends State<VefatEdenlerScreen> {
  bool _isLoading = true;
  List<VefatEden> _vefatEdenler = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadVefatEdenler();
  }

  Future<void> _loadVefatEdenler() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/vefat-edenler'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<VefatEden> vefatList = [];

        // Table body'deki tüm satırları al
        final rows = document.querySelectorAll('#data-tablo tbody tr');

        for (var row in rows) {
          try {
            final cells = row.querySelectorAll('td');
            
            if (cells.length >= 7) {
              // Temel bilgiler
              final vefatTarihi = cells[0].text.trim();
              final isim = cells[1].text.trim();
              final dogumTarihi = cells[2].attributes['data-dt'] ?? cells[2].text.trim();
              final dogumYeri = cells[3].attributes['data-dy'] ?? cells[3].text.trim();
              final definYeri = cells[4].attributes['data-definy'] ?? cells[4].text.trim();
              final definTarihi = cells[5].attributes['data-defint'] ?? cells[5].text.trim();

              // Taziye bilgileri button'dan al
              final button = cells[6].querySelector('button');
              TaziyeBilgileri? taziyeBilgileri;
              
              if (button != null) {
                final cenazeYakini = button.attributes['data-cy'] ?? '';
                final cenazeYakiniTel = button.attributes['data-cy-tel'] ?? '';
                final taziyeYeri = button.attributes['data-ty'] ?? '';
                final taziyeTarihi = button.attributes['data-tt'] ?? '';

                if (cenazeYakini.isNotEmpty) {
                  taziyeBilgileri = TaziyeBilgileri(
                    cenazeYakini: cenazeYakini,
                    cenazeYakiniTel: cenazeYakiniTel,
                    taziyeYeri: taziyeYeri,
                    taziyeTarihi: taziyeTarihi,
                  );
                }
              }

              if (isim.isNotEmpty) {
                vefatList.add(VefatEden(
                  vefatTarihi: vefatTarihi,
                  isim: isim,
                  dogumTarihi: dogumTarihi,
                  dogumYeri: dogumYeri,
                  definYeri: definYeri,
                  definTarihi: definTarihi,
                  taziyeBilgileri: taziyeBilgileri,
                ));
              }
            }
          } catch (e) {
            debugPrint('Satır parse hatası: $e');
            continue;
          }
        }

        setState(() {
          _vefatEdenler = vefatList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Veriler yüklenemedi';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Vefat edenler yükleme hatası: $e');
      setState(() {
        _errorMessage = 'Bağlantı hatası oluştu';
        _isLoading = false;
      });
    }
  }

  void _showTaziyeDialog(VefatEden vefatEden) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TAZİYE BİLGİLERİ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B5F8E),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(height: 24),
              _buildDetailRow('İsim', vefatEden.isim),
              _buildDetailRow('Doğum Tarihi', vefatEden.dogumTarihi),
              _buildDetailRow('Doğum Yeri', vefatEden.dogumYeri),
              _buildDetailRow('Vefat Tarihi', vefatEden.vefatTarihi),
              _buildDetailRow('Defin Yeri', vefatEden.definYeri),
              _buildDetailRow('Defin Tarihi', vefatEden.definTarihi),
              if (vefatEden.taziyeBilgileri != null) ...[
                Divider(height: 24),
                _buildDetailRow('Cenaze Yakını', vefatEden.taziyeBilgileri!.cenazeYakini),
                _buildDetailRow('Yakın Telefonu', vefatEden.taziyeBilgileri!.cenazeYakiniTel),
                _buildDetailRow('Taziye Yeri', vefatEden.taziyeBilgileri!.taziyeYeri),
                _buildDetailRow('Taziye Tarihi', vefatEden.taziyeBilgileri!.taziyeTarihi),
              ],
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B5F8E),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('KAPAT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
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
          Icon(Icons.person_off, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vefat Edenler',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadVefatEdenler,
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
              'Vefat edenler listesi yükleniyor...',
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
              onPressed: _loadVefatEdenler,
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

    if (_vefatEdenler.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Vefat eden bulunamadı',
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
            Colors.white,
            Color(0xFFF5F5F5),
          ],
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _vefatEdenler.length,
        itemBuilder: (context, index) {
          return _buildVefatCard(_vefatEdenler[index]);
        },
      ),
    );
  }

  Widget _buildVefatCard(VefatEden vefatEden) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showTaziyeDialog(vefatEden),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF2B5F8E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person_off_outlined,
                      color: Color(0xFF2B5F8E),
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vefatEden.isim,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Vefat: ${vefatEden.vefatTarihi}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF2B5F8E),
                    size: 24,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.location_on_outlined,
                      vefatEden.dogumYeri,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.church_outlined,
                      vefatEden.definYeri,
                    ),
                  ),
                ],
              ),
              if (vefatEden.taziyeBilgileri != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B5F8E).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: Color(0xFF2B5F8E),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          vefatEden.taziyeBilgileri!.taziyeYeri,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2B5F8E),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[700],
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

