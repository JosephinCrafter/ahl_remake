import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:ahl/src/newsletter/newsletter.dart';

// let's create of the repo
@GenerateNiceMocks([MockSpec<NewsletterSubscriptionRepository>()])
import 'newsletterbloc_test.mocks.dart';

/// To start a bloc test, I think we're gonna need to implement a widget and
/// read from there.
void main() {
  const String exampleEmail = 'example@email.com';
  NewsletterSubscriptionRepository mockRepo =
      MockNewsletterSubscriptionRepository();
  group(
    'test on NewsletterBloc',
    () {
      setUpAll(() {
        when(mockRepo.status).thenAnswer((_) {
          return Stream.fromIterable([NewsletterSubscriptionStatus.initial]);
        });
      });
      blocTest<NewsletterSubscriptionBloc, NewsletterSubscriptionState>(
        'emits initial status when freshly created',
        build: () => NewsletterSubscriptionBloc(repo: mockRepo),
        act: (bloc) => bloc
          ..add(InitializeRequestEvent())
          ..add(InitializeRequestEvent()),
        expect: () => [
          NewsletterSubscriptionState.initial(),
        ],
      );

      blocTest<NewsletterSubscriptionBloc, NewsletterSubscriptionState>(
        'emits loading when added an event email',
        build: () => NewsletterSubscriptionBloc(repo: mockRepo),
        act: (bloc)async  {
          bloc.add(
            SubscriptionRequestEvent(
              email: exampleEmail,
            ),
          );
          await Future.delayed( const Duration(milliseconds: 300));
        },
        expect: () => [
          const NewsletterSubscriptionState(
              email: exampleEmail,
              status: NewsletterSubscriptionStatus.loading,
              error: null),
          const NewsletterSubscriptionState(
            email: exampleEmail,
            status: NewsletterSubscriptionStatus.success,
            error: null,
          ),
        ],
      );
    },
  );
}

class MockNewsletterPromptBloc extends Mock implements Bloc {}
