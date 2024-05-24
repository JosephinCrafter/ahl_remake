import 'package:equatable/equatable.dart';
import 'package:firebase_article/firebase_article.dart';

enum ArticleStatus {
  initial,

  /// when no request has sent yet
  succeed,

  /// when a request has be done successfully
  failed,

  /// when a request failed
}

class ArticleState<T extends Article> extends Equatable {
  const ArticleState({
    this.status = ArticleStatus.initial,
    this.articles,
    this.error,
    this.highlightArticle,
  });

  final ArticleStatus status;
  final List<T?>? articles;
  final Object? error;
  final T? highlightArticle;

  ArticleState<T> copyWith({
    ArticleStatus? status,
    List<T>? articles,
    Object? error,
    T? highlightArticle,
  }) =>
      ArticleState<T>(
        status: status ?? this.status,
        articles: articles ?? this.articles,
        error: error ?? this.error,
        highlightArticle: highlightArticle ?? this.highlightArticle,
      );

  @override
  List<Object?> get props => [
        status,
        articles,
        error,
        highlightArticle,
      ];
}
