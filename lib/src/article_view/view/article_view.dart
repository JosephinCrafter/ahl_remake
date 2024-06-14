import 'dart:math';

import 'package:ahl/src/pages/articles/articles_page.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import "package:firebase_article/firebase_article.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:session_storage/session_storage.dart';

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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    goToReadingPage();
                                  },
                                  child: const Text('Lire'),
                                ),
                              ),
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
