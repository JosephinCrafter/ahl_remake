import 'package:ahl/src/article_view/bloc/bloc.dart';
import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/state/state.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';

void main() {
  ArticlesRepository mockRepo =
      ArticlesRepository(firestoreInstance: firestore);
  String highlightId = 'highlight';
  group(
    'Article bloc test',
    () {
      Article article = const Article(
        id: 'qui_est_laure_sabes',
        title: 'Qui est Laure Sabes?',
        releaseDate: '2024-02-04',
        contentPath: 'content.md',
        relations: [
          {
            'hero_header_image': 'image.png',
          },
        ],
      );
      setUp(() {
        // when(mockRepo.getHighlighted()).thenAnswer((_) {
        //   return Future.value(
        //     article,
        //   );
        // });
        // when(mockRepo.getArticleByName(articleTitle: highlightId))
        //     .thenAnswer((_) {
        //   return Future.value(
        //     article,
        //   );
        // });
      });
      blocTest<ArticleBloc, ArticleState>(
        'getting highlighted article',
        build: () => ArticleBloc(repo: mockRepo),
        act: (ArticleBloc bloc) => bloc..add(const GetHighlightArticleEvent()),
        expect: () => [
          const ArticleState(
            status: ArticleStatus.initial,
            articles: null,
          ),
          ArticleState(
            status: ArticleStatus.succeed,
            articles: {article.id: article},
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'getting an id given article',
        build: () => ArticleBloc(repo: mockRepo),
        act: (bloc) => bloc.add(
          GetArticleByIdEvent(id: highlightId),
        ),
        expect: () => [
          const ArticleState(
            status: ArticleStatus.initial,
            articles: null,
          ),
          ArticleState(
            status: ArticleStatus.succeed,
            articles: {article.id: article},
          ),
        ],
      );
    },
  );
}
