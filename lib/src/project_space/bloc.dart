import 'package:firebase_article/firebase_article.dart';
import 'package:ahl/src/project_space/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as developer;

import '../article_view/event/event.dart';
import '../article_view/state/state.dart';

class ProjectBloc extends Bloc<ArticleEvent, ArticleState<Article>> {
  ProjectBloc({
    required FirebaseFirestore firebaseFirestore,
    String collection = 'projects',
  })  : _repo = ArticlesRepository<Article>(
          firestoreInstance: firebaseFirestore,
          collection: collection,
        ),
        super(
          const ArticleState<Article>(
            articles: null,
            status: ArticleStatus.initial,
            error: null,
          ),
        ) {
    on<GetArticleByIdEvent>(_onGetArticleById);
    on<GetHighlightArticleEvent>(_onGetHighlightedArticle);
    on<GetArticleListEvent>(_onGetArticleListEvent);
    on<InitializeArticleBlocEvent>(_onInitializeArticleBlocEvent);
    add(InitializeArticleBlocEvent());
  }

  ArticlesRepository<Article> _repo;

  void _onInitializeArticleBlocEvent(
    InitializeArticleBlocEvent event,
    Emitter emit,
  ) {
    emit(
      state.copyWith(
        status: ArticleStatus.initial,
        articles: null,
        error: null,
      ),
    );
  }

  void _onGetArticleById(GetArticleByIdEvent event, Emitter emit) async {
    Object? error;
    Article? result;
    try {
      result = await _repo.getArticleByName(articleTitle: event.id) as Article;
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
        developer.log('[ProjectBloc]: state: $state');
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
        articles =
            await _repo.getArticlesSubListByIds(event.ids!) as List<Article>;
      }
      if (event.foldLength != null) {
        articles = await _repo.getArticlesSubListByLength(event.foldLength!)
            as List<Article>;
      }

      emit(
        state.copyWith(
            articles: articles, status: ArticleStatus.succeed, error: null),
      );
    } catch (e) {
      developer.log('[ProjectBloc] Error getting article list: $e');
    }
  }
}
