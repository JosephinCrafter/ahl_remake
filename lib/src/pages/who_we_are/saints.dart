import 'package:flutter/material.dart';

class WhoWeArePage extends StatefulWidget {
  const WhoWeArePage({super.key});

  static const String routeName = '/whoWeAre';

  @override
  State<WhoWeArePage> createState() => _WhoWeArePageState();
}

class _WhoWeArePageState extends State<WhoWeArePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'WhoWeAre Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
