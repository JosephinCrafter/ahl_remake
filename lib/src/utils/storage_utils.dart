import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_article/firebase_article.dart';
import 'package:http/http.dart' as http;

import '../firebase_constants.dart';

final class ArticleStorageUtils {
  ArticleStorageUtils({
    required Article article,
    required this.collection,
  }) : _article = article;

  final Article _article;
  final String collection;

  Future<String?> getHeroHeaderImageUrl() async {
    final heroHeaderImageRef = storage.child(
      "$collection/${_article.id}/${_article.relations?[0][RepoSetUp.coverImageKey]}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final String url = await heroHeaderImageRef.getDownloadURL();

    return url;
  }

  Future<Uint8List?> getCoverImage() async {
    Uint8List? data;
    try {
      final heroHeaderImageRef = storage.child(
        "$collection/${_article.id}/${_article.relations?[0][RepoSetUp.coverImageKey]}",
        // "articles/qui_est_laure_sabes/hero_header_image.jpg",
      );
      data = await heroHeaderImageRef.getData();
    } catch (e) {
      log('Error loading image: $e');
      data = Uint8List(0);
    }
    return data;
  }

  Future<http.Response?> getContent() async {
    final contentRef = storage.child(
      "$collection/${_article.id}/${_article.contentPath}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final String url = await contentRef.getDownloadURL();

    final response = await http.get(Uri.parse(url));

    return response;
  }
}
