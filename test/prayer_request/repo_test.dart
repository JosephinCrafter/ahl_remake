import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/prayers_intention/prayer_request.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testing repository', () {
    PrayerRequest request = PrayerRequest(
      email: 'email',
      dateTime: DateTime.now(),
      prayer: 'prayer',
      prayerType: PrayerType.rosary,
    );
    PrayerRequestRepo repo = PrayerRequestRepo(
      db: FakeFirebaseFirestore(),
    );

    repo.write(request);
  });
}
