import 'package:ahl/src/rosary/rosary.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../widgets/widgets.dart';
import '../prayers_intention/prayer_request.dart';
// import 'package:ahl/src/prayers_intention/prayers_intention.dart';

class PrayerSpaceView extends StatelessWidget {
  const PrayerSpaceView({super.key});

  static void showAvailableSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              AppLocalizations.of(context)!.availableSoon,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
            ),
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final saintCard = Builder(
    builder: (context) => Padding(
      padding: const EdgeInsets.all(Paddings.big),
      child: PromptCard(
        callback: () => showAvailableSoonSnackBar(context),
        backgroundImage: AssetImage(
          AhlAssets.heroBkAlt,
        ),
        title: Text(
          AppLocalizations.of(context)!.todaySaint,
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.availableSoon,
        ),
      ),
    ),
  );

  static final officeCard = Builder(
    builder: (context) => Padding(
      padding: const EdgeInsets.all(Paddings.big),
      child: PromptCard(
        callback: () => showAvailableSoonSnackBar(context),
        backgroundImage: AssetImage(
          AhlAssets.heroBkAlt,
        ),
        title: Text(
          AppLocalizations.of(context)!.office,
        ),
        subtitle: Text(
          AppLocalizations.of(context)!.availableSoon,
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      // title
      SectionTitle(
        title: AppLocalizations.of(context)!.priesSpace,
      ),
      Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: [
          // rosary
          const Padding(
            padding: EdgeInsets.all(Paddings.big),
            child: RosaryPrompt(),
          ),
          saintCard,
          officeCard,
          const SizedBox(
            height: 45,
          ),
        ],
      ),
      // prayers intention
      const Align(
        alignment: Alignment.bottomCenter,
        child: PrayersIntentionRequestView(),
      ),
    ];

    return SpaceView(
      useGradient: false,
      headerImage: AssetImage(
        AhlAssets.prayersSpaceCover,
      ),
      children: children,
    );
  }
}
