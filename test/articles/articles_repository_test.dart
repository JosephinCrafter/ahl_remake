// Test on ArticleRepository class
// - Responsibility:
//   - provide article objects to the whole app
//     -  getArticleOfTheMonth()
//           ""get the highlight article of the month.
//
//              First, it read setup document in articles collection.
//              Then, gather the highlighted article from setup and display it.
//              ""
//     -  getArticleByName()
//     -  foldArticles(number)
//     -  AllArticles()
//     -  setUp()
//
// Because, this class interact directly to the backend api. It's function
// should return Future objects.

import 'package:ahl/src/article_view/data/data.dart';
import 'package:ahl/src/article_view/model/article.dart';
import 'package:ahl/src/firebase_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// A matcher of a null article.
const Article noArticle = Article(
  id: 'no_article',
);

class MockArticlesRepository extends Mock implements ArticlesRepository {}

void main() {
  group('Test on getArticleOfTheMonth', () {
    FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
    ArticlesRepository repo =
        ArticlesRepository(firestoreInstance: fakeFirestore);

    test('Get highlighted article without error', () async {
      // add an article to firestore
      populate(fakeFirestore);

      // create a setup
      setupRepo(fakeFirestore, highLight: 'some_article');
      // get articleOfTheMonth
      Article? highLight = await repo.getArticleOfTheMonth();

      expect(
        highLight,
        isNotNull,
      );
      expect(highLight!.title, 'Some Article');
      fakeFirestore = FakeFirebaseFirestore();
    }); // Remove setup from fakeFirestore

    ;
    test('Throws a UnableToGetSetup, no setup', () async {
      // use another fakeFirestore instead of the above
      fakeFirestore = FakeFirebaseFirestore();

      // populate without setup
      populate(fakeFirestore);
      repo = ArticlesRepository(firestoreInstance: fakeFirestore);
      await expectLater(
          repo.getArticleOfTheMonth(), throwsA(isA<UnableToGetSetup>()));
    });
  });
}

void populate(
  FirebaseFirestore fakeFirestore, {
  String? id,
  String? title,
  String? content,
}) {
  var someArticle = id ?? 'some_article';
  // populate the data
  var someArticleMap = {
    idKey: someArticle,
    titleKey: 'Some Article',
    contentKey: 'Some Content',
  };
  fakeFirestore
      .collection(articlesCollection)
      .doc(someArticle)
      .set(someArticleMap);
}

void setupRepo(FirebaseFirestore fakeFirestore,
    {String highLight = 'some_article'}) {
  var setupDoc = 'setup';
  var setup = {
    SetUp.highLightKey: highLight,
  };
  fakeFirestore.collection(articlesCollection).doc(setupDoc).set(setup);
}
