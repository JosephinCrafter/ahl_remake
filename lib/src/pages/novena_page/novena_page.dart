import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/bloc/bloc.dart';
import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/pages/homepage/homepage.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.novena != null) {
      if (widget.novena!.relations![0]['type'] != 'novena') {
        // Future.microtask(() => context.go('/articles/${widget.novena!.id}'));
        return ArticleContentPage(
          article: widget.novena,
          collection: widget.collection,
        );
      }
      return NovenaContentView(novena: widget.novena!);
    } else {
      context.read<ArticleBloc>().add(
            GetArticleByIdEvent(
                id: widget.novenaId, collection: widget.collection),
          );
      return BlocBuilder<ArticleBloc, ArticleState<Article>>(
        // buildWhen: (previous, current) =>
        //     previous.articles?[widget.novenaId] == null,
        builder: (context, state) {
          Article? novena = state.articles?[widget.novenaId];

          if (novena != null) {
            if (novena.relations![0]['type'] != 'novena') {
              // Future.microtask(() => context.go('/articles/${widget.novena!.id}'));
              return ArticleContentPage(
                key: ValueKey("article_${novena.id}"),
                article: novena,
                collection: widget.collection,
              );
            }
            return NovenaContentView(
              novena: novena,
              collection: widget.collection,
            );
          } else {
            if (state.status != ArticleStatus.initial && novena == null) {
              return FutureBuilder(
                future: Future(
                  () => context.goNamed(HomePage.routeName),
                ),
                builder: (_, __) => const SizedBox.shrink(),
              );
            }
            return Scaffold(
              body: Center(
                child: LottieBuilder.asset('animations/loading.json'),
              ),
            );
          }
        },
      );
    }
  }
}

class NovenaContentView extends StatefulWidget {
  const NovenaContentView({
    super.key,
    required this.novena,
    this.collection = "novena",
  });
  final Article novena;
  final String collection;

  @override
  State<NovenaContentView> createState() {
    return _NovenaContentViewState();
  }

  /// The current day of the novena
  int get currentDay {
    return sortedDaysId.indexOf(novena.id) + 1;
  }

  /// A list of all days that is sorted.
  List<String> get sortedDaysId {
    var sortedDays = days.keys.toList();
    sortedDays.sort();
    List<String> sortedDaysId = [];
    for (String key in sortedDays) {
      sortedDaysId.add(days[key]);
    }
    return sortedDaysId;
  }

  /// A Map of all the novena document for upcoming and past days.
  Map<String, dynamic> get days {
    return novena.relations![0]['days'] as Map<String, dynamic>;
  }

  /// A list of all the novena document for upcoming and past days.
  List<String> get daysId {
    List<String> daysId = [];
    for (int i = 1; i <= days.length; i++) {
      String novenaDayId = days['day_$i'] ?? "";
      if (novenaDayId.isNotEmpty) {
        daysId.add(novenaDayId);
      }
    }

    return daysId;
  }

  List<Widget> buildNovenaDaysArticleTiles(
    BuildContext context, {
    void Function(String? novenaId)? callback,
  }) {
    List<Widget> cards = [];

    for (String novenaId in sortedDaysId) {
      int day = sortedDaysId.indexOf(novenaId) + 1;
      cards.add(
        Container(
          constraints: const BoxConstraints(
            maxHeight: 425,
            maxWidth: 330,
          ),
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: Paddings.medium + 3),
            constraints: BoxConstraints(
              maxWidth: ContentSize.maxWidth(MediaQuery.sizeOf(context).width),
            ),
            child: CardArticleTile.fromId(
              preview: "",
              label: "Neuvaine - Jour $day",
              callback: () {
                if (callback != null) {
                  callback(novenaId);
                }
              },
              direction: Axis.vertical,
              articleId: novenaId,
              collection: collection,
            ),
          ),
        ),
      );
    }
    return cards;
  }
}

class _NovenaContentViewState extends State<NovenaContentView> {
  late ScrollController controller;

  late ScrollController daysController;

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: 0,
      keepScrollOffset: false,
      // onAttach: (position) => controller.animateTo(
      //   0,
      //   duration: Durations.medium3,
      //   curve: Curves.easeInOut,
      // ),
    );

    daysController = ScrollController();
  }

  @override
  void dispose() {
    daysController.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future.microtask(
    //   () => controller.animateTo(
    //     0,
    //     duration: Durations.extralong1,
    //     curve: Curves.easeInOut,
    //   ),
    // );

    Size screenSize = MediaQuery.sizeOf(context);

    String label = 'Neuvaine - Jour ${widget.currentDay}';

    PreferredSizeWidget appBar = AhlAppBar(
      preferredSize: const Size.fromHeight(75 + 36),
      bottomBar: Container(
        // padding: const EdgeInsets.all(Paddings.small),
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(screenSize.width),
        ),
        child: PopupMenuButton(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(label),
              ],
            ),
          ),
          itemBuilder: (context) => List.generate(
            widget.sortedDaysId.length,
            (index) => PopupMenuItem(
              child: Text('Jour ${index + 1}'),
              onTap: () {
                context.goNamed(
                  NovenaPage.routeName,
                  pathParameters: {"novenaId": widget.sortedDaysId[index]},
                );
              },
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      endDrawer: const AhlDrawer(),
      body: ListView(
        controller: controller,
        addAutomaticKeepAlives: true,
        cacheExtent: 6000,
        children: [
          ArticleContentView(
            label: label,
            article: widget.novena,
            collection: widget.collection,
          ),
          Gap(
            resolveSeparatorSize(context),
          ),
          RelatedArticles(
            article: widget.novena,
            collection: widget.collection,
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
              addAutomaticKeepAlives: true,
              controller: daysController,
              scrollDirection: Axis.horizontal,
              children: widget.buildNovenaDaysArticleTiles(
                context,
                callback: (novenaId) {
                  context.goNamed(
                    NovenaPage.routeName,
                    pathParameters: {'novenaId': novenaId!},
                  );
                  controller.animateTo(0,
                      duration: Durations.medium4, curve: Curves.easeInOut);
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 160),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(BorderSizes.medium),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      double newOffset = daysController.offset - 330;
                      daysController.animateTo(newOffset,
                          duration: Durations.medium2, curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      double newOffset = daysController.offset + 330;

                      daysController.animateTo(newOffset,
                          duration: Durations.medium2, curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
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
