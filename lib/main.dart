import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:meta_seo/meta_seo.dart';

import 'src/app.dart';
import 'src/firebase_constants.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/theme/theme.dart';
// test on github auto deploy

void main() async {
  /// Meta Seo Setup
  if(kIsWeb){
    MetaSEO().config();
  }

  // ensure flutter is initialized
  // WidgetsFlutterBinding.ensureInitialized();

  // Make the app url based
  usePathUrlStrategy();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  // here we go with firebase setup.
  // It is better to await this flutter app, but when working offline, it makes
  // the app not loading.

  runApp(
    ChangeNotifierProvider.value(
      value: settingsController,
      child: FutureBuilder(
        future: firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MyApp(
              settingsController: settingsController,
            );
          } else {
            return Container(
              color: AhlTheme.background,
              child: LottieBuilder.asset(
              'animations/loading.json',
              repeat: true,),
            );
          }
        },
      ),
    ),
  );
}
