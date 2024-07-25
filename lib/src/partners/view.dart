import 'dart:developer';

import "package:flutter/material.dart";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:gap/gap.dart";

import "package:ahl/src/ahl_barrel.dart";
import "package:ahl/src/firebase_constants.dart";
import "package:ahl/src/theme/theme.dart";
import "package:ahl/src/utils/breakpoint_resolver.dart";

import "package:session_storage/session_storage.dart";

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

  /// Get images from firebase_storage
  Future<List<Uint8List>?> computeImage() async {
    String partnersLogoCacheKey = 'partnersLogo';
    SessionStorage cache = SessionStorage();

    List<Uint8List> partnersLogo = [];

    ListResult? results;
    try {
      await storage.child('/partners').list().then(
        (value) {
          results = value;
        },
      );
    } catch (e) {
      log('[Partners]: Error loading partners logo: $e');
    }
    if (results != null) {
      for (Reference ref in results!.items) {
        final Uint8List? data = await ref.getData();
        if (data != null) {
          partnersLogo.add(data);
        }
      }
    }

    if (partnersLogo != []) {
      cache[partnersLogoCacheKey] = partnersLogo.toString();
    }

    return partnersLogo;
  }

  @override
  void initState() {
    super.initState();

    images = computeImage();
  }

  Future<List<Uint8List>?>? images;

  @override
  Widget build(BuildContext context) {
    computeImage();
    super.build(context);
    return Container(
      alignment: Alignment.center,
      // constraints: const BoxConstraints.expand(height: 245),
      color: Colors.white,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
          maxHeight: 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Paddings.big),
              child: Text(
                AppLocalizations.of(context)!.ourPartners,
                style: resolveHeadlineTextThemeForBreakPoints(
                  MediaQuery.of(context).size.width,
                  context,
                )!
                    .copyWith(color: AhlTheme.blackCharcoal),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints.tight(const Size.square(150)),
                  child: FutureBuilder(
                    future: images,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: snapshot.data!
                              .map<Widget>(
                                (element) => Container(
                                  clipBehavior: Clip.hardEdge,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      BorderSizes.small,
                                    ),
                                  ),
                                  // borderOnForeground: true,
                                  child: Image.memory(element),
                                ).animate().fadeIn(),
                              )
                              .toList(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Align(
                          // alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const Icon(Icons.warning_rounded);
                      }
                    },
                  ),
                ),
              ],
            ),
            const Gap(45),
          ],
        ),
      ),
    );
  }
}
