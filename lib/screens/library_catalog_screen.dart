import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/standard_app_bar.dart';

class LibraryCatalogScreen extends StatelessWidget {
  const LibraryCatalogScreen({super.key});

  static const String catalogUrl = 'https://katalog.batman.bel.tr/yordam/';

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(catalogUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $catalogUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sayfa açılır açılmaz tarayıcıyı aç ve geri dön
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _launchUrl();
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tarayıcı açılamadı: $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    });

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
              Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tarayıcıda açılıyor...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _launchUrl();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tarayıcı açılamadı: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Tekrar Aç'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5F8E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      )),
            ],
          ),
        ),
      ),
    );
  }
}

