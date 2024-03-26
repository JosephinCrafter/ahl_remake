import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:parallax_effect/parallax_effect.dart';

import '../ahl_barrel.dart';
import '../widgets/widgets.dart';
import '../prayers_intention/prayers_intention.dart';
// import 'package:ahl/src/prayers_intention/prayers_intention.dart';

class PrayerSpaceView extends StatelessWidget {
  const PrayerSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
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
          SectionTitle(
            title: AppLocalizations.of(context)!.priesSpace,
          ),
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
