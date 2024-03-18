part of '../newsletter.dart';

/// The event carry data (here email) from the UI to the
/// bloc. Then the bloc return the state object containing status.
///
class NewsletterSubscriptionEvent {
  const NewsletterSubscriptionEvent({this.email});

  /// The email string gathered from prompt.
  final String? email;
}

class SubscriptionRequestEvent extends NewsletterSubscriptionEvent {
  SubscriptionRequestEvent({required String email}) : super(email: email);
}

class InitializeRequestEvent extends NewsletterSubscriptionEvent {
  InitializeRequestEvent() : super(email: null);
}

/// Closing the Subscription mechanism will re initialize it.
typedef CloseRequestEvent = InitializeRequestEvent;

class LoadingEvent extends NewsletterSubscriptionEvent {}

class SuccessEvent extends NewsletterSubscriptionEvent {}

class ErrorEvent extends NewsletterSubscriptionEvent {
  ErrorEvent({this.error = "Unknown Error"});

  final Object? error;
}
