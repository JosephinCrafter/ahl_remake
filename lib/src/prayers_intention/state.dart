part of 'prayer_request.dart';

class PrayerRequestState implements Equatable {
  const PrayerRequestState({this.request, required this.currentStatus});

  /// the prayer itself
  final PrayerRequest? request;

  /// status of the state
  final PrayerRequestStatus currentStatus;
  @override
  bool? get stringify => false;
  @override
  List<Object?> get props => [currentStatus, request];

  /// Create a copy of this state in a new object.
  PrayerRequestState copyWith({
    PrayerRequest? request,
    PrayerRequestStatus? status,
  }) =>
      PrayerRequestState(
        request: request ?? this.request,
        currentStatus: status ?? currentStatus,
      );

  @override
  String toString() => """
Request: $request,
currentStatus: $currentStatus,

""";
}

class PrayerRequestInitialState extends PrayerRequestState {
  const PrayerRequestInitialState()
      : super(request: null, currentStatus: PrayerRequestStatus.initial);
}

class PrayerRequestCompleteState extends PrayerRequestState {
  PrayerRequestCompleteState({
    required String email,
    required String prayer,
    String? name,
    required DateTime date,
    required PrayerType prayerType,
  }) : super(
          request: PrayerRequest(
            email: email,
            dateTime: date,
            prayer: prayer,
            prayerType: prayerType,
            name: name,
          ),
          currentStatus: PrayerRequestStatus.complete,
        );
}

class PrayerRequestFilledDateState extends PrayerRequestState {
  PrayerRequestFilledDateState({
    this.oldRequest,
    required DateTime date,
    required PrayerType prayerType,
  }) : super(
            request: PrayerRequest(
              name: oldRequest?.name,
              email: oldRequest?.email ?? 'email',
              dateTime: date,
              prayer: oldRequest?.prayer ?? "prayer",
              prayerType: prayerType,
            ),
            currentStatus: PrayerRequestStatus.filledDate);

  final PrayerRequest? oldRequest;
}

class PrayerRequestFilledFormState extends PrayerRequestState {
  PrayerRequestFilledFormState({
    this.oldRequest,
    required String email,
    required String prayer,
    String? name,
  }) : super(
          request: PrayerRequest(
            name: name ?? oldRequest?.name,
            email: email,
            dateTime: oldRequest?.dateTime ?? DateTime.now(),
            prayer: prayer,
            prayerType: oldRequest?.prayerType ?? PrayerType.mass,
          ),
          currentStatus: PrayerRequestStatus.filledForm,
        );

  final PrayerRequest? oldRequest;
}

// to be continued.
// class Smthg extends Cubit<PrayerRequest> {
//   Smthg()
//       : super(
//           PrayerRequest(
//             email: "email",
//             dateTime: DateTime.now(),
//             prayer: "prayer",
//             prayerType: PrayerType.mass,
//           ),
//         );

//   void fillDate(DateTime time, PrayerType prayerType)
// }
