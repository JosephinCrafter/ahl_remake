import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:gap/gap.dart';

import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/prayers_space/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import '../../ahl_barrel.dart';
import '../../utils/breakpoint_resolver.dart';
import '../projects/projects_page.dart';

class PrayersPage extends StatefulWidget {
  const PrayersPage({super.key});

  static const String routeName = '/prayers';

  @override
  State<PrayersPage> createState() => _PrayersPageState();
}

class _PrayersPageState extends State<PrayersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AhlAppBar(),
      body: ListView(
        children: [
          const PrayerSpaceView(),
          Gap(resolveSeparatorSize(context)),
          const AhlDivider.symmetric(
            space: 25,
          ),
          Gap(resolveSeparatorSize(context)),
          SuggestionSection(
            callback: () => Navigator.pushNamed(context, PrayersPage.routeName),
            image: Future.value(
              AssetImage(
                AhlAssets.prayersSpaceCover,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.prayerSpace,
            ),
          ),
          Gap(resolveSeparatorSize(context)),
          SuggestionSection(
            callback: () =>
                Navigator.pushNamed(context, ProjectsPage.routeName),
            image: Future.value(
              AssetImage(
                AhlAssets.projectSpaceCover,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.projectSpaceTitle,
            ),
          ),
          Gap(resolveSeparatorSize(context)),
          const AhlDivider.symmetric(
            space: 25,
          ),
          Gap(resolveSeparatorSize(context)),
          const NewsLetterPrompt(),
          const AhlFooter(),
        ],
      ),
    );
  }
}
