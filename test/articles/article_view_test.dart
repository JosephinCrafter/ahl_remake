import "package:cloud_firestore/cloud_firestore.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_article/firebase_article.dart" as fa;
import "package:firebase_storage/firebase_storage.dart";
import "package:firebase_storage_mocks/firebase_storage_mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "package:ahl/src/article_view/view/article_view.dart";

FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
FirebaseStorage fakeStorage = MockFirebaseStorage();

void main() {
  /// initialize storage mocks
  populate();
  testWidgets(
    'Display properly the highlighted article',
    (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Article View test"),
          ),
          body: ArticleView(
            isHighLight: true,
            firestore: fakeFirestore,
            storage: fakeStorage,
          ),
        ),
      );

      await tester.pumpWidget(app);
      expect(find.text("This is the highLight article content."), findsOneWidget);
    },
  );
}

void populate() {
  String articleTitle = "highLight";
  fakeFirestore
      .doc("articles/setup")
      .set({fa.RepoSetUp.highLight: articleTitle});

  fakeFirestore.doc("articles/$articleTitle").set({
    fa.idKey: articleTitle,
    fa.titleKey: 'The $articleTitle Article',
    fa.releaseDateKey: "02/03/2024",
    fa.contentKey: "articles/$articleTitle/content.md",
    fa.relationsKey: [],
  });

  fakeStorage.ref("articles/$articleTitle/content.md").putString(
        "This is the $articleTitle article content.",
      );
}
