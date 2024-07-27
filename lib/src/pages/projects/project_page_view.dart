import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/theme/theme.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../article_view/state/state.dart';
import '../../article_view/view/article_view.dart';
import '../../newsletter/newsletter.dart';
import '../../pages/homepage/donation/donation_page.dart';
import '../../pages/projects/projects_page.dart';
import '../../project_space/bloc.dart';
import '../../widgets/widgets.dart';

class ProjectPageView extends StatelessWidget {
  const ProjectPageView({
    super.key,
    this.project,
    this.collection = "projects",
    this.projectId,
  }) : assert(project != null || projectId != null,
            "On the project or projectId must be supplied"); // change this to the build relations

  /// The current project to be displayed
  final Article? project;
  final String collection;
  final String? projectId;

  @override
  Widget build(BuildContext context) {
    if (project != null) {
      return _ProjectPageContentView(project: project);
    }
    // When no project is provided but instead, a projectId
    return BlocBuilder<ProjectBloc, ArticleState<Article>>(
      buildWhen: (previous, current) {
        bool needCallBuilder = true;

        if (previous.articles == null) {
          needCallBuilder = true;
        } else {
          needCallBuilder = !previous.articles!.keys.contains(projectId);
        }

        return needCallBuilder;
      },
      builder: (context, state) {
        context.read<ProjectBloc>().add(GetArticleByIdEvent(id: projectId));
        // get project
        var project = state.articles?[projectId!];

        // Make decision based on UI

        // 1 case: every thing works fine:
        //    - a real project is returned by project bloc
        if (project != null) {
          return _ProjectPageContentView(
            project: project,
            collection: collection,
          );
        } else if (state.status == ArticleStatus.initial) {
          return Container(
            color: AhlTheme.background,
            child: Center(
              child: LottieBuilder.asset(
                'animations/loading.json',
                repeat: true,
              ),
            ),
          );
        } else {
          return Container(
            color: AhlTheme.background,
            child: Center(
              child: LottieBuilder.asset(
                'animations/loading.json',
                repeat: true,
              ),
            ),
          );
        }
      },
    );
  }
}

class _ProjectPageContentView extends StatefulWidget {
  const _ProjectPageContentView({
    super.key,
    required this.project,
    this.collection = "projects",
  });
  final Article? project;
  final String collection;

  @override
  State<_ProjectPageContentView> createState() =>
      _ProjectPageContentViewState();
}

class _ProjectPageContentViewState extends State<_ProjectPageContentView>
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
      if (!needDisplayTitleInAppBar) {
        setState(() => needDisplayTitleInAppBar = true);
      }
    } else if (needDisplayTitleInAppBar) {
      setState(() => needDisplayTitleInAppBar = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    var title = widget.project?.title;
    // var value = needDisplayTitleInAppBar ? 1.0 : 0.0;
    return Scaffold(
      key: ValueKey(widget.project),
      appBar: AhlAppBar(
        preferredSize: const Size.fromHeight(75 + 64),
        bottomBar: Flexible(
          flex: 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // constraints: const BoxConstraints(maxWidth: 1024),
                  width: screenWidth / 2 - 20,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(
                  //   horizontal: resolveForBreakPoint(
                  //     screenWidth,
                  //     other: Margins.small,
                  //     extraHuge: Margins.extraHuge,
                  //     huge: Margins.huge,
                  //     extraLarge: Margins.extraLarge,
                  //     large: Margins.large,
                  //   ),
                  // ),
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
                    duration: Durations.medium1,
                    layoutBuilder:
                        (topChild, topChildKey, bottomChild, bottomChildKey) {
                      return Container(
                        key: topChildKey,
                        child: topChild
                            .animate(
                              autoPlay: false,
                              target: needDisplayTitleInAppBar ? 1 : 0,
                            )
                            .fadeIn()
                            .slideY(begin: 1),
                      );
                    },
                  ),
                ),
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
      body: (widget.project != null)
          ? TabBarView(
              controller: _tabController,
              children: [
                ProjectDescriptionContentView(
                  key: ValueKey("${widget.project?.id}_description"),
                  article: widget.project!,
                  scrollController: _descriptionScrollController,
                ),
                ProjectNewsView(
                  key: ValueKey("${widget.project?.id}_news"),
                  scrollController: _newsScrollController,
                ),
              ],
            )
          : Builder(
              builder: (context) {
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(
                    content: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                        child: Row(
                          children: [
                            const Text(
                              "Le contenu est introuvable.",
                            ),
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: Icon(
                                Icons.close_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                context.goNamed(ProjectsPage.routeName);
                return const Center(
                  child: Text("Project non disponible."),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        child: SizedBox.square(
          dimension: IconSizes.medium,
          child: SvgPicture.asset('images/SVG/dons_alt.svg'),
        ),
        onPressed: () {
          Navigator.pushNamed(context, DonationPage.routeName,
              arguments: widget.project);
        },
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

  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      height: 700,
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> suggestion = context.read<ProjectBloc>().state.articles?.map<Widget>((element)=>).toList();
    return ListView(
      controller: scrollController,
      children: [
        ArticleContentView(
          isProject: true,
          article: article,
          collection: "/projects",
        ),
        Gap(
          resolveSeparatorSize(context),
        ),
        const NewsLetterPrompt(),
        const AhlDivider(leading: 0, trailing: 0),
        buildSuggestions(context),
        const AhlDivider(leading: 0, trailing: 0),
        const AhlFooter(),
      ],
    );
  }
}

class ProjectNewsView extends StatelessWidget {
  const ProjectNewsView({
    super.key,
    this.scrollController,
  });

  final ScrollController? scrollController;

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
