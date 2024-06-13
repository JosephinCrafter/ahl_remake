import 'package:flutter/material.dart';

class SaintsPage extends StatefulWidget {
  const SaintsPage({super.key});

  static const String routeName = '/saints';

  @override
  State<SaintsPage> createState() => _SaintsPageState();
}

class _SaintsPageState extends State<SaintsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Saints Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
