import 'package:flutter/material.dart';

class RosaryPage extends StatefulWidget {
  const RosaryPage({super.key});

  static const String routeName = '/rosary';

  @override
  State<RosaryPage> createState() => _RosaryPageState();
}

class _RosaryPageState extends State<RosaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://aujourdhuilavenir.org/assets/assets/view-boat-water-with-flowers.webp',
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Rosary Space',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const Text("Bientôt Disponible"),
          ],
        ),
      ),
    );
  }
}
