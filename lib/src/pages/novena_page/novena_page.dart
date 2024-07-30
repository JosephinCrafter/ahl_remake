import 'dart:js_interop';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/bloc/bloc.dart';
import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../article_view/state/state.dart';

class NovenaPage extends StatefulWidget {
  const NovenaPage({
    super.key,
    required this.novena,
    this.collection = "novena",
  }) : novenaId = null;

  const NovenaPage.fromId({
    super.key,
    required this.novenaId,
    this.collection = "novena",
  }) : novena = null;

  static const routeName = 'novena';
  final Article? novena;
  final String? novenaId;
  final String collection;

  @override
  State<NovenaPage> createState() => _NovenaPageState();
}

class _NovenaPageState extends State<NovenaPage> {
  @override
  void initState() {
    super.initState();

    if (widget.novena == null) {
      context.read<ArticleBloc>().add(
            GetArticleByIdEvent(id: widget.novenaId, collection: "novena"),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.novena != null) {
      return NovenaContentView(novena: widget.novena!);
    } else {
      return BlocBuilder<ArticleBloc, ArticleState<Article>>(
        buildWhen: (previous, current) =>
            previous.articles?[widget.novenaId] == null,
        builder: (context, state) {
          Article? novena = state.articles?[widget.novenaId];

          if (novena != null) {
            return NovenaContentView(
              novena: novena,
              collection: widget.collection,
            );
          } else {
            return Scaffold(
              body: LottieBuilder.asset('animations/loading.json'),
            );
          }
        },
      );
    }
  }
}

class NovenaContentView extends StatelessWidget {
  const NovenaContentView({
    super.key,
    required this.novena,
    this.collection = "novena",
  });
  final Article novena;
  final String collection;

  int get currentDay {
    var sortedDays = days.keys.toList();
    sortedDays.sort();
    List sortedDaysId = [];
    for (String key in sortedDays) {
      sortedDaysId.add(days[key]);
    }
    return sortedDaysId.indexOf(novena.id) + 1;
  }

  Map<String, dynamic> get days {
    return novena.relations![0]['days'] as Map<String, dynamic>;
  }

  List<String> get daysId {
    List<String> daysId = [];
    for (int i = 1; i < days.length; i++) {
      String novenaDayId = days['day_$i'] ?? "";
      if (novenaDayId.isNotEmpty) {
        daysId.add(novenaDayId);
      }
    }

    return daysId;
  }

  List<Widget> buildNovenaDaysArticleTiles(BuildContext context) {
    List<Widget> cards = [];

    for (String articleId in daysId) {
      int day = daysId.indexOf(articleId) + 1;
      cards.add(
        Container(
          constraints: const BoxConstraints(
            maxHeight: 425,
            maxWidth: 330,
          ),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Paddings.medium),
            constraints: BoxConstraints(
              maxWidth: ContentSize.maxWidth(MediaQuery.sizeOf(context).width),
            ),
            child: CardArticleTile.fromId(
              label: "Neuvaine - Jour $day",
              direction: Axis.vertical,
              articleId: articleId,
              collection: collection,
            ),
          ),
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    String label = 'Neuvaine - Jour $currentDay';
    PreferredSizeWidget appBar = AhlAppBar(
      preferredSize: const Size.fromHeight(75 + 36),
      bottomBar: Container(
        padding: const EdgeInsets.all(Paddings.small),
        child: PopupMenuButton(
          itemBuilder: (context) => List.generate(
            10,
            (index) => PopupMenuItem(
              child: Text(' $index'),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      endDrawer: const AhlDrawer(),
      body: ListView(
        children: [
          ArticleContentView(
            label: label,
            article: novena,
            collection: collection,
          ),
          Gap(
            resolveSeparatorSize(context),
          ),
          RelatedArticles(
            article: novena,
            collection: collection,
          ),
          Gap(
            resolveSeparatorSize(context),
          ),

          /// related article place
          /// newsletter prompt
          const NewsLetterPrompt(),
          Gap(
            resolveSeparatorSize(context),
          ),
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(
              maxHeight: 480,
              maxWidth: MediaQuery.sizeOf(context).width,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buildNovenaDaysArticleTiles(context),
            ),
          ),

          Gap(
            resolveSeparatorSize(context),
          ),

          /// other day
          /// Ahl footer
          const AhlFooter(),
        ],
      ),
    );
  }
}

/// Build related Article
/// This Dart function builds a list of related article tiles in a Flutter app.
///
/// Args:
///   context (BuildContext): The `BuildContext` parameter in the `buildRelatedArticleTiles` method
/// represents the location of a widget within the widget tree. It provides information about the
/// current build context, such as the theme, media query data, and localization information. This
/// context is essential for building widgets correctly and accessing resources like themes
class RelatedArticles extends StatefulWidget {
  const RelatedArticles({
    super.key,
    required this.collection,
    required this.article,
    this.relationKey = 'relatedArticles',
  });

  final String collection;
  final Article article;
  final String relationKey;

  @override
  State<RelatedArticles> createState() => _RelatedArticlesState();
}

class _RelatedArticlesState extends State<RelatedArticles> {
  late List<Widget> cards = [];

  List<Widget> buildRelatedArticleTiles(BuildContext context, Article article) {
    List relatedArticle = article.relations?[0][widget.relationKey] ?? [];
    cards = [];

    for (String articleId in relatedArticle) {
      cards.add(
        Align(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Paddings.medium),
            constraints: BoxConstraints(
              maxWidth: ContentSize.maxWidth(MediaQuery.sizeOf(context).width),
            ),
            child: CardArticleTile.fromId(
              articleId: articleId,
              collection: widget.collection,
            ),
          ),
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: buildRelatedArticleTiles(context, widget.article),
    );
  }
}
