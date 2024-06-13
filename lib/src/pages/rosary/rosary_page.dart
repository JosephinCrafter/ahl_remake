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
      body: Center(
        child: Text(
          'Rosary Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
