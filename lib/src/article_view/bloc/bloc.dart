import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_article/firebase_article.dart' as fire_art;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as developer;

import '../state/state.dart';
import '../event/event.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState<fire_art.Article>> {
  ArticleBloc({required fire_art.ArticlesRepository<fire_art.Article> repo})
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

  ArticleBloc.inCollection(
      {required String collection, required FirebaseFirestore firestore})
      : _repo = fire_art.ArticlesRepository<fire_art.Article>(
            firestoreInstance: firestore, collection: collection),
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

  final fire_art.ArticlesRepository<fire_art.Article> _repo;

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
    fire_art.Article? result;
    try {
      result = await _repo.getArticleById(articleId: event.id);
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
    fire_art.Article? result;

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
      List<fire_art.Article>? articles;
      if (event.ids != null) {
        articles = await _repo.getArticlesSubListByIds(event.ids!)
            as List<fire_art.Article>;
      }
      if (event.foldLength != null) {
        articles?.addAll(
            await _repo.getArticlesSubListByLength(event.foldLength!)
                as List<fire_art.Article>);
      }

      emit(
        state.copyWith(
            articles: articles, status: ArticleStatus.succeed, error: null),
      );
    } catch (e) {
      developer.log('[Article Bloc] Error getting article list: $e');
    }
  }
}
