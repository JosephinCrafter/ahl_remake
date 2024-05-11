import 'package:firebase_article/firebase_article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as developer;

import '../state/state.dart';
import '../event/event.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc({required ArticlesRepository repo})
      : _repo = repo,
        super(const ArticleState(
          articles: null,
          status: ArticleStatus.initial,
          error: null,
        )) {
    on<GetArticleByIdEvent>(_onGetArticleById);
    on<GetHighlightArticleEvent>(_onGetHighlightedArticle);
    on<GetArticleListEvent>(_onGetArticleListEvent);
    on<InitializeArticleBlocEvent>(_onInitializeArticleBlocEvent);
    add(InitializeArticleBlocEvent());
  }

  ArticlesRepository _repo;

  void _onInitializeArticleBlocEvent(
    InitializeArticleBlocEvent event,
    Emitter emit,
  ) {
    emit(state.copyWith(
      status: ArticleStatus.initial,
      articles: null,
      error: null,
    ));
  }

  void _onGetArticleById(GetArticleByIdEvent event, Emitter emit) async {
    Object? error;
    Article? result;
    try {
      result = await _repo.getArticleByName(articleTitle: event.id);
    } catch (e) {
      error = e;
    }
    if (result != null) {
      emit(
        state.copyWith(
          status: ArticleStatus.succeed,
          articles: [result],
          error: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ArticleStatus.failed,
          articles: null,
          error: error,
        ),
      );
    }
  }

  void _onGetHighlightedArticle(
      GetHighlightArticleEvent event, Emitter emit) async {
    Object? error;
    Article? result;
    try {
      result = await _repo.getHighlighted();
      if (result != null) {
        emit(
          state.copyWith(
            status: ArticleStatus.succeed,
            articles: [result],
            error: null,
            highlightArticle: result,
          ),
        );
        developer.log('[ArticleBloc]: state: $state');
      }
    } catch (e) {
      error = 'Error getting highlight article : $e';
      if (result == null) {
        emit(state.copyWith(
          status: ArticleStatus.failed,
          error: error,
          articles: null,
          // highlightArticle: null,
        ));
      }
    } finally {}
  }

  void _onGetArticleListEvent(GetArticleListEvent event, Emitter emit) async {
    try {
      List<Article>? articles;
      if (event.ids != null) {
        articles = await _repo.getArticlesSubListByIds(event.ids!);
      }
      if (event.foldLength != null) {
        articles = await _repo.getArticlesSubListByLength(event.foldLength!);
      }
    } catch (e) {
      developer.log('[Article Bloc] Error getting article list: $e');
    }
  }
}
