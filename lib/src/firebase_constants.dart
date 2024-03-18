import 'package:ahl/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Email key in users document in firestore.
const String emailKey = 'email:';

/// Subscription Date key in users document in firestore.
const String dateKey = 'subscriptionDate';

/// Collection names

/// collections name in the root document.
const String newsletterCollection = 'users';

/// The name of the collection containing articles.
const String articlesCollection = 'articles';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

const String emulatorHost = 'localhost';
const int firestorePort = 46561;
const int storagePort = 9199;
const int authPort = 9099;
const int hostingPort = 5000;

/// Get firebase initialization
Future<FirebaseApp> firebaseApp = Firebase.initializeApp(
  // doesn't await this allows the app to run without firebase
  options: DefaultFirebaseOptions.currentPlatform,
);

/// Get the instance of firestore in the app.
FirebaseFirestore get firestore {
  _initialize();
  return _firestore;
}

/// Get status if plugins are initialized.
bool get isInitialized => _isInitialized;

/// internal initialization state.
bool _isInitialized = false;

/// Perform firebase initialization.
///
/// Typically, it setup firebase to work on emulator in debug mode.
void _initialize() {
  if (kDebugMode && !_isInitialized) {
    _firestore.useFirestoreEmulator(emulatorHost, firestorePort);
  }
  _isInitialized = true;
}

/// we re initialize the firebase plugin.
void initialize() {
  _isInitialized = false;
  _initialize();
}
