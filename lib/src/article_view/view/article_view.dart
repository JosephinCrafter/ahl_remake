import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:ahl/src/pages/homepage/donation/donation_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web/web.dart' as web;

import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markdown_widget/markdown_widget.dart';
import "package:firebase_article/firebase_article.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:session_storage/session_storage.dart';

import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/pages/projects/projects_page.dart';
import 'package:ahl/src/article_view/bloc/bloc.dart';
import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/state/state.dart';
import 'package:ahl/src/firebase_constants.dart' as firebase;
import 'package:ahl/src/theme/theme.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import '../../utils/date_time_utils.dart';
import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/widgets/widgets.dart';

import '../../utils/storage_utils.dart';

part 'article_content_view.dart';
part 'highlight_article_tile.dart';

// import 'package:markdown_widget/markdown_widget.dart';

String monthTextResolve(BuildContext context, String monthName) {
  List vowels = ['a', 'e', 'i', 'o', 'u', 'y'];

  /// If the first element is a vowel.
  //todo: change based on locale to.
  if (vowels.contains(monthName.characters.first.toLowerCase())) {
    return "Mois d'$monthName";
  } else {
    return 'Mois de $monthName';
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
  // article of the tile
  late Article _article;

  late ArticleStorageUtils articleStorageUtils;

  @override
  void initState() {
    _article = widget.article;

    articleStorageUtils =
        ArticleStorageUtils(article: _article, collection: 'articles');
    super.initState();
  }

  void goToReadingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ArticleContentPage(article: _article);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? titleTheme = resolveHeadlineTextThemeForBreakPoints(
      MediaQuery.of(context).size.width,
      context,
    );
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        // padding: const EdgeInsets.all(Paddings.big),
        // clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BorderSizes.big),
        ),
        child: Material(
          borderOnForeground: true,
          child: InkWell(
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
                        style: titleTheme,
                      ),
                    ),
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
                            child: (_article.relations
                                        ?.first[RepoSetUp.coverImageKey] !=
                                    null)
                                ? FutureBuilder(
                                    future: articleStorageUtils
                                        .getCoverImage(), //getHeroHeaderImage(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.done:
                                          if (snapshot.hasData) {
                                            return Container(
                                              constraints: const BoxConstraints(
                                                maxHeight: 135,
                                                maxWidth: 185,
                                                minWidth: 107,
                                              ),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: MemoryImage(
                                                      snapshot.data!),
                                                ),
                                              ),
                                            ).animate().fadeIn(
                                                  curve: Curves.easeInOutBack,
                                                );
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BorderSizes.small),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .errorContainer,
                                              ),
                                              child: Text(
                                                'Error getting image: ${snapshot.error}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: Paddings.big,
                                          right: Paddings.medium),
                                      color: AhlTheme.yellowRelax,
                                      constraints: const BoxConstraints.expand(
                                        width: 25,
                                        // height: 85,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: FutureBuilder(
                                        future: Future.value(_article.relations
                                                ?.first[RepoSetUp.previewKey]
                                            as String),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                snapshot.data!,
                                                maxLines: 4,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              ),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BorderSizes.small),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                              ),
                                              child: SizedBox.square(
                                                dimension: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        BorderSizes.small),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .errorContainer,
                                              ),
                                              child: Text(
                                                'Error getting content: ${snapshot.error}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       foregroundColor:
                              //           Theme.of(context).colorScheme.onPrimary,
                              //       backgroundColor:
                              //           Theme.of(context).colorScheme.primary,
                              //     ),
                              //     onPressed: () {
                              //       goToReadingPage();
                              //     },
                              //     child: const Text('Lire'),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A tile of article
class CardArticleTile extends StatefulWidget {
  const CardArticleTile({
    super.key,
    required this.article,
    this.collection = 'articles',
  });

  final Article article;
  final String collection;

  @override
  State<CardArticleTile> createState() => _CardArticleTileState();
}

class _CardArticleTileState extends State<CardArticleTile>
    with AutomaticKeepAliveClientMixin {
  // article of the tile
  late Article _article;

  late ArticleStorageUtils articleStorageUtils;

  late String collection;

  late double elevation;

  @override
  void initState() {
    _article = widget.article;

    collection = widget.collection;
    elevation = 5.0;

    articleStorageUtils =
        ArticleStorageUtils(article: _article, collection: collection);
    super.initState();
  }

  void goToReadingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ArticleContentPage(article: _article);
        },
      ),
    );
    collection = widget.collection;
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      setState(() {
        elevation = 25;
      });
    } else {
      setState(() {
        elevation = 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TextStyle? titleTheme = Theme.of(context).textTheme.headlineSmall;
    // resolveHeadlineTextThemeForBreakPoints(
    //   MediaQuery.of(context).size.width,
    //   context,
    // );

    DateTime releaseDate =
        DateTimeUtils.parseReleaseDate(_article.releaseDate ?? "");
    return Card(
      color: Colors.white,
      elevation: elevation,
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BorderSizes.medium),
      ),
      child: InkWell(
        onHover: _onHover,
        onTap: goToReadingPage,
        child: Container(
          // padding: const EdgeInsets.all(Paddings.medium),
          constraints: BoxConstraints(
            maxWidth: resolveForBreakPoint(
              MediaQuery.of(context).size.width,
              // small: 330,
              // medium: 330,
              other: ContentSize.maxWidth(MediaQuery.of(context).size.width),
            ),
            minWidth: 330,
            maxHeight: resolveForBreakPoint(
              MediaQuery.of(context).size.width,
              other: 300,
              small: 400,
              medium: 400,
            ),
          ),
          child: Flex(
            direction: resolveForBreakPoint(
              MediaQuery.of(context).size.width,
              other: Axis.horizontal,
              small: Axis.vertical,
              medium: Axis.vertical,
            ),
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(Paddings.big),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${releaseDate.day} ${DateTimeUtils.localMonth(releaseDate.month, context)} ${releaseDate.year}",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),

                      //title
                      if (_article.title != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: Paddings.small, top: Paddings.small),
                          child: Text(
                            _article.title!,
                            style: titleTheme,
                          ),
                        ),
                      // separator
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: Paddings.small,
                        ),
                        color: AhlTheme.yellowRelax,
                        constraints: const BoxConstraints.expand(
                          width: 100,
                          height: 16,
                        ),
                      ),
                      Expanded(
                        child: ArticlePreviewTextView(
                          article: _article,
                          collection: collection,
                          callback: goToReadingPage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //                 ],
              //               ),
              //             ),
              //             // Align(
              //             //   alignment: Alignment.centerRight,
              //             //   child: ElevatedButton(
              //             //     style: ElevatedButton.styleFrom(
              //             //       foregroundColor:
              //             //           Theme.of(context).colorScheme.onPrimary,
              //             //       backgroundColor:
              //             //           Theme.of(context).colorScheme.primary,
              //             //     ),
              //             //     onPressed: () {
              //             //       goToReadingPage();
              //             //     },
              //             //     child: const Text('Lire'),
              //             //   ),
              //             // ),
              //           ],
              //         ),
              //       ),
              Expanded(
                child: ArticleCoverImage(
                  article: _article,
                  collection: collection,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => articleStorageUtils.coverImage != null;

  @override
  void updateKeepAlive() {
    super.updateKeepAlive();
  }
}

class MobileArticleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0); // Start at top right corner
    path.lineTo(0, size.height * 1 / 10); // Draw line to top right corner
    path.lineTo(0, size.height); // Diagonal line down
    path.lineTo(size.width, size.width);

    // path.lineTo(0, size.height); // Line to bottom left corner
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(MobileArticleClipper oldClipper) =>
      false; // Optimizes performance if path doesn't change
}

class LargeArticleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 1 / 4, 0); // Start at top right corner
    path.lineTo(0, size.height); // Draw line to top right corner
    path.lineTo(size.width, size.width);
    path.lineTo(size.width, 0); // Diagonal line down

    // path.lineTo(0, size.height); // Line to bottom left corner
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(LargeArticleClipper oldClipper) =>
      false; // Optimizes performance if path doesn't change
}

class ArticleCoverImage extends StatefulWidget {
  const ArticleCoverImage({
    super.key,
    required this.article,
    this.collection = 'articles',
  });
  final String collection;
  final Article article;

  @override
  State<ArticleCoverImage> createState() => _ArticleCoverImageState();
}

class _ArticleCoverImageState extends State<ArticleCoverImage> {
  late ArticleStorageUtils articleStorageUtils;
  late Future articleCoverImage;
  late Article _article;

  final SessionStorage cache = SessionStorage();

  late String coverImageCacheKey;
  @override
  void initState() {
    super.initState();
    articleStorageUtils = ArticleStorageUtils(
      article: widget.article,
      collection: widget.collection,
    );
    _article = widget.article;

    coverImageCacheKey = "${_article.id}_cover_image";

    articleCoverImage =
        articleStorageUtils.getCoverImage(); //getHeroHeaderImage()
  }

  @override
  Widget build(BuildContext context) {
    return
        // (cache[coverImageCacheKey] == null)
        //     ?
        ConstrainedBox(
            constraints: const BoxConstraints(
                // minHeight: 135,
                // maxHeight: 232,
                ),
            child:
                // (_article.relations?.first[RepoSetUp.coverImageKey] != null)
                //     ?
                FutureBuilder(
              future: articleCoverImage,
              builder: (context, snapshot) {
                // switch (snapshot.connectionState) {
                //   case ConnectionState.done:
                try {
                  if (snapshot.hasData) {
                    cache[coverImageCacheKey] =
                        encodeUint8ListToString(snapshot.data!);
                    return ClipPath(
                      clipper: resolveForBreakPoint(
                        MediaQuery.of(context).size.width,
                        other: LargeArticleClipper(),
                        small: MobileArticleClipper(),
                        medium: MobileArticleClipper(),
                      ),
                      child: Container(
                        // constraints: const BoxConstraints(
                        //   // maxHeight: 135,
                        //   // maxWidth: 185,
                        //   // minWidth: 107,
                        // ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(snapshot.data!),
                          ),
                        ),
                      ).animate().fadeIn(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } catch (e) {
                  log("Error getting HighLight Article");
                  return const SizedBox.shrink();
                }
                //      else {
                //       return Container(
                //         decoration: BoxDecoration(
                //           borderRadius:
                //               BorderRadius.circular(BorderSizes.small),
                //           color: Theme.of(context)
                //               .colorScheme
                //               .errorContainer,
                //         ),
                //         child: Text(
                //           'Error getting image: ${snapshot.error}',
                //           style: Theme.of(context)
                //               .textTheme
                //               .labelSmall!
                //               .copyWith(
                //                 color:
                //                     Theme.of(context).colorScheme.error,
                //               ),
                //         ).animate().fadeIn(),
                //       );
                //     }
                //   case ConnectionState.waiting:
                //     return Container(
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         borderRadius:
                //             BorderRadius.circular(BorderSizes.small),
                //         color: Theme.of(context)
                //             .colorScheme
                //             .primaryContainer,
                //       ),
                //       child: SizedBox.square(
                //         dimension: 50,
                //         child: CircularProgressIndicator(
                //           color: Theme.of(context).colorScheme.primary,
                //         ),
                //       ),
                //     );
                //   default:
                //     return Container(
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //         borderRadius:
                //             BorderRadius.circular(BorderSizes.small),
                //         color: Theme.of(context)
                //             .colorScheme
                //             .secondaryContainer,
                //       ),
                //       child: SizedBox.square(
                //         dimension: 50,
                //         child: CircularProgressIndicator(
                //           color: Theme.of(context).colorScheme.secondary,
                //         ),
                //       ),
                //     );
                // }
              },
            )
            // : Expanded(
            //     child: Container(
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(BorderSizes.small),
            //         color: Theme.of(context).colorScheme.primaryContainer,
            //       ),
            //     ),
            //   ),
            )
        // : ClipPath(
        //     clipper: resolveForBreakPoint(
        //       MediaQuery.of(context).size.width,
        //       other: LargeArticleClipper(),
        //       small: MobileArticleClipper(),
        //       medium: MobileArticleClipper(),
        //     ),
        //     child: Container(
        //       // constraints: const BoxConstraints(
        //       //   // maxHeight: 135,
        //       //   // maxWidth: 185,
        //       //   // minWidth: 107,
        //       // ),
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           fit: BoxFit.cover,
        //           image: MemoryImage(decodeUint8ListFromString(
        //               cache[coverImageCacheKey] ?? "[[]]")),
        //         ),
        //       ),
        //     ).animate().fadeIn(
        //           curve: Curves.easeInOutBack,
        //         ),
        //   );
        ;
  }
}

class ArticlePreviewTextView extends StatefulWidget {
  const ArticlePreviewTextView(
      {super.key,
      required this.article,
      this.collection = 'articles',
      this.callback});

  final Article article;
  final String collection;
  final VoidCallback? callback;

  @override
  State<StatefulWidget> createState() {
    return _ArticlePreviewViewState();
  }
}

class _ArticlePreviewViewState extends State<ArticlePreviewTextView> {
  // late ArticleStorageUtils _articleStorageUtils;

  @override
  void initState() {
    // _articleStorageUtils = ArticleStorageUtils(
    //     article: widget.article, collection: widget.collection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.article.relations?.first[RepoSetUp.coverImageKey] != null)
        ? FutureBuilder(
            future: Future.value(widget
                .article.relations?.first[RepoSetUp.previewKey] as String),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: snapshot.data!,
                      //  softWrap: true,
                      // maxLines: 5,

                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(overflow: TextOverflow.ellipsis),
                      // children: [
                      //   WidgetSpan(
                      //     child: TextButton(
                      //       child: Text(
                      //         AppLocalizations.of(context)!.read,
                      //       ),
                      //       onPressed: () {
                      //         if (widget.callback != null) widget.callback!();
                      //       },
                      //     ),
                      //   ),
                      // ],
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(BorderSizes.small),
                    color: Theme.of(context).colorScheme.primaryContainer,
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
                    borderRadius: BorderRadius.circular(BorderSizes.small),
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                  child: Text(
                    'Error getting content: ${snapshot.error}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                );
              }
            },
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BorderSizes.small),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          );
  }
}
