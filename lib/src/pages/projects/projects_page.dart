import 'dart:developer';
import 'dart:typed_data';

import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/state/state.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/pages/who_we_are/who_we_are.dart';
import 'package:ahl/src/partners/view.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/project_space/view.dart';
import 'package:ahl/src/theme/theme.dart';
import 'package:ahl/src/utils/storage_utils.dart';
import 'package:ahl/src/who_we_are/view.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../article_view/view/article_view.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  static const String routeName = '/projects';
  static ScrollController controller = ScrollController();

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AhlDrawer(),
      appBar: const AhlAppBar(),

      /// The project and all page are organized as list views
      /// and individual components that follows each over.
      body: ListView(
        controller: ProjectsPage.controller,
        children: const [
          HeroImage(),
          Gap(20),
          Header(),
          Gap(50),
          PartnersView(),
          Gap(50),
          InProgressProjectListView(),
          Gap(50),
          AhlDivider.symmetric(
            space: 25,
          ),
          Gap(25),
          SuggestionSection(),
          Gap(50),
          AhlFooter(),
        ],
      ),
    );
  }
}

class AhlDivider extends StatelessWidget {
  const AhlDivider({
    super.key,
    required this.leading,
    required this.trailing,
    this.thickness,
    this.isSized = true,
  });

  const AhlDivider.symmetric({
    super.key,
    required double space,
    this.thickness,
    this.isSized = true,
  })  : leading = space,
        trailing = space;

  final double leading;
  final double trailing;
  final double? thickness;
  final bool isSized;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: (isSized)
            ? BoxConstraints(
                maxWidth:
                    ContentSize.maxWidth(MediaQuery.of(context).size.width),
              )
            : null,
        margin: EdgeInsets.only(
          left: leading,
          right: trailing,
        ),
        child: Container(
          height: thickness ?? 5,
          color: AhlTheme.yellowRelax,
        ),
      ),
    );
  }
}

