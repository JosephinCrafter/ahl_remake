import "dart:convert";
import "dart:developer";

import "package:ahl/src/ahl_barrel.dart";
import "package:ahl/src/firebase_constants.dart";
import "package:ahl/src/utils/breakpoint_resolver.dart";
import "package:ahl/src/utils/storage_utils.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

import 'package:http/http.dart' as http;
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

    //todo: setup caching
    // if (cache[partnersLogoCacheKey] != null) {
    //   final cached = cache[partnersLogoCacheKey]!;

    //   /// Prepare string to conversion.
    //   /// remove '[[' and "]]" at the beginning and end of the String,
    //   /// then split it using "],[" pattern. Then, transform to UInt8List.
    //   cached
    //       .substring(2, cached.length - 2)
    //       .split('],[')
    //       .map((element) => "[$element]")
    //       .forEach(
    //         (data) => partnersLogo.add(decodeUint8ListFromString(data)),
    //       );

    //   // return partnersLogo;
    // }

    ListResult? results;

    await storage.child('/partners').list().then((value) {
      results = value;
    });

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
              padding: const EdgeInsets.all(Paddings.big),
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
                  child: FutureBuilder(
                      future: images,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: snapshot.data!
                                .map<Widget>(
                                  (element) => Image.memory(element),
                                )
                                .toList(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(child: CircularProgressIndicator());
                        } else {
                          return Icon(Icons.warning);
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
