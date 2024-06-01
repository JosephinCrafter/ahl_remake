part of 'prayer_request.dart';

enum PrayerRequestStatus {
  initial,
  filledDate,
  filledForm,

  /// When the PrayerRequest is ready to send.
  complete,
}

class PrayerRequestBloc extends Bloc<PrayerRequestEvent, PrayerRequestState> {
  PrayerRequestBloc(
    PrayerRequestRepo repository,
  )   : _repo = repository,
        super(_initialState) {
    on<PrayerRequestInitializeEvent>(_onInitializedEvent);
    on<PrayerRequestFilledFormEvent>(_onFilledFormEvent);
    on<PrayerRequestFilledDateEvent>(_onFilledDateEvent);
    on<PrayerRequestCompletedEvent>(_onCompletedEvent);

    /// Add an initialization event at creation.
    add(PrayerRequestInitializeEvent());
  }

  /// short hand variable for initial
  static const PrayerRequestState _initialState = PrayerRequestInitialState();

  /// PrayerRequestrepo
  final PrayerRequestRepo _repo;

  void _onInitializedEvent(PrayerRequestEvent event, Emitter emit) {
    if (state != _initialState) {
       /// Re emit a new state if the state is not initial.

    emit(_initialState);
    }

   
  }

  void _onFilledFormEvent(PrayerRequestFilledFormEvent event, Emitter emit) {
    emit(
      PrayerRequestFilledFormState(
        oldRequest: state.request,
        email: event.email,
        prayer: event.prayer,
        name: event.name,
      ),
    );
    print(state);
  }

  void _onFilledDateEvent(PrayerRequestFilledDateEvent event, Emitter emit) {
    emit(
      PrayerRequestFilledDateState(
        oldRequest: state.request,
        date: event.date,
        prayerType: event.prayerType,
      ),
    );
    print(state);
  }

  void _onCompletedEvent(PrayerRequestCompletedEvent event, Emitter emit) {
    emit(
      PrayerRequestCompleteState(
        name: event.name,
        email: event.email,
        prayer: event.prayer,
        date: event.date,
        prayerType: event.prayerType,
      ),
    );

    /// write request to back
    _repo.write(state.request!);
  }
}
