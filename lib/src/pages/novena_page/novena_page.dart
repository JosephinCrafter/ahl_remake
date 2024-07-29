import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';

class NovenaPage extends StatefulWidget {
  const NovenaPage({super.key, required this.novena});

  static const routeName = 'novena';
  final Article novena;

  @override
  State<NovenaPage> createState() => _NovenaPageState();
}

class _NovenaPageState extends State<NovenaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AhlDrawer(),
      appBar: AhlAppBar(
        bottomBar: Container(
          padding: const EdgeInsets.all(Paddings.small),
          child: PopupMenuButton(
            itemBuilder: (context) => List.generate(
              10,
              (index) => PopupMenuItem(
                child: Text(' $index'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
