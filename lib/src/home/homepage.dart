import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/home/hero_header/hero_header.dart';
import 'package:ahl/src/home/welcoming/welcoming.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/prayers_space/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Home page

class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  const HomePage({super.key});

  static const List<Widget> _children = [
    HeroHeaderView(),
    WelcomingView(),
    PrayerSpaceView(),
    NewsLetterPrompt(),
    AhlFooter(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          endDrawer: constraints.maxWidth <= ScreenSizes.tablet
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
              ListView.separated(
                  itemCount: _children.length,
                  itemBuilder: (context, index) => _children[index],
                  separatorBuilder: (context, index) {
                    if (index == _children.length - 2) {
                      return const SizedBox.shrink();
                    } else {
                      return SizedBox.fromSize(
                        size: const Size.fromHeight(100),
                      );
                    }
                  }),
              inConstructionPromotionalBar,
            ],
          ),
        );
      },
    );
  }
}
