import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/project_space/model.dart';
import 'package:ahl/src/utils/storage_utils.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../article_view/bloc/bloc.dart';
import '../article_view/state/state.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class ProjectsSpaceView extends StatefulWidget {
  const ProjectsSpaceView({super.key});

  @override
  State<ProjectsSpaceView> createState() => _ProjectsSpaceViewState();
}

class _ProjectsSpaceViewState extends State<ProjectsSpaceView> {
  @override
  void initState() {
    context.read<ProjectBloc>().add(const GetArticleListEvent(foldLength: 3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo: change projectCards to result from backend
    final List<Widget> projectCards = List.generate(
      3,
      (int index) => AhlCard(
        image: Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(Paddings.medium),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AhlAssets.cantineImage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(BorderSizes.small),
            ),
          ),
        ),
        label: const Text(
          "Projet en cours",
        ),
        title: Text(
          "$index Cantines",
        ),
        // description: const Text(
        //   "Pour les enfants d'aujourd'hui",
        // ),
      ),
    );

    final List<Widget> children = [
      // title
      SectionTitle(
        titleColor: AhlTheme.blackCharcoal,
        title: AppLocalizations.of(context)!.projectsSpace,
        subtitle: AppLocalizations.of(context)!.projectsSpaceSubtitle,
      ),
      // introduction
      // Padding(
      //   padding: const EdgeInsets.all(Paddings.medium),
      //   child: Text(
      //     AppLocalizations.of(context)!.projectsSpaceIntroduction,
      //   ),
      // ),

      // prayers intention
      Wrap(
        // ProjectsCarousel(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: projectCards,
        //  List.from(
        //   projectCards.map<Widget>(
        //     (e) => Flexible(child: e),
        //     // Align(
        //     //     alignment: Alignment.center,
        //     //     // width: 500,
        //     //     child: e),
        //   ),
        // ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 20,
          runSpacing: 20,
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // todo: implement project found rising
              },
              child: const Text('Soutenir un projet'),
            ),
            const SizedBox(width: Paddings.listSeparator),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                // todo: implement all project page
              },
              child: Text("Voir tout les projet"),
            ),
          ],
        ),
      ),
    ];

    return BlocBuilder<ProjectBloc, ArticleState<Article>>(
        bloc: context.read<ProjectBloc>(),
        builder: (context, state) {
          print('state is type ${state.runtimeType}');
          // get projects from backends
          final projects = state.articles;

          // transform project list into widgets
          final List<Widget> projectCards = (projects != null)
              ? projects.map<Widget>(
                  (element) {
                    if (element != null) {
                      return FutureBuilder(
                        future: ArticleStorageUtils(
                                article: element, collection: 'projects')
                            .getCoverImage(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AhlCard(
                              image: Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.all(Paddings.medium),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        snapshot.data!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        BorderSizes.small),
                                  ),
                                ),
                              ),
                              label: Text(
                                "${element?.relations?[0]['status']}",
                              ),
                              title: Text(
                                "${element?.title}",
                              ),
                              // description: const Text(
                              //   "Pour les enfants d'aujourd'hui",
                              // ),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.warning_rounded),
                            );
                          }
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ).toList()
              : [];

          return SpaceView(
            useGradient: false,
            children: [
              // title
              SectionTitle(
                titleColor: AhlTheme.blackCharcoal,
                title: AppLocalizations.of(context)!.projectsSpace,
                subtitle: AppLocalizations.of(context)!.projectsSpaceSubtitle,
              ),
              // introduction
              // Padding(
              //   padding: const EdgeInsets.all(Paddings.medium),
              //   child: Text(
              //     AppLocalizations.of(context)!.projectsSpaceIntroduction,
              //   ),
              // ),

              // prayers intention
              Wrap(
                // ProjectsCarousel(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: projectCards,
                //  List.from(
                //   projectCards.map<Widget>(
                //     (e) => Flexible(child: e),
                //     // Align(
                //     //     alignment: Alignment.center,
                //     //     // width: 500,
                //     //     child: e),
                //   ),
                // ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 20,
                  runSpacing: 20,
                  // mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // todo: implement project found rising
                      },
                      child: const Text('Soutenir un projet'),
                    ),
                    const SizedBox(width: Paddings.listSeparator),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        // todo: implement all project page
                      },
                      child: Text("Voir tout les projet"),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
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
  int _opacity = 0x25;

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
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: InkWell(

          //     onTap: () {
          //       updateCurrentIndex(_currentIndex + 1);
          //     },
          //     onHover: (value) => isHovered(value),
          //     child: Container(
          //       constraints: BoxConstraints.loose(
          //           Size.square(Theme.of(context).iconTheme.size!)),
          //       child: Icon(
          //         Icons.chevron_left_rounded,
          //         size: _isHovered
          //             ? Theme.of(context).iconTheme.size! * 1.4
          //             : Theme.of(context).iconTheme.size,
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   constraints: const BoxConstraints.expand(),
          //   child: Container(
          //     child: IconButton(
          //       alignment: Alignment.centerRight,
          //       icon: InkWell(
          //         // todo: implement what tapping outside carousel do.
          //         onTap: () {},
          //         onHover: (value) => isHovered(value),
          //         child: const Icon(
          //           Icons.chevron_right_rounded,
          //         ),
          //       ),
          //       onPressed: () {},
          //     ),
          //   ),
          // ),

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
  });

  final BoxConstraints? constraints;
  final BoxDecoration? outerDecoration;
  final Widget image;
  final Widget? title;
  final Widget? label;
  final Widget? description;

  /// if [content] is provided then [title], [label] and [description] is omitted.
  final Widget? content;

  @override
  State<AhlCard> createState() => _AhlCardState();
}

class _AhlCardState extends State<AhlCard> {
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
  }

  void setHoveringTo(bool isHovered) {
    setState(
      () => _isHovered = isHovered,
    );
  }

  @override
  Widget build(BuildContext context) {
    double borderThickness = _isHovered ? 5 : 3;
    BorderRadius borderRadius = BorderRadius.circular(BorderSizes.big);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: const BoxConstraints(
          maxWidth: 345,
          maxHeight: 370,
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
              // todo: lead to article view
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              clipBehavior: Clip.hardEdge,
              constraints: widget.constraints ??
                  const BoxConstraints.expand(
                    height: 390,
                    width: 341,
                  ),
              decoration: widget.outerDecoration ??
                  BoxDecoration(
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignInside,
                      width: borderThickness,
                      color: _isHovered
                          ? AhlTheme.yellowRelax
                          : AhlTheme.blueNight,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: borderRadius,
                  ),
              child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Column(
                  children: [
                    widget.image,
                    widget.content ??
                        Container(
                          // constraints: const BoxConstraints.expand(height: 100),
                          padding: const EdgeInsets.all(
                            Paddings.medium,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Column(
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
