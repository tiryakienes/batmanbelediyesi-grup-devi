import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';
import '../models/meclis_decision.dart';
import '../widgets/standard_app_bar.dart';

class MeclisKararlariScreen extends StatefulWidget {
  const MeclisKararlariScreen({super.key});

  @override
  State<MeclisKararlariScreen> createState() => _MeclisKararlariScreenState();
}

class _MeclisKararlariScreenState extends State<MeclisKararlariScreen> {
  bool _isLoading = true;
  List<MeclisDecisionYear> _decisionYears = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMeclisDecisions();
  }

  Future<void> _loadMeclisDecisions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.get(
        Uri.parse('https://www.batman.bel.tr/meclis-donemleri'),
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);
        final List<MeclisDecisionYear> yearsList = [];

        // Tüm accordion itemları bul
        final accordionItems = document.querySelectorAll('.accordian-box-item');

        for (var item in accordionItems) {
          try {
            // Yıl başlığını al
            final titleElement = item.querySelector('.accordian-title h5');
            final yearTitle = titleElement?.text.trim() ?? '';

            // Bu yıla ait kararları al
            final decisionLinks = item.querySelectorAll('.accordian-content ul li a');
            final List<MeclisDecision> decisions = [];

            for (var link in decisionLinks) {
              final decisionTitle = link.text.trim();
              final decisionUrl = link.attributes['href'] ?? '';
              
              if (decisionTitle.isNotEmpty && decisionUrl.isNotEmpty) {
                decisions.add(MeclisDecision(
                  title: decisionTitle,
                  url: decisionUrl.startsWith('http') 
                      ? decisionUrl 
                      : 'https://www.batman.bel.tr$decisionUrl',
                ));
              }
            }

            if (yearTitle.isNotEmpty && decisions.isNotEmpty) {
              yearsList.add(MeclisDecisionYear(
                year: yearTitle,
                decisions: decisions,
              ));
            }
          } catch (e) {
            debugPrint('Yıl parse hatası: $e');
            continue;
          }
        }

        setState(() {
          _decisionYears = yearsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Veriler yüklenemedi';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Meclis kararları yükleme hatası: $e');
      setState(() {
        _errorMessage = 'Bağlantı hatası oluştu';
        _isLoading = false;
      });
    }
  }

  Future<void> _openDecisionUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Link açılamadı'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Link açma hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Link açılırken hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          Icon(Icons.description, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Meclis Kararları',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadMeclisDecisions,
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
              'Meclis kararları yükleniyor...',
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
              onPressed: _loadMeclisDecisions,
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

    if (_decisionYears.isEmpty) {
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
              'Meclis kararı bulunamadı',
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
        itemCount: _decisionYears.length,
        itemBuilder: (context, index) {
          return _buildYearItem(_decisionYears[index]);
        },
      ),
    );
  }

  Widget _buildYearItem(MeclisDecisionYear yearData) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.only(bottom: 8),
          title: Text(
            yearData.year,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B5F8E),
            ),
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF2B5F8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 20,
            ),
          ),
          children: yearData.decisions.map((decision) {
            return _buildDecisionItem(decision);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDecisionItem(MeclisDecision decision) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          Icons.description,
          color: Color(0xFF2B5F8E),
          size: 24,
        ),
        title: Text(
          decision.title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: () => _openDecisionUrl(decision.url),
      ),
    );
  }
}

