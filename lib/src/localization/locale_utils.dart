import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app.dart';

class LocaleUtils {
  /// Switch app locale to
  static void changeLocale(BuildContext context, Locale newLocale) {
    MyApp.setLocal(context, newLocale);
    Scaffold.of(context).closeEndDrawer();
  }
}
