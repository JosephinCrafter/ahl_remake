import "package:ahl/src/ahl_barrel.dart";
import "package:ahl/src/utils/breakpoint_resolver.dart";
import "package:flutter/foundation.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

import 'package:http/http.dart' as http;

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView>
    with AutomaticKeepAliveClientMixin {
  Uint8List? imageData;

  @override
  bool get wantKeepAlive => true;

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
                  child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/aujourdhuilavenir.appspot.com/o/partners%2Fmadia_logo.png?alt=media&token=b6c38793-6cc5-45fc-8d8d-cd6a36a80091"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
