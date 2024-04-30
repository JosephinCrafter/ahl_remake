import '../../utils/date_time_utils.dart';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import "package:firebase_article/firebase_article.dart";

/// Article Page
class ArticleContentPage extends StatefulWidget {
  const ArticleContentPage({
    super.key,
    this.args,
    this.articleTitle,
    this.isHighLight = false,
    required this.firestore,
    required this.storage,
  }) : assert(
          isHighLight == true && articleTitle == null ||
              isHighLight == false && articleTitle != null,
          'isHightLight can\'t be true and articleTitle is given at the same time',
        );

  static const String routeName = '/articles';
  final dynamic args;
  final String? articleTitle;
  final bool isHighLight;
  final FirebaseStorage storage;
  final FirebaseFirestore firestore;

  @override
  State<ArticleContentPage> createState() => ArticleContentPageState();
}

class ArticleContentPageState extends State<ArticleContentPage> {
  late ArticlesRepository helper;
  late Future<Article?> article;

  @override
  void initState() {
    super.initState();
    helper = ArticlesRepository(firestoreInstance: widget.firestore);
    article = widget.articleTitle != null
        ? helper.getArticleByName(articleTitle: widget.articleTitle!)
        : helper.getHighlighted();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        endDrawer: constraints.maxWidth <= ScreenSizes.tablet
            ? const AhlDrawer()
            : null,
        appBar: const AhlAppBar(),
        body: ArticleContentView(
          article: article,
          ref: widget.storage.ref(),
        ),
      ),
    );
  }
}

class ArticleContentView extends StatelessWidget {
  const ArticleContentView({
    super.key,
    required this.article,
    required this.ref,
  });

  final Reference ref;

  final Future<Article?> article;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 1),
        Expanded(
          flex: 5,
          child: FutureBuilder(
            future: article,
            builder: (context, snapshot) {
              switch (snapshot.hasData) {
                case true:
                  return MarkdownWidget(
                    data: ref
                        .child(snapshot.data!.contentPath!)
                        .getData()
                        .toString(),
                  );

                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ),
        const Spacer(
          flex: 1,
        )
      ],
    );
  }
}

/// A tile of article
class ArticleTile extends StatefulWidget {
  const ArticleTile({super.key});

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  late Article article;

  @override
  void initState() {
    super.initState();

    article = const Article(
      // todo: change to article form bloc
      id: 'laure_sabes',
      title: 'Qui est Laure Sabes?',
      releaseDate: '2024-04-28',
      contentPath: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    String releaseMonth = DateTimeUtils.localMonth(
      DateTimeUtils.parseReleaseDate(article.releaseDate ?? '2024-04-28').month,
      context,
    );
    return Container(
      child: Column(
        children: [
          Text('Mois de $releaseMonth'),
        ],
      ),
    );
  }
}

class HighlightArticleTile extends StatelessWidget {
  const HighlightArticleTile({super.key});

// todo: get highlightedArticle

  @override
  Widget build(BuildContext context) {
    return ArticleTile();
  }
}
