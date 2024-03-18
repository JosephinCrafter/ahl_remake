part of 'data.dart';

/// The ArticleRepository abstraction class.
class ArticlesRepository {

  /// The repository of articles.
  ///
  /// [collection] is the string name of the collection in firestore.
  /// To open projects, simply change [collection] to [projectsCollection]
  /// and so on.
  ArticlesRepository({
    this.collection = articlesCollection,
    required this.firestoreInstance,
  });

  /// Name of the setup document
  static const String setUpDoc = 'setup';

  /// The FirebaseFirestore instance to be used.
  FirebaseFirestore firestoreInstance;

  /// The String name of the Firebase collection to be used.
  final String collection;

  /// Return a fully formed article given it's articleTitle
  Future<Article?> getArticleById({required String articleId}) async {
    DocumentSnapshot<Map<String, dynamic>> result = await getRawDoc(articleId);
    Map<String, dynamic>? map = result.data();
    if (map == null) {
      return null;
    }
    return buildArticleFromDoc(map);
  }

  /// Get the currently highlighted article in the setup documentation.
  Future<Article?> getArticleOfTheMonth() async {
    // First, read setup to get the document name of the currently highlighted
    // article.
    final String highlightedArticleDoc = await setUp.then<String>(
      (value) {
        if (value == null) {
          throw UnableToGetSetup('setup object is $value');
        }
        return value[SetUp.highLightKey] as String;
      },
    );

    return await getArticleById(articleId: highlightedArticleDoc);
  }

  /// Return a map string object containing setup
  Future<Map<String, dynamic>?> get setUp async =>
      await getRawDoc(setUpDoc).then<Map<String, dynamic>?>(
        (value) => value.data(),
      );

  Future<DocumentSnapshot<Map<String, dynamic>>> getRawDoc(String path) async =>
      await firestoreInstance.doc('$collection/$path').get();

  Article? buildArticleFromDoc(Map<String, dynamic> map) {
    return Article.fromDoc(map);
  }
}

class SetUp {
  static const String highLightKey = 'highLight';
}

class UnableToGetSetup extends Error {
  String? message;

  @pragma("vm:entry-point")
  UnableToGetSetup(this.message);

  @override
  String toString() => 'Unable to get Setup: $message';
}
