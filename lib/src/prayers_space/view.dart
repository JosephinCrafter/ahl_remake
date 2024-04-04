import 'package:ahl/src/rosary/rosary_prompt.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../widgets/widgets.dart';
import '../prayers_intention/prayers_intention.dart';
// import 'package:ahl/src/prayers_intention/prayers_intention.dart';

class PrayerSpaceView extends StatelessWidget {
  const PrayerSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      // bk image
      Container(
        constraints: const BoxConstraints(minHeight: 650),
        decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.darken,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              AhlAssets.prayersHeroHeader,
            ),
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0x00000000),
              Color(0xFF2e2e2e),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),

      Column(
        children: [
          // title
          SectionTitle(
            title: AppLocalizations.of(context)!.priesSpace,
          ),
          // rosary
          const RosaryPrompt(),
          // prayers intention
          const Align(
            alignment: Alignment.bottomCenter,
            child: PrayersIntentionRequestView(),
          ),
        ],
      ),
    ];

    return Stack(
      // height: 2080,
      // width: 500,
      // enableDrag: true,
      children: List.generate(
        children.length,
        (index) => children[index],
      ),
    );
  }
}
