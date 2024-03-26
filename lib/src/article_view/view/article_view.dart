import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import "../data/data.dart";

class ArticleView extends StatelessWidget {
  const ArticleView({super.key, this.args});

  static const String routeName = '/articles';
  final dynamic args;

  final String articleTitle = 'leves_toi_et_marches';

  void callback() async {
    ArticlesRepository helper =
        ArticlesRepository(firestoreInstance: firestore);
    if (kDebugMode) {
      print(
        await helper.getArticleById(articleId: articleTitle),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        endDrawer: constraints.maxWidth <= ScreenSizes.tablet
            ? const AhlDrawer()
            : null,
        appBar: const AhlAppBar(),
        body: Row(children: [
          const Spacer(flex: 1),
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: DefaultAssetBundle.of(context).load('assets/content.md'),
              builder: (context, snapshot) {
                switch (snapshot.hasData) {
                  case true:
                    return MarkdownWidget(
                      data: snapshot.data.toString(),
                    );

                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          ),
          const Spacer(
            flex: 1,
          )
        ]),
      ),
    );
  }
}
