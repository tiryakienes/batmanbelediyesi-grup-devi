import 'package:flutter/material.dart';
import '../services/chatbot_service.dart';
import '../screens/announcements_screen.dart';
import '../screens/online_payment_screen.dart';
import '../screens/city_guide_screen.dart';
import '../screens/online_services_screen.dart';
import '../screens/e_imar_screen.dart';
import '../screens/meclis_kararlari_screen.dart';
import '../screens/batman_ulasim_screen.dart';
import '../screens/library_catalog_screen.dart';
import '../screens/pharmacy_screen.dart';
import '../screens/vefat_edenler_screen.dart';
import '../screens/nikah_islemleri_screen.dart';
import '../screens/hayvan_sahiplenme_screen.dart';
import '../screens/su_analiz_raporlari_screen.dart';
import '../screens/news_screen.dart';
import '../screens/contact_screen.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatbotService _chatbotService = ChatbotService();
  
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    // Hoş geldin mesajını ekle
    _addBotMessage(
      'Merhaba, size nasıl yardımcı olabilirim?\n\nBu konular hakkında bilgi alabilirsiniz 😊',
      showServices: true,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Bot mesajı ekle
  void _addBotMessage(String message, {bool showServices = false}) {
    setState(() {
      _messages.add({
        'isUser': false,
        'message': message,
        'showServices': showServices,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  // Kullanıcı mesajı ekle
  void _addUserMessage(String message) {
    setState(() {
      _messages.add({
        'isUser': true,
        'message': message,
        'timestamp': DateTime.now(),
      });
      _showWelcome = false;
    });
    _scrollToBottom();
  }

  // AI'a mesaj gönder
  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addUserMessage(message);
    _messageController.clear();

    setState(() => _isLoading = true);

    final response = await _chatbotService.sendMessage(message);

    setState(() => _isLoading = false);

    if (response['success']) {
      _addBotMessage(response['message']);
      
      // Eğer hizmet tespit edildiyse, yönlendir
      if (response['service'] != null) {
        await Future.delayed(Duration(milliseconds: 800));
        _navigateToService(response['service']);
      }
    } else {
      _addBotMessage(response['message']);
    }
  }

  // Hizmete yönlendir
  void _navigateToService(String serviceName) {
    final route = ChatbotService.getServiceRoute(serviceName);
    if (route == null) return;

    Navigator.pop(context); // Modal'ı kapat

    Widget? screen;
    switch (route) {
      case 'announcements':
        screen = AnnouncementsScreen();
        break;
      case 'online_payment':
        screen = OnlinePaymentScreen();
        break;
      case 'city_guide':
        screen = CityGuideScreen();
        break;
      case 'online_services':
        screen = OnlineServicesScreen();
        break;
      case 'e_imar':
        screen = EImarScreen();
        break;
      case 'meclis_kararlari':
        screen = MeclisKararlariScreen();
        break;
      case 'batman_ulasim':
        screen = BatmanUlasimScreen();
        break;
      case 'library_catalog':
        screen = LibraryCatalogScreen();
        break;
      case 'pharmacy':
        screen = PharmacyScreen();
        break;
      case 'vefat_edenler':
        screen = VefatEdenlerScreen();
        break;
      case 'nikah_islemleri':
        screen = NikahIslemleriScreen();
        break;
      case 'hayvan_sahiplenme':
        screen = HayvanSahiplenmeScreen();
        break;
      case 'su_analiz_raporlari':
        screen = SuAnalizRaporlariScreen();
        break;
      case 'news':
        screen = NewsScreen();
        break;
      case 'contact':
        screen = ContactScreen();
        break;
    }

    if (screen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );
    }
  }

  // Scroll to bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF21659E),
            Color(0xFF1A5185),
            Color(0xFF3A7BB0),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 10),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy,
                    color: Color(0xFF21659E),
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batman Belediyesi Asistanı',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Yapay Zeka Destekli',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.3), height: 1),
          // Mesajlar
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && index == _messages.length) {
                    return _buildLoadingMessage();
                  }
                  return _buildMessage(_messages[index]);
                },
              ),
            ),
          ),
          // Input alanı
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Mesajınızı yazın...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF21659E),
                        Color(0xFF3A7BB0),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mesaj bubble widget'ı
  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['message'] as String;
    final showServices = message['showServices'] as bool? ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF21659E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Color(0xFF21659E)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (isUser) ...[                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF21659E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
          if (showServices) ...[            SizedBox(height: 12),
            _buildServiceButtons(),
          ],
        ],
      ),
    );
  }

  // Loading mesajı
  Widget _buildLoadingMessage() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF21659E),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF21659E),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Düşünüyorum...',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hizmet butonları
  Widget _buildServiceButtons() {
    final services = [
      {'icon': '📢', 'name': 'Duyuru & İlanlar', 'service': 'Duyuru & İlanlar'},
      {'icon': '💳', 'name': 'Online Ödeme', 'service': 'Online Ödeme'},
      {'icon': '🗺', 'name': 'Kent Rehberi', 'service': 'Kent Rehberi'},
      {'icon': '🏢', 'name': 'Online İşlemler', 'service': 'Online İşlemler'},
      {'icon': '📐', 'name': 'E-İmar Sorgu', 'service': 'E-İmar Sorgu'},
      {'icon': '📜', 'name': 'Meclis Kararları', 'service': 'Meclis Kararları'},
      {'icon': '🚌', 'name': 'Batman Ulaşım', 'service': 'Batman Ulaşım'},
      {'icon': '📚', 'name': 'Kütüphane Katalog', 'service': 'Kütüphane Katalog'},
      {'icon': '💊', 'name': 'Nöbetçi Eczane', 'service': 'Nöbetçi Eczane'},
      {'icon': '⚰️', 'name': 'Vefat Edenler', 'service': 'Vefat Edenler'},
      {'icon': '💍', 'name': 'Nikah İşlemleri', 'service': 'Nikah İşlemleri'},
      {'icon': '🐾', 'name': 'Hayvan Sahiplendirme', 'service': 'Hayvan Sahiplendirme'},
      {'icon': '💧', 'name': 'Su Analiz Raporu', 'service': 'Su Analiz Raporu'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...services.map((service) {
          return InkWell(
            onTap: () => _navigateToService(service['service'] as String),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF21659E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF21659E).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    service['icon'] as String,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 6),
                  Text(
                    service['name'] as String,
                    style: TextStyle(
                      color: Color(0xFF21659E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        // Ne sorabilirim?
        InkWell(
          onTap: () {
            _messageController.text = 'Ne sorabilirim?';
            _sendMessage();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.orange.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🌟', style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text(
                  'Ne sorabilirim?',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Başka sorum var
        InkWell(
          onTap: () {
            _messageController.text = 'Başka sorum var';
            _sendMessage();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.purple.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🧐', style: TextStyle(fontSize: 16)),
                SizedBox(width: 6),
                Text(
                  'Başka sorum var',
                  style: TextStyle(
                    color: Colors.purple.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

