import 'package:ahl/ahl_barrel.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/pages/homepage/hero_header/hero_header.dart';
import 'package:ahl/src/pages/homepage/welcoming/welcoming.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/partners/view.dart';
import 'package:ahl/src/prayers_space/view.dart';
import 'package:ahl/src/theme/theme.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../project_space/view.dart';
import '../../who_we_are/view.dart';

/// Home page

class HomePage extends StatefulWidget {
  static const String routeName = "home";

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static late ScrollController scrollController;

  bool controllerIsAttached = false;

  final List<Widget> _children = [
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const WelcomingView(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    Container(color: Colors.white, height: 4),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const HighlightArticleTile(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    Container(color: Colors.white, height: 4),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const PrayerSpaceView(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const ProjectsSpaceView(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const PartnersView(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const WhoWeAreSpace(),
    Builder(builder: (context) => Gap(resolveSeparatorSize(context))),
    const NewsLetterPrompt(),
    const AhlFooter(),
  ];

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController(
      onAttach: (position) async {
        await Future.delayed(Duration.zero);
        setState(
          () => controllerIsAttached = true,
        );
      },
      onDetach: (position) async {
        await Future.delayed(Durations.short1);
        setState(
          () => controllerIsAttached = false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Optimize hero header image.
    precacheImage(AssetImage(AhlAssets.heroBk), context);

    return LayoutBuilder(
      key: const Key('main_scroll_view'),
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          endDrawer: constraints.maxWidth <= ScreenSizes.large
              ? const AhlDrawer()
              : null,
          appBar: const AhlAppBar(),
          // AppBar(
          //   title: const AhlLogo(),
          //   actions: [
          //     TabBar(
          //       tabs: [
          //         Tab(
          //           text: AppLocalizations.of(context)!.homeText,
          //         ),
          //         Tab(
          //           text: AppLocalizations.of(context)!.aboutUs,
          //         ),
          //         Tab(
          //           text: AppLocalizations.of(context)!.prayers,
          //         ),
          //         Tab(
          //           text: AppLocalizations.of(context)!.ourProjects,
          //         ),
          //         Tab(
          //           text: AppLocalizations.of(context)!.listening,
          //         ),
          //       ],
          //     )
          //   ],
          // ),

          // Here are placed all components that build the entire
          // HomePage
          body: Stack(
            children: [
              // const SingleChildScrollView(
              // AnimatedPositioned(
              //   duration: Durations.medium1,
              //   // curve: Curves.easeInOut,
              //   bottom: _bottom,

              //   child:
              (constraints.maxWidth > ScreenSizes.large)
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 700,
                        constraints: BoxConstraints(
                          maxWidth: resolveForBreakPoint(
                            MediaQuery.of(context).size.width,
                            // other: 1483,
                            other: 1325,
                            large: 925,
                          ),
                        ),
                        child: Image.asset(AhlAssets.heroBk),
                      ).animate().fadeIn(
                            curve: Curves.easeIn,
                            duration: Durations.long4,
                          ),
                      // ),
                    )
                  : const SizedBox.shrink(),
              Scrollbar(
                controller: scrollController,
                // thumbVisibility: true,
                trackVisibility: true,

                thickness: 10,
                child: ListView(
                  addAutomaticKeepAlives: true,
                  controller: scrollController,

                  // itemCount: _children.length,
                  // itemBuilder: (context, index) => _children[index],
                  // separatorBuilder: (context, index) {
                  //   if (index == _children.length - 2) {
                  //     return const SizedBox.shrink();
                  //   } else {
                  //     return SizedBox.fromSize(
                  //       size: const Size.fromHeight(Margins.extraLarge),
                  //     );
                  //   }
                  // },
                  restorationId: "home_list_view",

                  children: [
                    // HeroHeaderView(),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //           top: Sizes.mobileHeroHeaderImageHeight)
                    //       .add(
                    //     const EdgeInsets.symmetric(
                    //       horizontal: Paddings.big,
                    //     ),
                    //   ),
                    //   child: const HeroTextView(
                    //     needMargin: true,
                    //     margin: 50,
                    //   ),
                    // ),
                    const HeroHeaderView(),
                    Container(
                      constraints: const BoxConstraints(
                          // maxHeight: 6000,
                          ),
                      // fix transparent background error.
                      color: AhlTheme.yellowLight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        key: const Key("main_homepage_column"),
                        children: _children,
                      ),
                    ),
                  ],
                  // child: Column(
                  //   children: _children,
                ),
              ),

              inConstructionPromotionalBar,
            ],
          ),
        );
      },
    );
  }
}
