import 'dart:developer';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/pages/projects/projects_page.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/project_space/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/breakpoint_resolver.dart';

class ProjectPageView extends StatefulWidget {
  ProjectPageView({
    super.key,
    required this.project,
    this.collection = "projects",
  }) : relatedArticles = buildRelatedArticle(
          const Article(
            id: 'id',
          ),
        ); // change this to the build relations

  /// The current project to be displayed
  final Article project;
  final List<Article> relatedArticles;
  final String collection;

  static List<Article> buildRelatedArticle(Article article) {
    List<Article> relatedArticles = [];

    //  building articles;
    //todo: replace with the real implementation
    relatedArticles.addAll(
      [
        const Article(
          id: 'Fête de fin d\'année',
          releaseDate: '22/06/2024',
          contentPath: 'fete_fin_d\'annee.md',
          title: 'Fête de fin d\'année Cantine',
        ),
        const Article(
          id: 'Rapport fin',
          releaseDate: '17/07/2024',
          contentPath: 'rapport.md',
          title: 'Rapport Cantine 2023-2024',
        ),
      ],
    );

    return relatedArticles;
  }

  @override
  State<StatefulWidget> createState() => _ProjectPageViewState();
}

class _ProjectPageViewState extends State<ProjectPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _descriptionScrollController;
  late ScrollController _newsScrollController;
  late bool needDisplayTitleInAppBar;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _descriptionScrollController = ScrollController();
    _newsScrollController = ScrollController();

    needDisplayTitleInAppBar = false;
    _descriptionScrollController.addListener(updateNeedDisplayTitle);
  }

  void updateNeedDisplayTitle() {
    if (_descriptionScrollController.offset >= 64) {
      setState(() => needDisplayTitleInAppBar = true);
    } else {
      setState(() => needDisplayTitleInAppBar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    var title = widget.project.title;
    var value = needDisplayTitleInAppBar ? 1.0 : 0.0;
    return Scaffold(
      appBar: AhlAppBar(
        preferredSize: //!needDisplayTitleInAppBar
            // ? const Size.fromHeight(75 + 30)
            const Size.fromHeight(75 + 64),
        bottomBar: Flexible(
          flex: 1,
          child: Container(
            // constraints: BoxConstraints(
            //   maxWidth: ContentSize.maxWidth(
            //     MediaQuery.sizeOf(context).width,
            //   ),
            // ),
            // color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 1024),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    horizontal: resolveForBreakPoint(
                      screenWidth,
                      other: Margins.small,
                      extraHuge: Margins.extraHuge,
                      huge: Margins.huge,
                      extraLarge: Margins.extraLarge,
                      large: Margins.large,
                    ),
                  ),
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: resolveForBreakPoint(
                  //     screenWidth,
                  //     small: Margins.small,
                  //     medium: Margins.small,
                  //     large: Margins.large,
                  //     extraLarge: Margins.extraLarge,
                  //     other: Margins.huge,
                  //   ),
                  // ),
                  child: AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Text(
                        title!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      crossFadeState: !needDisplayTitleInAppBar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Durations.medium1),
                ),
                // Container(
                //         child: Visibility(
                //             visible: needDisplayTitleInAppBar,
                //             child: Text(
                //               title!,
                //               style: Theme.of(context).textTheme.titleLarge,
                //             )))
                //     .animate(
                //       autoPlay: false,
                //       target: needDisplayTitleInAppBar ? 1 : 0,
                //     )
                //     .fadeIn()
                //     .slideY(begin: 1),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      text: "Description",
                    ),
                    Tab(
                      text: "Actualités",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectDescriptionContentView(
            article: widget.project,
            scrollController: _descriptionScrollController,
          ),
          ProjectNewsView(
            relatedArticles: widget.relatedArticles,
            scrollController: _newsScrollController,
          ),
        ],
      ),
    );
  }
}

class ProjectDescriptionContentView extends StatelessWidget {
  const ProjectDescriptionContentView({
    super.key,
    required this.article,
    this.scrollController,
  });

  final Article article;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    // List<Widget> suggestion = context.read<ProjectBloc>().state.articles?.map<Widget>((element)=>).toList();
    return ListView(
      controller: scrollController,
      children: [
        ArticleContentView(
          article: article,
          collection: "/projects",
        ),
        const NewsLetterPrompt(),
        const AhlDivider(leading: 0, trailing: 0),
        //  ...suggestion,
        const AhlDivider(leading: 0, trailing: 0),
        const AhlFooter(),
      ],
    );
  }
}

class ProjectNewsView extends StatelessWidget {
  const ProjectNewsView({
    super.key,
    required this.relatedArticles,
    this.scrollController,
  });

  final List<Article> relatedArticles;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    // List<Widget> suggestion = context.read<ProjectBloc>().state.articles?.map<Widget>((element)=>).toList();
    return ListView(
      controller: scrollController,
      children: [
        Container(
          alignment: Alignment.center,
          height: 500,
          child: Text(
            AppLocalizations.of(context)!.availableSoon,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const NewsLetterPrompt(),
        const AhlDivider(leading: 0, trailing: 0),
        //  ...suggestion,
        const AhlDivider(leading: 0, trailing: 0),
        const AhlFooter(),
      ],
    );
  }
}
