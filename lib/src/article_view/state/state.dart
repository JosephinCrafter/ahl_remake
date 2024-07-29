import 'package:equatable/equatable.dart';
import 'package:firebase_article/firebase_article.dart';

enum ArticleStatus {
  initial,

  /// when no request has sent yet
  succeed,

  /// when a request has be done successfully
  failed,

  /// when a request
}

class ArticleState<T extends Article> extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.articles,
    this.error,
    this.highlightArticle,
    this.highlightCollection,
    this.highlightPath,
  });

  final ArticleStatus status;
  final Map<String, T>? articles;
  final Object? error;
  final T? highlightArticle;
  final String? highlightPath;
  final String? highlightCollection;

  ArticleState<T> copyWith({
    ArticleStatus? status,
    Map<String, T>? articles,
    Object? error,
    T? highlightArticle,
    String? highlightPath,
    String? highlightCollection,
  }) {
    Map<String, T> newArticles = {};

    if (articles != null) {
      newArticles.addAll(articles);
    }
    if (this.articles != null) {
      newArticles.addAll(this.articles!);
    }

    return ArticleState<T>(
      status: status ?? this.status,
      articles: newArticles,
      error: error ?? this.error,
      highlightArticle: highlightArticle ?? this.highlightArticle,
      highlightCollection: highlightCollection ?? this.highlightCollection,
      highlightPath: highlightPath ?? this.highlightPath,
    );
  }

  @override
  List<Object?> get props => [
        status,
        articles,
        error,
        highlightArticle,
        highlightPath,
        highlightCollection,
      ];
}
