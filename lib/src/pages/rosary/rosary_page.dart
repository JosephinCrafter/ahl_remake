import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/widgets/widgets.dart';

import '../../ahl_barrel.dart';

class RosaryPage extends StatefulWidget {
  const RosaryPage({super.key});

  static const String routeName = '/rosary';

  @override
  State<RosaryPage> createState() => _RosaryPageState();
}

class _RosaryPageState extends State<RosaryPage> {
  late PageController controller;

  @override
  void initState() {
    super.initState();

    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AhlAppBar(),
      drawer: const AhlDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'images/view-boat-water-with-flowers.webp',
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 350,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BorderSizes.big),
            color: Colors.white.withAlpha(0x88),
          ),
          child: PageView(
            controller: controller,
            children: [
              Padding(
                padding: const EdgeInsets.all(Paddings.medium),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Espace du Rosaire',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const Text("Bientôt Disponible"),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(45),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        controller.nextPage(
                          duration: Durations.medium3,
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.getNotified,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  const NewsLetterPrompt(),
                  Padding(
                    padding: const EdgeInsets.all(Paddings.medium),
                    child: IconButton(
                      onPressed: () => controller.previousPage(
                        curve: Curves.easeIn,
                        duration: Durations.medium3,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
