// Test the data storage mechanism and triggering from firestore.
import 'package:ahl/src/article_view/data/data.dart';
import 'package:ahl/src/article_view/model/article.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:mockito/mockito.dart';

import '../articles/articles_repository_test.dart';

const emulatorHost = 'localhost';
const firestorePort = 46561;
const storagePort = 9199;
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
  FirebaseStorage fakeStorage = MockFirebaseStorage();

  // firestore = FirebaseFirestore.instance;
  fakeFirestore = FakeFirebaseFirestore();
  // firestore.useFirestoreEmulator(emulatorHost, firestorePort);

  // storage = FirebaseStorage.instance;
  // fakestorage = MockFirebaseStorage();
  // storage.useStorageEmulator(emulatorHost, storagePort);

  // setup fixtures
  String testCollectionName = 'test';
  // test document
  String docTest = 'DocTest';
  // test data
  Map<String, dynamic> testData = {'title': 'A test on firebase firestore'};

  /// a doc fixture
  Map<String, dynamic> doc = {
    'id': 'leves_toi_et_marches',
    'title': 'Leves toi et marches',
    'content': 'articles/leves_toi_et_marches/content.md',
    'releaseDate': '19/01/2024',
    'relations': [
      {
        'type': 'articles',
        'path': 'articles/carem/mercredi_des_cendres',
      },
    ],
  };
  group('Emulator operational verification', () {
    test('Write data to firestore', () async {
      await fakeFirestore
          .collection(testCollectionName)
          .doc(docTest)
          .set(testData, SetOptions(merge: true));

      await fakeFirestore.doc('$testCollectionName/$docTest').get();
    });
  });

  group(
    'Test on ArticleHelper class.',
    () {
      setUp(() {
        setupRepo(fakeFirestore);
        populate(
          fakeFirestore,
          id: 'some_article_name',
          title: 'Some Article Title',
          content: 'gs://',
        );
      });
      ArticlesRepository articleHelper =
          ArticlesRepository(firestoreInstance: fakeFirestore);
      test(
        'test on class method. This test should fail.',
        () {
          Future<Article?> articleOfTheMonth =
              articleHelper.getArticleOfTheMonth();
          Future<Article?> namedArticle =
              articleHelper.getArticleById(articleId: 'some_article_name');
        },
      );
      test('Get raw data from cloud firestore', () {
        ArticlesRepository articleHelper =
            ArticlesRepository(firestoreInstance: fakeFirestore);
        Future<Article?> namedArticle =
            articleHelper.getArticleById(articleId: 'leves_toi_et_marche');
      });
    },
  );

  group(
    'test on Article class.',
    () {
      test(
        'Instantiate an article without argument',
        () {
          Article article = const Article(id: 'some_article');

          var title = article.title;
          var releaseDate = article.releaseDate;
          var content = article.contentPath;
          var relations = article.relations;

          Article article1 = const Article(
            id: 'title',
            title: 'Title',
            releaseDate: '19/01/2024',
            contentPath: 'articles/some_content.md',
            relations: [
              {
                'type': 'image',
                'path': 'article/some_article/image.png',
              }
            ],
          );

          Article article2 = Article.fromDoc(doc);
          expect(article2.title == doc[titleKey], true);
          expect(article2.contentPath == doc[contentKey], true);
          expect(article2.relations == doc[relationsKey], true);
          expect(article2.releaseDate, doc[releaseDateKey]);

          expect(article2.toDoc(), equals(doc));
        },
      );
    },
  );
}

class MockArticleHelper with Mock implements ArticlesRepository {}
