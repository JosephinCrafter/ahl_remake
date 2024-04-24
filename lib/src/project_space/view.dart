import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

class ProjectsSpaceView extends StatelessWidget {
  const ProjectsSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      // title
      SectionTitle(
        color: AhlTheme.blackCharcoal,
        title: AppLocalizations.of(context)!.projectsSpace,
        subtitle: AppLocalizations.of(context)!.projectsSpaceSubtitle,
      ),
      // introduction
      Padding(
        padding: const EdgeInsets.all(Paddings.medium),
        child: Text(
          AppLocalizations.of(context)!.projectsSpaceIntroduction,
        ),
      ),
      const SizedBox(
        height: 45,
      ),
      // prayers intention
      Align(
        alignment: Alignment.bottomCenter,
        child: ProjectsCarousel(
          children: List.generate(
            5,
            (int index) => Align(
              alignment: Alignment.center,
              // width: 500,
              child: ProjectCard(
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
                label: Text(
                  "Projet en cours",
                ),
                title: Text(
                  "$index Cantines",
                ),
                description: Text(
                  "Pour les enfants d'aujourd'hui",
                ),
              ),
            ),
          ),
        ),
      ),
    ];

    return SpaceView(
      useGradient: false,
      children: children,
    );
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
  late PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _controller = PageController();
    _currentIndex = 0;
  }

  void updateCurrentIndex(int value) {
    setState(
      () => _currentIndex = value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 493 + 15 * 2 + 10),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.loose(
              const Size.fromHeight(493),
            ),
            child: PageView(
              controller: _controller,
              onPageChanged: (value) => updateCurrentIndex(value),
              allowImplicitScrolling: true,
              scrollBehavior: MaterialScrollBehavior(),
              children: widget.children,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Paddings.listSeparator),
            child: CustomPageIndicator(
              pageCount: widget.children.length,
              currentIndex: _currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({
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
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Container(
          constraints: widget.constraints ??
              const BoxConstraints.expand(
                height: 493,
                width: 341,
              ),
          decoration: widget.outerDecoration ??
              BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: AhlTheme.blueNight,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(BorderSizes.big),
              ),
          child: Column(
            children: [
              widget.image,
              widget.content ??
                  Expanded(
                    flex: 1,
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      padding: const EdgeInsets.all(
                        Paddings.medium,
                      ),
                      child: Column(
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
                              child: widget.label ?? const SizedBox.shrink()),

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
                            child:
                                widget.description ?? const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
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
      margin: const EdgeInsets.symmetric(horizontal: Margins.mobileSmall),
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
