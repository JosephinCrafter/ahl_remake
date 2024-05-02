import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.symmetric(vertical: Margins.mobileLarge),
            child: Text(
              "Qui sommes nous?",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const WhoWeAreTile(),
        ],
      ),
    );
  }
}

class WhoWeAreTile extends StatelessWidget {
  const WhoWeAreTile({super.key});

  static const String imagePath = 'statics/who_we_are/les_soeurs_ndd.png';
  static const String titlePath = 'statics/setup';
  static const String titleIndex = 'who_we_are_title';

  Future<Uint8List?> getImage() async {
    return await storage.child(imagePath).getData();
  }

  Future<String> getTitle() async {
    DocumentSnapshot<Map<String, dynamic>> result =
        await firestore.doc(titlePath).get();

    final String url = result.get(titleIndex) as String;
    if (kDebugMode) {
      print('image Url : $url');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AhlCard(
        image: Expanded(
          flex: 2,
          child: FutureBuilder(
            future: getImage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.all(Margins.mobileSmall),
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
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(Margins.mobileSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(
                      BorderSizes.small,
                    ),
                  ),
                  child: const CircularProgressIndicator(),
                );
              } else {
                return Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Text(
                    "Error loading image: ${snapshot.error}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                );
              }
            },
          ),
        ),
        title: FutureBuilder(
          future: getTitle(),
          builder: (context, snapshot) => (snapshot.hasData)
              ? Text(
                  snapshot.data!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.displaySmall,
                )
              : const Text("..."),
        ),
      ),
    );
  }
}
