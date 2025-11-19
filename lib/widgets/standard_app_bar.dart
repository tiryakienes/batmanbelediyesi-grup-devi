import 'package:flutter/material.dart';
import '../screens/admin_login_screen.dart';

class StandardAppBar extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const StandardAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  State<StandardAppBar> createState() => _StandardAppBarState();
}

class _StandardAppBarState extends State<StandardAppBar> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF21659E),
            Color(0xFF1A5185),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol taraf - Menü veya Geri butonu
          GestureDetector(
            onTap: () {
              if (widget.showBackButton) {
                if (widget.onBackPressed != null) {
                  widget.onBackPressed!();
                } else {
                  Navigator.pop(context);
                }
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            child: Icon(
              widget.showBackButton ? Icons.arrow_back_ios : Icons.menu,
              color: Colors.white,
              size: 24,
            ),
          ),
          // Orta - Logo ve Yazı (Triple tap for admin)
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < 500) {
                _tapCount++;
                if (_tapCount >= 3) {
                  _tapCount = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                  );
                }
              } else {
                _tapCount = 1;
              }
              _lastTapTime = now;
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.account_balance, color: Colors.white, size: 40);
                  },
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BATMAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
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
          ),
          // Sağ taraf - Hava Durumu
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '22°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'GÜNEŞLI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Icon(Icons.cloud_outlined, color: Colors.white, size: 32),
            ],
          ),
        ],
      ),
    );
  }
}

