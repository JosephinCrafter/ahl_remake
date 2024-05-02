import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../utils/date_time_utils.dart';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:http/http.dart' as http;

import "package:firebase_article/firebase_article.dart";

String monthTextResolve(String monthName) {
  List vowels = ['a', 'e', 'i', 'o', 'u', 'y'];

  /// If the first element is a vowel.
  if (vowels.contains(monthName.characters.first.toLowerCase())) {
    return "Mois d'$monthName";
  } else {
    return 'Mois de $monthName';
  }
}

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
  const ArticleTile({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  late Article _article;

  @override
  void initState() {
    super.initState();

    _article = widget.article;
  }

  Future<String?> getHeroHeaderImageUrl() async {
    final heroHeaderImageRef = storage.child(
      "articles/${_article.id}/${_article.relations?[0]["hero_header_image"]}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final String url = await heroHeaderImageRef.getDownloadURL();

    if (kDebugMode) {
      print("$heroHeaderImageRef \n downloadUrl: $url");
    }

    return url;
  }

  Future<Uint8List?> getHeroHeaderImage() async {
    final heroHeaderImageRef = storage.child(
      "articles/${_article.id}/${_article.relations?[0]["hero_header_image"]}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final Uint8List? data = await heroHeaderImageRef.getData();

    if (kDebugMode) {
      print("$heroHeaderImageRef \n downloadUrl: $data");
    }

    return data;
  }

  Future<http.Response?> getContent() async {
    final contentRef = storage.child(
      "articles/${_article.id}/${_article.contentPath}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final String url = await contentRef.getDownloadURL();

    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print("$contentRef \n downloadUrl: ${response.body}");
    }

    return response;
  }

  void goToReadingPage() {
    // todo: go to reading page
  }

  @override
  Widget build(BuildContext context) {
    String releaseMonth = DateTimeUtils.localMonth(
      DateTimeUtils.parseReleaseDate(_article.releaseDate ?? '2024-04-28')
          .month,
      context,
    );

    return LayoutBuilder(
      builder: (context, constraints) => InkWell(
        onTap: goToReadingPage,
        child: Container(
          // margin: const EdgeInsets.symmetric(
          //   horizontal: Margins.mobileMedium,
          // ),
          constraints: const BoxConstraints(
            maxWidth: 1130,
            minWidth: 350,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_article.title != null)
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: Paddings.big, top: Paddings.small),
                  child: Text(
                    _article.title!,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                )
                    .animate()
                    .fadeIn(duration: const Duration(seconds: 2))
                    .slideY(curve: Curves.easeIn, begin: 0.5, end: 0),
              SizedBox(
                height: 135,
                // maxHeight: 232,
                width: constraints.maxWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 135,
                          maxHeight: 232,
                        ),
                        child: (_article
                                    .relations?.first['hero_header_image'] !=
                                null)
                            ? FutureBuilder(
                                future: getHeroHeaderImage(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.done:
                                      if (snapshot.hasData) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  MemoryImage(snapshot.data!),
                                            ),
                                          ),
                                        ).animate().fadeIn(
                                              curve: Curves.easeInOutBack,
                                            );
                                      } else {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                BorderSizes.small),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .errorContainer,
                                          ),
                                          child: Text(
                                            'Error getting image: ${snapshot.error}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                ),
                                          ).animate().fadeIn(),
                                        );
                                      }
                                    case ConnectionState.waiting:
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              BorderSizes.small),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        child: SizedBox.square(
                                          dimension: 50,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      );
                                    default:
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              BorderSizes.small),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                        ),
                                        child: SizedBox.square(
                                          dimension: 50,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      );
                                  }
                                },
                              )
                            : Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        BorderSizes.small),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: Paddings.big, right: Paddings.medium),
                      color: AhlTheme.yellowRelax,
                      constraints: const BoxConstraints.expand(
                        width: 25,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FutureBuilder(
                        future: getContent(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              alignment: Alignment.topCenter,
                              child: Baseline(
                                baseline: 15,
                                baselineType: TextBaseline.alphabetic,
                                child: RichText(
                                  // overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.body
                                            .substring(0, 75),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                      ),
                                      WidgetSpan(
                                        baseline: TextBaseline.alphabetic,
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        child: TextButton(
                                          child: Text('Lire'),
                                          onPressed: () {
                                            // todo: implement All article view
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(BorderSizes.small),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: SizedBox.square(
                                dimension: 50,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(BorderSizes.small),
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                              ),
                              child: Text(
                                'Error getting image: ${snapshot.error}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: const Duration(seconds: 2))
                    .slideY(curve: Curves.easeIn, begin: 0.5, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HighlightArticleTile extends StatelessWidget {
  const HighlightArticleTile({super.key});

// todo: get highlightedArticle
  final Article highlightedArticle = const Article(
    // todo: change to article form bloc
    id: 'qui_est_laure_sabes',
    title: 'Qui est Laure Sabes?',
    releaseDate: '2024-04-01',
    contentPath: 'content.md',
    relations: [
      {
        'hero_header_image': "hero_header_image.jpg",
      },
    ],
  );

  @override
  Widget build(BuildContext context) {
    String releaseMonth = DateTimeUtils.localMonth(
      DateTimeUtils.parseReleaseDate(
              highlightedArticle.releaseDate ?? '2024-04-28')
          .month,
      context,
    );
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Margins.mobileMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthTextResolve(
              releaseMonth,
            ).toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          ArticleTile(article: highlightedArticle),
          Container(
            margin: const EdgeInsets.all(Margins.mobileMedium),
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // todo: go to all articles
              },
              child: Text("Tous les articles"),
            ),
          ),
        ],
      ),
    );
  }
}
