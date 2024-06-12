import 'dart:developer';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:ahl/src/utils/storage_utils.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:session_storage/session_storage.dart';

import '../project_space/view.dart';

class WhoWeAreSpace extends StatelessWidget {
  const WhoWeAreSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.large),
            child: SectionTitle(
              caretColor: Theme.of(context).primaryColor,
              isUpperCase: false,
              title: AppLocalizations.of(context)!.whoWeAre,
              titleStyle: resolveHeadlineTextThemeForBreakPoints(
                MediaQuery.of(context).size.width,
                context,
              ),
            ),
          ),
          const WhoWeAreTile(),
        ],
      ),
    );
  }
}

class WhoWeAreTile extends StatefulWidget {
  const WhoWeAreTile({super.key});

  static const String imagePath = 'statics/who_we_are/les_soeurs_ndd.png';
  static const String titlePath = 'statics/setup';
  static const String titleIndex = 'who_we_are_title';

  @override
  State<WhoWeAreTile> createState() => _WhoWeAreTileState();
}

class _WhoWeAreTileState extends State<WhoWeAreTile>
    with AutomaticKeepAliveClientMixin {
  final String whoWeAreImageKey = 'who_we_are_image_key';

  final String whoWeAreTitleKey = 'who_we_are_title_key';

  Uint8List? _data;

  final SessionStorage cache = SessionStorage();

  String? _title;
  Future<Uint8List?> getImage() async {
    _data = await storage.child(WhoWeAreTile.imagePath).getData();
    if (_data != null) {
      cache[whoWeAreImageKey] = encodeUint8ListToString(_data!);
    }
    return _data;
  }

  Future<String?> getTitle() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> result =
          await firestore.doc(WhoWeAreTile.titlePath).get();

      _title = result.get(WhoWeAreTile.titleIndex) as String;
      if (_title != null) {
        cache[whoWeAreTitleKey] = _title!;
      }
    } catch (e) {
      log('Error getting ${WhoWeAreTile.titlePath}');
      _title = '';
      return _title;
    }
    return _title;
  }

  @override
  bool get wantKeepAlive {
    if (cache[whoWeAreImageKey] != null && cache[whoWeAreTitleKey] != null) {
      _data = decodeUint8ListFromString(cache[whoWeAreImageKey]!);
      _title = cache[whoWeAreTitleKey];

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (wantKeepAlive) {
      return AhlCard(
        image: Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(Margins.small),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(
                  _data!,
                ),
              ),
              borderRadius: BorderRadius.circular(
                BorderSizes.small,
              ),
            ),
          ),
        ),
        title: FutureBuilder(
          future: getTitle(),
          builder: (context, snapshot) => Text(
            snapshot.data ?? "...",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    } else {
      return Container(
        child: AhlCard(
          image: Expanded(
            flex: 2,
            child: FutureBuilder(
              future: getImage(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.all(Margins.small),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          snapshot.data!,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        BorderSizes.small,
                      ),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(Margins.small),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        BorderSizes.small,
                      ),
                    ),
                    child: const CircularProgressIndicator(),
                  );
                } else {
                  print('${snapshot.error}');
                  return Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Text(
                      "Error loading image: ${snapshot.error}",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  );
                }
              },
            ),
          ),
          title: FutureBuilder(
            future: getTitle(),
            builder: (context, snapshot) => Text(
              snapshot.data ?? "...",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }
  }
}
