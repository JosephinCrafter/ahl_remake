final class ArticleEvent {
  const ArticleEvent({this.id});

  final String? id;
}

final class GetHighlightArticleEvent extends ArticleEvent {
  const GetHighlightArticleEvent() : super(id: null);
}

final class GetArticleByIdEvent extends ArticleEvent {
  const GetArticleByIdEvent({required super.id});
}

final class GetHighlightPathEvent extends ArticleEvent {
  const GetHighlightPathEvent();
}

final class GetHighlightCollectionEvent extends ArticleEvent {
  const GetHighlightCollectionEvent();
}

/// Request A list of article from the server.
final class GetArticleListEvent extends ArticleEvent {
  const GetArticleListEvent({
    this.foldLength = 1,
    this.ids,
  })  : assert(
          ids == null && foldLength != null ||
              ids != null && foldLength == null,
          'ids and [foldLength] can\'t be provided at the same time',
        ),
        super(
          id: null,
        );

  final int? foldLength;
  final List<String>? ids;
}

final class InitializeArticleBlocEvent extends ArticleEvent {
  InitializeArticleBlocEvent() : super(id: null);
}
