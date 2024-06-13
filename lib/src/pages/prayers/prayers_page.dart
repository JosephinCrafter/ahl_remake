import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PrayersPage extends StatefulWidget {
  const PrayersPage({super.key});

  static const String routeName = '/prayers';

  @override
  State<PrayersPage> createState() => _PrayersPageState();
}

class _PrayersPageState extends State<PrayersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AhlAppBar(),
      body: Center(
        child: Text(
          'Prayers Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
