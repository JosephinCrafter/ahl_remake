import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/pages/homepage/hero_header/hero_header.dart';
import 'package:ahl/src/pages/homepage/welcoming/welcoming.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/partners/view.dart';
import 'package:ahl/src/prayers_space/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../project_space/view.dart';
import '../../who_we_are/view.dart';

/// Home page

class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  const HomePage({super.key});

  static const List<Widget> _children = [
    HeroHeaderView(),
    WelcomingView(),
    HighlightArticleTile(),
    PrayerSpaceView(),
    ProjectsSpaceView(),
    PartnersView(),
    WhoWeAreSpace(),
    NewsLetterPrompt(),
    AhlFooter(),
  ];

  @override
  Widget build(BuildContext context) {
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
              ListView(
                  addAutomaticKeepAlives: true,
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

                  children: _children,
                  ),
              inConstructionPromotionalBar,
            ],
          ),
        );
      },
    );
  }
}
