part of '../newsletter.dart';

enum NewsletterSubscriptionStatus {
  /// When the prompt is empty
  initial,

  /// When the prompt is ready to submit
  loading,

  /// When the mail is submitted
  success,

  /// When an error occurred
  error,
}

final class NewsletterSubscriptionState extends Equatable {
  const NewsletterSubscriptionState({
    this.email,
    this.error,
    this.status = NewsletterSubscriptionStatus.initial,
  });

  /// an helper when building initial state
  factory NewsletterSubscriptionState.initial() =>
      const NewsletterSubscriptionState();

  final String? email;

  final NewsletterSubscriptionStatus status;

  final Object? error;

  NewsletterSubscriptionState copyWith({
    String? email,
    NewsletterSubscriptionStatus? status,
    Object? error,
  }) =>
      NewsletterSubscriptionState(
          email: email ?? this.email,
          status: status ?? this.status,
          error: error ?? this.error);

  @override
  List<Object?> get props => [email, status, error];

  bool get hasError => error != null;

  String? getError(BuildContext context) {
    switch (error) {
      case "Invalid Email":
        return AppLocalizations.of(context)!.invalidEmail;
      default:
        return AppLocalizations.of(context)!.unknownError;
    }
  }
}
