class Announcement {
  final String title;
  final String date;
  final String url;
  final String imageUrl;

  Announcement({
    required this.title,
    required this.date,
    required this.url,
    required this.imageUrl,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'url': url,
      'imageUrl': imageUrl,
    };
  }
}

class AnnouncementDetail {
  final String title;
  final String date;
  final String content;
  final List<Document> documents;

  AnnouncementDetail({
    required this.title,
    required this.date,
    required this.content,
    required this.documents,
  });
}

class Document {
  final String title;
  final String url;

  Document({
    required this.title,
    required this.url,
  });
}
