import 'package:flutter/material.dart';

import '../app.dart';

class LocaleUtils {
  /// Switch app locale to
  static void changeLocale(BuildContext context, Locale newLocale) {
    MyApp.setLocal(context, newLocale);
    Scaffold.of(context).closeEndDrawer();
  }
}
