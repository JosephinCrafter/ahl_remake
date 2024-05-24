import 'package:firebase_article/firebase_article.dart';

class Project extends Article {
  Project({
    required super.id,
    required super.title,
    super.contentPath,
    super.relations,
    super.releaseDate,
  });

  String? get status {
    return relations?[0]['status'];
  }
}
