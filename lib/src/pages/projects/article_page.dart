import 'package:flutter/material.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  static const String routeName = '/articles';

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Project Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
