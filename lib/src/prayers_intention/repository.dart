part of 'prayer_request.dart';

class PrayerRequestRepo {
  PrayerRequestRepo({required this.db});

  FirebaseFirestore db;

  void write(PrayerRequest request) {

    /// updating setup
    Map<String, dynamic> data = {
      '${request.hashCode}': {
        'id': request.hashCode,
        'date': dayMonthYear(request.dateTime),
        'prayerType': request.prayerType.name,
      },
    };

    /// saving prayer
    db.doc('$prayerRequestCollection/setup').set(
          data,
          SetOptions(
            merge: true,
          ),
        );
    db
        .doc(
            '$prayerRequestCollection/${dayMonthYear(request.dateTime)}/${request.prayerType.name}/${request.hashCode}')
        .set(
          request.toDoc(),
        );
  }

  /// Helper on dd-mm-yyyy date formatting
  String dayMonthYear(DateTime date) =>
      '${date.day}-${date.month}-${date.year}';

  //todo: add how to know all path mechanism
  List getPrayersWithDate(
    DateTime date,
    PrayerType prayerType,
  ) {
    db.collection(
        '$prayerRequestCollection/${date.day}-${date.month}-${date.year}/${prayerType.name}/');

    return [];
  }
}
