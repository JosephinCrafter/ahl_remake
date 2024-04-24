import 'package:ahl/src/prayers_intention/prayer_request.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// PrayerRequestState:
///
/// This class is the bloc state.
///
/// - It need a [PrayerRequest] object as [PrayerRequestState.request]
///   that can be null on [PrayerRequestState.initial]
/// - A [PrayerRequestStatus] object as [PrayerRequestState.currentStatus] that
///   can't be null.

/// PrayerRequestBloc:
///
/// The bloc class for PrayerRequest management.
///
/// It handles these events:
/// - [PrayerRequestInitializeEvent] for initialization, and emit a [PrayerRequestState.initial]
/// - [PrayerRequestFilledDateEvent] when date is gotten from the ui,
///   emit a [PrayerRequestState.fillDate]
/// - [PrayerRequestFilledFormEvent] when prayer form is gotten from the ui,
///   emit a [PrayerRequestState.fillForm]
/// These event updates the current [PrayerRequest] object and always change
/// [PrayerRequestState.currentStatus] to the appropriate one.
///
/// [on<PrayerRequestInitializeEvent>] is called on the initialization of the bloc.
/// It emits a [PrayerRequestState.initial] at this time.

/// PrayerRequestStatus:
///
/// This status class can have 4 values:
/// - [PrayerRequestStatus.initial]
/// - [PrayerRequestStatus.filledDate]
/// - [PrayerRequestStatus.filledForm]
/// - [PrayerRequestStatus.complete]

/// PrayerRequestEvent:
///
/// Events are responsible of sending new information to change current state.
/// For this purpose, we need 4 event like status:
/// - [PrayerRequestInitializeEvent]
/// - [PrayerRequestFilledDateEvent]
/// - [PrayerRequestFilledFormEvent]
/// - [PrayerRequestCompletedEvent]
void main() {
  FirebaseFirestore firestore = FakeFirebaseFirestore();
  PrayerRequestRepo repo = PrayerRequestRepo(db: firestore);
  blocTest('a bloc that emit an initial state of PrayerIntentionBloc',
      build: () => PrayerRequestBloc(repo),
      // act: (bloc) => bloc.add(PrayerRequestInitializeEvent()),
      expect: () => [
            /// The initial state is clean and have not any value in
            /// PrayerRequest.
            ///
            /// It will set the [prayerRequest] object in state to null.
            isA<PrayerRequestInitialState>(),
          ]);
  group(
    'test on bloc filled interaction',
    () {
      var email = 'razafindrakotojosephin@gmail.com';
      var prayer = 'some prayer';
      var name = 'Josephin';
      var date = DateTime.now();
      var prayerType = PrayerType.mass;

      blocTest(
        'a bloc that emit a filled state of PrayerIntentionBloc',
        build: () => PrayerRequestBloc(repo),
        act: (bloc) => bloc.add(
          PrayerRequestFilledFormEvent(
            email: email,
            prayer: prayer,
            name: name,
          ),
        ),
        expect: () => [
          isA<PrayerRequestInitialState>(),
          isA<PrayerRequestFilledFormState>(),
        ],
      );
      blocTest(
        'a bloc that emit a request with all form',
        build: () => PrayerRequestBloc(repo),
        act: (bloc) => bloc.add(
          PrayerRequestFilledDateEvent(
            date: date,
            prayerType: prayerType,
          ),
        ),
        expect: () => [
          isA<PrayerRequestInitialState>(),
          isA<PrayerRequestFilledDateState>(),
        ],
      );

      blocTest(
        'a bloc that emit a full request',
        build: () => PrayerRequestBloc(repo),
        act: (bloc) => bloc.add(
          PrayerRequestCompletedEvent(
            email: email,
            prayer: prayer,
            name: name,
            date: date,
            prayerType: prayerType,
          ),
        ),
        expect: () => [
          isA<PrayerRequestInitialState>(),
          isA<PrayerRequestCompleteState>(),
        ],
      );
    },
  );
}
