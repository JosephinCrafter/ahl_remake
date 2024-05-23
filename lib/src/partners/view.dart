import "package:ahl/src/ahl_barrel.dart";
import "package:ahl/src/utils/breakpoint_resolver.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 210),
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 1080,
          maxHeight: 210,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(Paddings.medium),
              child: Text(
                AppLocalizations.of(context)!.ourPartners,
                style: resolveHeadlineTextThemeForBreakPoints(
                  MediaQuery.of(context).size.width,
                  context,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints.tight(const Size.square(100)),
                  //todo: implement partner logo
                  // child: Image.network(),
                  child: const Placeholder(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
