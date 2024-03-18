part of '../newsletter.dart';

const invalidEmailError = "Invalid Email";

class NewsletterSubscriptionBloc
    extends Bloc<NewsletterSubscriptionEvent, NewsletterSubscriptionState> {
  /// in super we add initial state.
  ///
  /// You should add an initialization state to make it work.
  NewsletterSubscriptionBloc({
    required this.repo,
  }) : super(
          NewsletterSubscriptionState.initial(),
        ) {
    on<SubscriptionRequestEvent>(_onSubscriptionRequest);
    on<InitializeRequestEvent>(_onInitializeRequest);
    on<LoadingEvent>(_onLoadingEvent);
    on<SuccessEvent>(_onSuccessEvent);
    on<ErrorEvent>(_onErrorEvent);
    // then, register a callback on subscribe event
    if (!_isListening) {
      _isListening = true;
      repo.status.listen(
        (event) {
          switch (event) {
            // Error
            case NewsletterSubscriptionStatus.error:
              add(
                ErrorEvent(),
              );
              break;

            // Loading
            case NewsletterSubscriptionStatus.loading:
              add(
                LoadingEvent(),
              );
              break;

            // Success
            case NewsletterSubscriptionStatus.success:
              add(
                SuccessEvent(),
              );
              break;

            default:
              break;
          }
        },
      );
    }
  }

  void _onErrorEvent(ErrorEvent event, emit) => emit(
        state.copyWith(
            status: NewsletterSubscriptionStatus.error, error: event.error),
      );

  // Loading
  void _onLoadingEvent(LoadingEvent event, emit) => emit(
        state.copyWith(status: NewsletterSubscriptionStatus.loading),
      );

  // Success
  void _onSuccessEvent(SuccessEvent event, emit) => emit(
        state.copyWith(
            status: NewsletterSubscriptionStatus.success, error: null),
      );

  /// The repo to be used when storing data.
  final NewsletterSubscriptionRepository repo;

  /// To prevent re listening to the stream
  bool _isListening = false;

  // Initialization Handler
  void _onInitializeRequest(
    InitializeRequestEvent event,
    Emitter<NewsletterSubscriptionState> emit,
  ) {
    /// emit initial state
    emit(NewsletterSubscriptionState.initial());
  }

  // Subscription event handler
  void _onSubscriptionRequest(SubscriptionRequestEvent event,
      Emitter<NewsletterSubscriptionState> emit) async {
    emit(
      state.copyWith(
        email: event.email,
        status: NewsletterSubscriptionStatus.loading,
        error: null,
      ),
    );

    // Test if the email is working and acting according to it
    if (event.email != null && event.email!.isNotEmpty) {
      if (isValidEmail(event.email!)) {
        emit(state.copyWith(
          status: NewsletterSubscriptionStatus.loading,
        ));
        await repo.subscribe(email: event.email!);
      } else {
        emit(
          state.copyWith(
              status: NewsletterSubscriptionStatus.error,
              error: invalidEmailError),
        );
      }
    } else {
      emit(
        state.copyWith(
          status: NewsletterSubscriptionStatus.error,
          error: invalidEmailError,
        ),
      );
    }
  }
}
