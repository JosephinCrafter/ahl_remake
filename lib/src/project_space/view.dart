import 'dart:developer';
import 'dart:typed_data';

import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/pages/homepage/donation/donation_page.dart';
import 'package:ahl/src/pages/projects/project_page_view.dart';
import 'package:ahl/src/pages/projects/projects_page.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/utils/storage_utils.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:session_storage/session_storage.dart';

import '../ahl_barrel.dart';
import '../article_view/state/state.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import 'model.dart';

class ProjectsSpaceView extends StatefulWidget {
  const ProjectsSpaceView({super.key});

  @override
  State<ProjectsSpaceView> createState() => _ProjectsSpaceViewState();
}

class _ProjectsSpaceViewState extends State<ProjectsSpaceView>
    with AutomaticKeepAliveClientMixin {
  List<ArticleStorageUtils> storageUtils = [];
  late List<Future> futureImageCovers;

  ArticleState<Article>? state;

  Map<String, Article?>? projects;

  final SessionStorage _cache = SessionStorage();
  final String _projectsCardsKey = '_ProjectCardsKey';

  @override
  void initState() {
    super.initState();

    final ProjectBloc bloc = context.read<ProjectBloc>();

    // Listen for state changes
    bloc.stream.listen(
      (incomingState) {
        updateState(
          incomingState,
        );
      },
    );

    // Fetch the initial project list
    bloc.add(const GetArticleListEvent(foldLength: 3));

    // Initialize state
    state = bloc.state;

    updateState(state!);
  }

  void updateState(ArticleState<Article> incomingState) {
    setState(
      () {
        state = incomingState;
        projects = state?.articles;

        /// Build firebase storage utils for each project.
        if (projects != null) {
          for (var project in projects!.values) {
            storageUtils.add(
              ArticleStorageUtils(
                article: project!,
                collection: 'projects',
              ),
            );
          }
        }

        /// Launch get image for each of the Storage utils.
        if (storageUtils.isNotEmpty) {
          futureImageCovers = storageUtils
              .map<Future>(
                (element) => element.getCoverImage(),
              )
              .toList();
        }
      },
    );

    developer.log('state in projects has changed: $incomingState');
  }

  @override
  bool get wantKeepAlive {
    if (_cache[_projectsCardsKey] != null &&
        _cache[_projectsCardsKey] == "true") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (state == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Paddings.big),
        child: LinearProgressIndicator(),
      );
    }
    // Transform project list into widgets
    final projectCards = buildProjectCards(state?.articles?.values.toList());

    return SpaceView(
      useGradient: false,
      // headerImage: AssetImage(AhlAssets.projectSpaceCover),
      children: [
        // Title
        SectionTitle(
          titleColor: AhlTheme.blackCharcoal,
          title: AppLocalizations.of(context)!.projectsSpace,
          subtitle: AppLocalizations.of(context)!.projectsSpaceSubtitle,
        ),
        // Introduction
        Container(
          constraints: BoxConstraints(
            maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
          ),
          padding: const EdgeInsets.all(Paddings.medium),
          child: Text(
            AppLocalizations.of(context)!.projectsSpaceIntroduction,
          ),
        ),
        // Projects Carousel
        Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          runSpacing: Paddings.listSeparator,
          spacing: Paddings.listSeparator,
          children: projectCards,
        ),
        // Buttons
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            // vertical: Paddings.huge,
          ).copyWith(top: Paddings.huge),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 20,
            runSpacing: 20,
            children: [
              TextButton(
                onPressed: () {
                  context.goNamed(
                    DonationPage.routeName,
                  );
                },
                child: Text(AppLocalizations.of(context)!.supportProject),
              ),
              const SizedBox(width: Paddings.listSeparator),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  context.goNamed(ProjectsPage.routeName);
                },
                child: Text(AppLocalizations.of(context)!.allProjects),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCard(BuildContext context, Uint8List imageData, Article project) {
    return AhlCard(
      callback: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ProjectPageView(
        //       collection: projectsCollection,
        //       project: project,
        //     ),
        //   ),
        // );
        context.goNamed(
          ProjectsPage.routeName,
          pathParameters: {"projectId": project.id},
        );

        log("${project.contentPath}");
      },
      image: Container(
        // margin: const EdgeInsets.all(Paddings.medium),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MemoryImage(imageData),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(BorderSizes.small),
        ),
      ),
      label: Text(
        LocalizedProject.getProjectStatus(
                context, "${project.relations?[0]['status']}") ??
            "",
      ),
      title: Text(
        "${project.title}",
      ),
    );
  }

  List<Widget> buildProjectCards(List<Article?>? projects) {
    _cache[_projectsCardsKey] = "true";

    return (projects != null)
        ? projects.map<Widget>((project) {
            if (project != null) {
              final futureImageCover =
                  futureImageCovers[projects.indexOf(project)];
              return FutureBuilder(
                future: futureImageCover,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildCard(
                      context,
                      snapshot.data!,
                      project,
                    );
                  } else {
                    return Container(
                      height: 250,
                      width: 270,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }).toList()
        : [];
    // } else {
    //   return projects!.map<Widget>(
    //     (project) {
    //       final storageUtil = storageUtils?[projects.indexOf(project)];
    //       return buildCard(
    //           context,
    //           decodeUint8ListFromString(
    //             storageUtil!.cache[storageUtil.coverImageDataKey]!,
    //           ),
    //           project!);
    //     },
    //   ).toList();
    // }
  }
}

class ProjectsCarousel extends StatefulWidget {
  const ProjectsCarousel({
    super.key,
    required this.children,
  });
  final List<Widget> children;

  @override
  State<ProjectsCarousel> createState() => _ProjectsCarouselState();
}

class _ProjectsCarouselState extends State<ProjectsCarousel> {
  late PageController _pageController;
  late ScrollController _listController;
  late int _currentIndex;
  final int _opacity = 0x25;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      keepPage: true,
    );

    _listController = ScrollController();
    _currentIndex = 0;
  }

  void updateCurrentIndex(int value) {
    int oldIndex = _currentIndex;
    print('{list} Current old: $oldIndex');
    setState(() {
      _currentIndex = value % widget.children.length;

      developer.log('Screen size: ${MediaQuery.of(context).size.width}');
    });
    if (MediaQuery.of(context).size.width <= ScreenSizes.small) {
      print('{page}Current Index: $_currentIndex');

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
      );
    } else {
      print('{list} Current Index: $_currentIndex');

      _listController.animateTo(
        350.0 * (_currentIndex - oldIndex),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void isHovered(bool isHovered) {
    setState(
      () => _isHovered = isHovered,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 493 + 15 * 2 + 10),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    const Size.fromHeight(493),
                  ),
                  child: (MediaQuery.of(context).size.width <=
                          ScreenSizes.small)
                      ? PageView(
                          controller: _pageController,
                          onPageChanged: (value) => updateCurrentIndex(value),
                          children: widget.children,
                        )
                      : ListView(
                          controller: _listController,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: false,
                          children: widget.children,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Paddings.listSeparator),
                child: CustomPageIndicator(
                  pageCount: widget.children.length,
                  currentIndex: _currentIndex,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                updateCurrentIndex(_currentIndex - 1);
              },
              onHover: isHovered,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color:
                    Theme.of(context).colorScheme.secondaryContainer.withAlpha(
                          _isHovered ? 0xAA : 0x25,
                        ),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 48,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                updateCurrentIndex(_currentIndex + 1);
              },
              onHover: isHovered,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color:
                    Theme.of(context).colorScheme.secondaryContainer.withAlpha(
                          _isHovered ? 0xAA : 0x25,
                        ),
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 48,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AhlCard extends StatefulWidget {
  const AhlCard({
    super.key,
    this.constraints,
    this.outerDecoration,
    required this.image,
    this.title,
    this.label,
    this.description,
    this.content,
    this.callback,
  });

  final BoxConstraints? constraints;
  final BoxDecoration? outerDecoration;
  final Widget image;
  final Widget? title;
  final Widget? label;
  final Widget? description;
  final VoidCallback? callback;

  /// if [content] is provided then [title], [label] and [description] is omitted.
  final Widget? content;

  @override
  State<AhlCard> createState() => _AhlCardState();
}

class _AhlCardState extends State<AhlCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this);
  }

  void setHoveringTo(bool isHovered) {
    setState(
      () => _isHovered = isHovered,
    );
    if (isHovered) {
      animation.forward();
    } else {
      animation.reverse();
    }
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double borderThickness = _isHovered ? 5 : 3;
    BorderRadius borderRadius = BorderRadius.circular(BorderSizes.big);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
        ),
        padding: const EdgeInsets.all(Paddings.medium),
        child: Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderOnForeground: true,
          borderRadius: borderRadius,
          child: InkWell(
            onHover: (value) {
              setHoveringTo(value);
            },
            onTap: () {
              // Implement navigation to article view
              if (widget.callback != null) widget.callback!();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              clipBehavior: Clip.hardEdge,
              constraints: widget.constraints ??
                  const BoxConstraints(
                    maxHeight: 270,
                    maxWidth: 278,
                  ),
              decoration: widget.outerDecoration ??
                  BoxDecoration(
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignInside,
                      width: 3, //borderThickness,
                      color: _isHovered
                          ? Theme.of(context).primaryColor
                          : AhlTheme.lightGrey,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: borderRadius,
                  ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 770),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.all(Paddings.medium),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          // image: DecorationImage(
                          //   image: MemoryImage(snapshot.data!),
                          //   fit: BoxFit.cover,
                          // ),
                          borderRadius:
                              BorderRadius.circular(BorderSizes.small),
                        ),
                        child: widget.image
                            .animate(controller: animation, autoPlay: false)
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.25, 1.25),
                            ),
                      ),
                    ),
                    widget.content ??
                        Container(
                          // constraints: const BoxConstraints.expand(height: 100),
                          padding: const EdgeInsets.all(
                            Paddings.medium,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Label
                              DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  child:
                                      widget.label ?? const SizedBox.shrink()),

                              /// title
                              DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                child: widget.title ?? const SizedBox.shrink(),
                              ),

                              /// Description
                              DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                child: widget.description ??
                                    const SizedBox.shrink(),
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
      ),
    );
  }
}

class CustomPageIndicator extends StatefulWidget {
  final int pageCount;
  final int currentIndex;

  const CustomPageIndicator(
      {super.key, required this.pageCount, required this.currentIndex});

  @override
  _CustomPageIndicatorState createState() => _CustomPageIndicatorState();
}

class _CustomPageIndicatorState extends State<CustomPageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.pageCount, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutBack,
      margin: const EdgeInsets.symmetric(horizontal: Margins.small),
      decoration: BoxDecoration(
        color: index == widget.currentIndex
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
      width: index == widget.currentIndex ? 30.0 : 8.0,
      height: 8.0,
    );
  }
}
