import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
              // Header
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ADMIN PANELİ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'İçerik Yönetimi',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: Icon(Icons.logout, color: Colors.white, size: 28),
                      tooltip: 'Çıkış Yap',
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelColor: Color(0xFF21659E),
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                  tabs: [
                    Tab(text: 'CAROUSEL'),
                    Tab(text: 'ETKİNLİKLER'),
                  ],
                ),
              ),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCarouselTab(),
                    _buildEtkinliklerTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('carouselItems')
          .orderBy('id')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        final docs = snapshot.data?.docs ?? [];

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length + 1,
          itemBuilder: (context, index) {
            if (index == docs.length) {
              return _buildAddButton(() => _showCarouselDialog());
            }
            
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            
            return _buildContentCard(
              title: data['title'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              onEdit: () => _showCarouselDialog(doc: doc),
              onDelete: () => _deleteItem('carouselItems', doc.id),
            );
          },
        );
      },
    );
  }

  Widget _buildEtkinliklerTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('etkinlikler')
          .orderBy('id')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        final docs = snapshot.data?.docs ?? [];

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: docs.length + 1,
          itemBuilder: (context, index) {
            if (index == docs.length) {
              return _buildAddButton(() => _showEtkinlikDialog());
            }
            
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            
            return _buildContentCard(
              title: data['title'] ?? '',
              imageUrl: data['imageUrl'] ?? '',
              onEdit: () => _showEtkinlikDialog(doc: doc),
              onDelete: () => _deleteItem('etkinlikler', doc.id),
            );
          },
        );
      },
    );
  }

  Widget _buildContentCard({
    required String title,
    required String imageUrl,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF21659E),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, size: 18),
                      label: Text('Düzenle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF21659E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, size: 18),
                      label: Text('Sil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.add_circle_outline, size: 28),
        label: Text(
          'YENİ EKLE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF21659E),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Future<void> _showCarouselDialog({DocumentSnapshot? doc}) async {
    final titleController = TextEditingController(
      text: doc != null ? (doc.data() as Map<String, dynamic>)['title'] : '',
    );
    final imageUrlController = TextEditingController(
      text: doc != null ? (doc.data() as Map<String, dynamic>)['imageUrl'] : '',
    );

    try {
      await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          doc == null ? 'Yeni Carousel Öğesi' : 'Carousel Öğesini Düzenle',
          style: TextStyle(color: Color(0xFF21659E)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Görsel URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final imageUrl = imageUrlController.text.trim();

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Başlık gerekli')),
                );
                return;
              }

              if (doc == null) {
                // Yeni ekle
                final snapshot = await FirebaseFirestore.instance
                    .collection('carouselItems')
                    .get();
                final newId = (snapshot.docs.length + 1).toString();

                await FirebaseFirestore.instance
                    .collection('carouselItems')
                    .doc(newId)
                    .set({
                  'id': newId,
                  'title': title,
                  'imageUrl': imageUrl,
                });
              } else {
                // Güncelle
                await doc.reference.update({
                  'title': title,
                  'imageUrl': imageUrl,
                });
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Başarıyla kaydedildi'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF21659E),
            ),
            child: Text('Kaydet'),
          ),
        ],
      ),
      );
    } finally {
      // Dispose after dialog is completely closed
      await Future.delayed(Duration(milliseconds: 100));
      titleController.dispose();
      imageUrlController.dispose();
    }
  }

  Future<void> _showEtkinlikDialog({DocumentSnapshot? doc}) async {
    final titleController = TextEditingController(
      text: doc != null ? (doc.data() as Map<String, dynamic>)['title'] : '',
    );
    final imageUrlController = TextEditingController(
      text: doc != null ? (doc.data() as Map<String, dynamic>)['imageUrl'] : '',
    );

    try {
      await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          doc == null ? 'Yeni Etkinlik' : 'Etkinliği Düzenle',
          style: TextStyle(color: Color(0xFF21659E)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Görsel URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final imageUrl = imageUrlController.text.trim();

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Başlık gerekli')),
                );
                return;
              }

              if (doc == null) {
                // Yeni ekle
                final snapshot = await FirebaseFirestore.instance
                    .collection('etkinlikler')
                    .get();
                final newId = (snapshot.docs.length + 1).toString();

                await FirebaseFirestore.instance
                    .collection('etkinlikler')
                    .doc(newId)
                    .set({
                  'id': newId,
                  'title': title,
                  'imageUrl': imageUrl,
                });
              } else {
                // Güncelle
                await doc.reference.update({
                  'title': title,
                  'imageUrl': imageUrl,
                });
              }

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Başarıyla kaydedildi'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF21659E),
            ),
            child: Text('Kaydet'),
          ),
        ],
      ),
      );
    } finally {
      // Dispose after dialog is completely closed
      await Future.delayed(Duration(milliseconds: 100));
      titleController.dispose();
      imageUrlController.dispose();
    }
  }

  Future<void> _deleteItem(String collection, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Silme Onayı', style: TextStyle(color: Color(0xFF21659E))),
        content: Text('Bu öğeyi silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Sil'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Başarıyla silindi'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }
}
