import 'package:ahl/src/widgets/widgets.dart';
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
      appBar: const AhlAppBar(),
      body: Center(
        child: Text(
          'Prayer Space',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
