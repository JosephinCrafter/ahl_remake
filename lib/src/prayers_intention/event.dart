part of 'prayer_request.dart';


abstract class PrayerRequestEvent {}

class PrayerRequestInitializeEvent implements PrayerRequestEvent {}

class PrayerRequestFilledFormEvent implements PrayerRequestEvent {
  const PrayerRequestFilledFormEvent({
    required this.email,
    required this.prayer,
    this.name,
  });

  final String email;
  final String prayer;
  final String? name;
}

class PrayerRequestFilledDateEvent implements PrayerRequestEvent {
  const PrayerRequestFilledDateEvent({
    required this.date,
    required this.prayerType,
  });

  final DateTime date;
  final PrayerType prayerType;
}

class PrayerRequestCompletedEvent implements PrayerRequestEvent {
  const PrayerRequestCompletedEvent({
    required this.email,
    required this.prayer,
    this.name,
    required this.date,
    required this.prayerType,
  });

  final String email;
  final String prayer;
  final String? name;
  final DateTime date;
  final PrayerType prayerType;
}