class SuggestionSection extends StatelessWidget {
  const SuggestionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Margins.small),
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(
            MediaQuery.of(context).size.width,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              // overlayColor: Colors.black26,
              backgroundBuilder: (context, states, child) {
            return FutureBuilder(
                future: WhoWeAreTileState().getImage(),
                builder: (context, snapshot) {
                  return Align(
                    child: AnimatedContainer(
                      duration: Durations.long1,
                      curve: Curves.easeInOut,
                      height: 150,
                      decoration: (snapshot.hasData)
                          ? BoxDecoration(
                              image: DecorationImage(
                                alignment: const Alignment(-1, -0.3),
                                image: MemoryImage(snapshot.data!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                      alignment: Alignment.center,
                      child: Container(
                        color: (snapshot.hasData) ? Colors.black38 : null,
                        alignment: Alignment.center,
                        child: DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: (snapshot.hasData)
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null),
                          child: child ?? const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  );
                });
          }),
          onPressed: () => Navigator.pushNamed(context, WhoWeArePage.routeName),
          child: Text(AppLocalizations.of(context)!.whoWeAre),
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Margins.small,
        ),
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(
            MediaQuery.of(context).size.width,
          ),
          maxHeight: resolveForBreakPoint(
            MediaQuery.of(context).size.width,
            other: 330,
            small: 133,
            medium: 133,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            resolveForBreakPoint(
              MediaQuery.of(context).size.width,
              other: BorderSizes.huge,
              small: BorderSizes.small,
              medium: BorderSizes.small,
            ),
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              AhlAssets.projectSpaceCover,
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Margins.small,
        ),
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.projectSpaceTitle,
              style: Theme.of(context).textTheme.displaySmall,
              // textAlign: TextAlign.center,
            ),
            const Gap(10),
            Text(
              AppLocalizations.of(context)!.projectsSpaceSubtitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(20),
            Text(
              AppLocalizations.of(context)!.projectSpaceDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Gap(50),
            Align(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  ProjectsPage.controller.animateTo(
                    947,
                    duration: Durations.long1,
                    curve: Curves.easeIn,
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.allProjects,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InProgressProjectListView extends StatefulWidget {
  const InProgressProjectListView({super.key});

  @override
  State<InProgressProjectListView> createState() =>
      _InProgressProjectListViewState();
}

class _InProgressProjectListViewState extends State<InProgressProjectListView> {
  @override
  void initState() {
    super.initState();

    context.read<ProjectBloc>().add(
          const GetArticleListEvent(foldLength: 100),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const AllArticleView();
  }
}

/// This widget displays all article based on their status in a horizontal list.
///
/// First, we trigger all article list and then make a filter to separate
/// in progress and achieved projects. To do so, we listen to ProjectBloc.
class AllArticleView extends StatefulWidget {
  const AllArticleView({super.key});

  @override
  State<AllArticleView> createState() => _AllArticleViewState();
}

class _AllArticleViewState extends State<AllArticleView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectBloc, ArticleState<Article>>(
      builder: (BuildContext context, ArticleState<Article> state) {
        List<Article?>? projectInProgress = state.articles
            ?.where(
                (article) => article?.relations?[0]['status'] == 'inProgress')
            .toList();
        List<Article?>? projectWaiting = state.articles
            ?.where((article) =>
                article?.relations?[0]['status'] == 'waitingBudget')
            .toList();

        List<Article?>? projectDone = state.articles
            ?.where((article) => article?.relations?[0]['status'] == 'done')
            .toList();

        switch (state.status) {
          case ArticleStatus.succeed:
            return Column(
              children: [
                if (projectInProgress != null && projectInProgress.isNotEmpty)
                  ProjectsView(
                    title: 'Projet en cours',
                    articles: projectInProgress,
                  ),
                if (projectWaiting != null && projectWaiting.isNotEmpty) ...[
                  const Gap(45),
                  ProjectsView(
                    title: 'Projet en attente de financement',
                    articles: projectWaiting,
                  ),
                ],
                if (projectDone != null && projectDone.isNotEmpty) ...[
                  const Gap(45),
                  ProjectsView(
                    title: 'Projet achevé',
                    articles: projectDone,
                  ),
                ],
              ],
            );
          case ArticleStatus.failed:
            return Align(child: Text("Failed:${state.error}"));
          default:
            return Container(
              alignment: Alignment.center,
              height: 702,
              child: const CircularProgressIndicator(),
            );
        }
      },
      listener: (context, state) {},
    );
  }
}

class ProjectsView extends StatefulWidget {
  const ProjectsView({
    super.key,
    required this.title,
    this.subtitle,
    required this.articles,
  });

  final List<Article?> articles;

  final String title;
  final String? subtitle;

  @override
  State<ProjectsView> createState() {
    return _ProjectsViewState();
  }
}

class _ProjectsViewState extends State<ProjectsView> {
  final ScrollController _controller = ScrollController();

  List<Widget> buildProjectWidget(BuildContext context) {
    List<Widget> projectWidgets = [];
    for (Article? article in widget.articles) {
      if (article != null) {
        projectWidgets.add(
          buildCard(
            context,
            article,
          ),
        );
      }
    }
    return projectWidgets;
  }

  Widget buildCard(BuildContext context, Article article) {
    return AhlCard(
      callback: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleContentPage(
              collection: projectsCollection,
              article: article,
            ),
          ),
        );

        log("${article.contentPath}");
      },
      image: Flexible(
        flex: 2,
        child: FutureBuilder(
            future: ArticleStorageUtils(
              article: article,
              collection: projectsCollection,
            ).getCoverImage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.all(Paddings.medium),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(BorderSizes.small),
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
            }),
      ),
      label: Text(
        "${article.relations?[0]['status']}",
      ),
      title: Text(
        "${article.title}",
      ),
    ).animate().fadeIn(curve: Curves.easeIn).slideY(begin: 0.125, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
      ),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
            ),
            margin: const EdgeInsets.symmetric(horizontal: Margins.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _controller.animateTo(
                        _controller.offset - 300,
                        duration: Durations.long1,
                        curve: Curves.easeIn,
                      ),
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                    IconButton(
                      onPressed: () => _controller.animateTo(
                        _controller.offset + 300,
                        duration: Durations.long1,
                        curve: Curves.easeIn,
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
            ),
            alignment: Alignment.centerLeft,
            child: (widget.subtitle != null) ? Text(widget.subtitle!) : null,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: 330,
            ),
            alignment: Alignment.center,
            child: ListView(
              controller: _controller,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: buildProjectWidget(context),
            ),
          ),
        ],
      ),
    );
  }
}
