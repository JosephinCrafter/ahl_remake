part of 'newsletter.dart';

class NewsletterSubscriptionRepository {
  NewsletterSubscriptionRepository({
    required FirebaseFirestore database,
  }) : _db = database;

  final _controller = StreamController<NewsletterSubscriptionStatus>();

  final FirebaseFirestore _db;

  Stream<NewsletterSubscriptionStatus> get status async* {
    yield* _controller.stream;
  }

  /// Getter of the data to be written
  Map<String, dynamic> data(String email) => {
        emailKey: email,
        dateKey: Timestamp.now(),
      };

  /// Handle initialization
  void initialize() {
    _controller.add(NewsletterSubscriptionStatus.initial);
  }

  /// Handle subscription
  Future<void> subscribe({
    required String email,
  }) async {
    // Writes to firebase firestore document
    return _db
        .collection(newsletterCollection)
        .doc(email)
        .set(
          data(email),
          SetOptions(merge: true),
        )
        .then(
          (value) => _controller.add(NewsletterSubscriptionStatus.success),
        )
        .onError(
          (e, _) => _controller.add(NewsletterSubscriptionStatus.error),
        );
  }
}
