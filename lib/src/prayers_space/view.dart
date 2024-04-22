import 'package:ahl/src/rosary/rosary.dart';
import 'package:ahl/src/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../widgets/widgets.dart';
import '../prayers_intention/prayer_request.dart';
// import 'package:ahl/src/prayers_intention/prayers_intention.dart';

class PrayerSpaceView extends StatelessWidget {
  const PrayerSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      // title
      SectionTitle(
        title: AppLocalizations.of(context)!.priesSpace,
      ),
      // rosary
      const Padding(
        padding: EdgeInsets.all(Paddings.big),
        child: RosaryPrompt(),
      ),
      const SizedBox(
        height: 45,
      ),
      // prayers intention
      const Align(
        alignment: Alignment.bottomCenter,
        child: PrayersIntentionRequestView(),
      ),
    ];

    return SpaceView(
      headerImage: AssetImage(
        AhlAssets.prayersHeroHeader,
      ),
      children: children,
    );
  }
}
