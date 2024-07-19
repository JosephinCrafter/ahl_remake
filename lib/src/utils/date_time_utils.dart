import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension DateTimeUtils on DateTime {
  static DateTime parseReleaseDate(String dateString) {
    // dateString.split('/').map<int?>((e) => int.tryParse(e));
    DateTime? date;
    try {
      date = DateTime.parse(dateString);
    } on FormatException catch (e) {
      log(
        'Error formatting release date: e. The required format should follow this pattern: yyyy-mm-dd. ReleaseDate: $dateString',
        error: e,
      );
    } catch (e, stacktrace) {
      log('Error occurred when parsing Article.releaseDate',
          error: e, stackTrace: stacktrace);
    } finally {
      date = date ?? DateTime.now();
    }
    return date;
  }

  static String localMonth(int month, BuildContext context) {
    switch (month) {
      case DateTime.january:
        return AppLocalizations.of(context)!.january;
      case DateTime.february:
        return AppLocalizations.of(context)!.february;
      case DateTime.march:
        return AppLocalizations.of(context)!.march;
      case DateTime.april:
        return AppLocalizations.of(context)!.april;
      case DateTime.may:
        return AppLocalizations.of(context)!.may;
      case DateTime.june:
        return AppLocalizations.of(context)!.june;
      case DateTime.july:
        return AppLocalizations.of(context)!.july;
      case DateTime.august:
        return AppLocalizations.of(context)!.august;
      case DateTime.september:
        return AppLocalizations.of(context)!.september;
      case DateTime.october:
        return AppLocalizations.of(context)!.october;
      case DateTime.november:
        return AppLocalizations.of(context)!.november;
      case DateTime.december:
        return AppLocalizations.of(context)!.december;
      default:
        return 'Month';
    }
  }

  static String localizedToString(
      {required DateTime dateTime, required BuildContext context}) {
    return "${dateTime.day} ${localMonth(dateTime.month, context)} ${dateTime.year}";
  }

  static String localizedFromStringDate(
      {required String? dateString, required BuildContext context}) {
    if (dateString == null || dateString.isEmpty) {
      throw ArgumentError('dateString is empty or null');
    }
    DateTime dateTime = parseReleaseDate(dateString);

    return localizedToString(dateTime: dateTime, context: context);
  }
}
