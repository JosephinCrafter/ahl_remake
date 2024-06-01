part of 'prayer_request.dart';

const option = [
  "Messe",
  "Chapelet",
  "Vêpre",
];

enum PrayerType {
  mass,
  rosary,
  vesper,
}

extension PrayerTypeToString on PrayerType {
  static List getList(BuildContext context) {
    return [
      AppLocalizations.of(context)!.choiceMass,
      AppLocalizations.of(context)!.choiceRosary,
      AppLocalizations.of(context)!.choiceVesper,
    ];
  }

  String localizedToString(BuildContext context) {
    switch (this) {
      case PrayerType.mass:
        return AppLocalizations.of(context)!.choiceMass;
      case PrayerType.rosary:
        return AppLocalizations.of(context)!.choiceRosary;
      case PrayerType.vesper:
        return AppLocalizations.of(context)!.choiceVesper;
      default:
        return "$this";
    }
  }

  String localizedToStringWithArticle(BuildContext context) {
    switch (this) {
      case PrayerType.mass:
        return AppLocalizations.of(context)!.mass;
      case PrayerType.rosary:
        return AppLocalizations.of(context)!.rosary;
      case PrayerType.vesper:
        return AppLocalizations.of(context)!.vesper;
      default:
        return "$this";
    }
  }

  TimeOfDay get time {
    switch (this) {
      case PrayerType.mass:
        return const TimeOfDay(
          hour: 6,
          minute: 0,
        );
      case PrayerType.rosary:
        return const TimeOfDay(
          hour: 11,
          minute: 45,
        );
      case PrayerType.vesper:
        return const TimeOfDay(
          hour: 18,
          minute: 0,
        );
      default:
        return const TimeOfDay(
          hour: 18,
          minute: 0,
        );
    }
  }

  String get name {
    switch (this) {
      case PrayerType.rosary:
        return 'Rosary';
      case PrayerType.mass:
        return 'Mass';
      case PrayerType.vesper:
        return 'Vesper';
      default:
        return '$this';
    }
  }
}

class PrayerRequest {
  const PrayerRequest({
    this.name,
    required this.email,
    required this.dateTime,
    required this.prayer,
    required this.prayerType,
  });

  final String? name;
  final String email;
  final DateTime dateTime;
  final String prayer;
  final PrayerType prayerType;

  PrayerRequest copyWith({
    String? name,
    String? email,
    DateTime? dateTime,
    String? prayer,
    PrayerType? prayerType,
  }) =>
      PrayerRequest(
          email: email ?? this.email,
          dateTime: dateTime ?? this.dateTime,
          prayer: prayer ?? this.prayer,
          prayerType: prayerType ?? this.prayerType,
          name: name ?? this.name);

  @override
  String toString() => """
  Request: {
    name: ${name ?? "null"},
    email: $email,
    prayer: $prayer,
    date: ${dateTime.toLocal().toString()},
    prayerType: $prayerType
  }
""";

  Map<String, dynamic> toDoc() {
    return {
      'name': name,
      'email': email,
      'prayer': prayer,
      'date': dateTime,
      'prayerType': prayerType.name,
    };
  }

  factory PrayerRequest.fromDoc(Map<String, dynamic> doc) {
    return PrayerRequest(
      email: doc['email'],
      dateTime: doc['date'],
      prayer: doc['prayer'],
      prayerType: doc['prayerType'],
      name: doc['name'],
    );
  }
}
