import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EtkinlikStoriesScreen extends StatefulWidget {
  const EtkinlikStoriesScreen({super.key});

  @override
  State<EtkinlikStoriesScreen> createState() => _EtkinlikStoriesScreenState();
}

class _EtkinlikStoriesScreenState extends State<EtkinlikStoriesScreen> {
  final PageController _pageController = PageController();
  int _current = 0;
  List<Map<String, dynamic>> _etkinlikler = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEtkinlikler();
  }

  void _loadEtkinlikler() {
    FirebaseFirestore.instance
        .collection('etkinlikler')
        .orderBy('id')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _etkinlikler = snapshot.docs.map((doc) => doc.data()).toList();
          _isLoading = false;
        });
      }
    }, onError: (error) {
      debugPrint('Etkinlikler yükleme hatası: $error');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_current < _etkinlikler.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_current > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _etkinlikler.isEmpty
                ? Center(
                    child: Text(
                      'Etkinlik bulunamadı',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _etkinlikler.length,
                        onPageChanged: (i) {
                          if (mounted) {
                            setState(() => _current = i);
                          }
                        },
                        itemBuilder: (context, index) {
                          final data = _etkinlikler[index];
                          final imageUrl = (data['imageUrl'] ?? '') as String;
                          final title = (data['title'] ?? '') as String;
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.black12,
                                            child: const Center(
                                              child: Icon(
                                                Icons.error_outline,
                                                color: Colors.white54,
                                                size: 48,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(color: Colors.black12),
                              ),
                              // Instagram-style tap areas
                              Row(
                                children: [
                                  // Left tap area - previous story
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _previousStory,
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(),
                                    ),
                                  ),
                                  // Right tap area - next story
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _nextStory,
                                      behavior: HitTestBehavior.translucent,
                                      child: Container(),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 24,
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(color: Colors.black87, blurRadius: 6),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 60,
                        right: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _etkinlikler.length,
                            (index) => Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: _current == index ? 1.0 : 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}