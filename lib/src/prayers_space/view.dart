import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/prayers_intention/prayers_intention.dart';
import 'package:flutter/material.dart';

class PrayerSpaceView extends StatelessWidget {
  const PrayerSpaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 250),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                AhlAssets.prayersHeroHeader,
              ),
            ),
          ),
        ),
        // const Column(
        //   children: [
        //     Text("Espace de Prières"),
        //     // PrayersIntentionRequestView(),
        //   ],
        // ),
      ],
    );
  }
}
