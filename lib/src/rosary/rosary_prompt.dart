import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RosaryPrompt extends StatelessWidget {
  const RosaryPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final Reference imageRef = storage.child('/rosary/rosary_hero_header.jpg');
    final imageUrl = imageRef.getDownloadURL();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
        child: Stack(
          children: [
            FutureBuilder(
              future: imageUrl,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          snapshot.data!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }else if (snapshot.hasError){
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AhlAssets.logoFormTypoHorizontalColoredDark),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(Paddings.medium),
                constraints: const BoxConstraints.expand(height: 80),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chapelet du jour",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      "Mediter la vie de Jesus avec Marie",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
