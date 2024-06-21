import 'dart:async';
import 'dart:developer';

import 'package:ahl/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Change this to true if using emulator
const bool isUsingEmulator = false;

/// Email key in users document in firestore.
const String emailKey = 'email:';

/// Subscription Date key in users document in firestore.
const String dateKey = 'subscriptionDate';

/// Collection names

/// collections name in the root document.
const String newsletterCollection = 'users';

/// The name of the collection containing articles.
const String articlesCollection = 'articles';

/// PrayerRequest collection name
const String prayerRequestCollection = 'prayer_requests';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final Reference _storage = FirebaseStorage.instance.ref();

const String emulatorHost = 'localhost';
const int firestorePort = 46561;
const int storagePort = 9199;
const int authPort = 9099;
const int hostingPort = 5000;

FirebaseApp? _firebaseAppInstance;

/// Get firebase initialization
Future<FirebaseApp?> get firebaseApp async {
  if (_firebaseAppInstance == null) {
    try {
      // firebase initialization
      final FirebaseApp firebaseApp = await Firebase.initializeApp(
        // doesn't await this allows the app to run without firebase
        options: DefaultFirebaseOptions.currentPlatform,
      ).then((value) {
        return value;
      });

      // env update
      _firebaseAppInstance = firebaseApp;

      return firebaseApp;
    } catch (e) {
      _isInitialized = false;
      _firebaseAppInstance = null;
      return null;
    }
  } else {
    return _firebaseAppInstance!;
  }
}

/// Get the instance of firestore in the app.
FirebaseFirestore get firestore {
  initialize();
  return _firestore;
}

Reference get storage {
  initialize();
  return _storage;
}

/// Get status if plugins are initialized.
bool get isInitialized => _isInitialized;

/// internal initialization state.
bool _isInitialized = false;


/// we re initialize the firebase plugin.
void initialize() {
  if (_isInitialized == false) {
    _initialize();
  }
}
/// Perform firebase initialization.
///
/// Typically, it setup firebase to work on emulator in debug mode.
/// This enable offline data caching too.
Future<void> _initialize() async {
  if (!_isInitialized) {
    try {
      if (_firebaseAppInstance == null) {
        await firebaseApp;
      }

      // persistence data settings
      _firestore.settings = const Settings(
        persistenceEnabled: true,
      );

      // emulator setup
      if (kDebugMode && isUsingEmulator) {
        _firestore.useFirestoreEmulator(emulatorHost, firestorePort);
        _storage.storage.useStorageEmulator(emulatorHost, storagePort);
      }

      // automatic caching
      _storage.storage.app.setAutomaticResourceManagementEnabled(true);

      // env update
      _isInitialized = true;

      //     // notify that the firebase plugin in correctly initialized
      log('[Firebase Init] : Correctly initialized.');
    } catch (e) {
      _isInitialized = false;
      log('[Firebase Init] : Failed initializing firebase: e');
    }
  }
}
