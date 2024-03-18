part of '../newsletter.dart';

class NewsLetterPrompt extends StatefulWidget {
  const NewsLetterPrompt({super.key});

  @override
  State<NewsLetterPrompt> createState() => _NewsLetterPromptState();
}

class _NewsLetterPromptState extends State<NewsLetterPrompt> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: firebaseApp, // listen to firebaseApp initialization
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return BlocProvider<NewsletterSubscriptionBloc>(
                create: (context) => NewsletterSubscriptionBloc(
                  repo: NewsletterSubscriptionRepository(
                    database: firestore,
                  ),
                ),
                // Setup bloc providing
                child: const NewsletterPromptView(),
              );

            default:
              return const SizedBox.shrink();
          }
        },);
  }
}

class NewsletterPromptView extends StatefulWidget {
  const NewsletterPromptView({super.key});

  @override
  State<NewsletterPromptView> createState() => _NewsletterPromptViewState();
}

class _NewsletterPromptViewState extends State<NewsletterPromptView> {
  final TextEditingController emailInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsletterSubscriptionBloc, NewsletterSubscriptionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(Paddings.huge),
        color: theme.AhlTheme.yellowRelax,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// This handle 2 state object
            NewsletterTextPrompt(
              test: () => false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Paddings.big,
              ),
              child: TextField(
                controller: emailInputController,
                onTap: () {
                  context
                      .read<NewsletterSubscriptionBloc>()
                      .add(InitializeRequestEvent());
                },
                onEditingComplete: () {
                  context.read<NewsletterSubscriptionBloc>().add(
                        SubscriptionRequestEvent(
                          email: emailInputController.text,
                        ),
                      );
                },
                decoration: InputDecoration(
                  label: const Text('e-mail'),
                  hintText: AppLocalizations.of(context)!.exampleMail,
                  border: const OutlineInputBorder(),
                  error: state.hasError
                      ? Text('${state.getError(context)}')
                      : null,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: (state.status == NewsletterSubscriptionStatus.initial)
                  ? () {
                      context.read<NewsletterSubscriptionBloc>().add(
                            SubscriptionRequestEvent(
                              email: emailInputController.text,
                            ),
                          );
                      emailInputController.clear();
                    }
                  : null,
              child: Builder(
                builder: (context) {
                  switch (state.status) {
                    case NewsletterSubscriptionStatus.loading:
                      return const CircularProgressIndicator();
                    case NewsletterSubscriptionStatus.success:
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: Paddings.small),
                            child: Icon(Icons.done_all_rounded),
                          ),
                          Text(
                            AppLocalizations.of(context)!.thanksForRegistering,
                          ),
                        ],
                      );
                    default:
                      return Text(
                        AppLocalizations.of(context)!.register,
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsletterTextPrompt extends StatelessWidget {
  const NewsletterTextPrompt({super.key, this.test});

  final bool Function()? test;

  @override
  Widget build(BuildContext context) {
    Function testHelper = test ?? () => true;

    Widget child;
    if (testHelper()) {
      child = Text(
        "Thanks for registering to our newsletter!",
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.invitingNewsLetter,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            AppLocalizations.of(context)!.newsLetterWidgetTitle,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      );
    }

    return child;
  }
}

/// Return the right axis based on the the constraints and threshold.
///
/// If the constraints.maxWidth is upper than the threshold,
/// it return [Axis.horizontal]. It return [Axis.vertical] in the else case.
Axis evaluateAxis(
  /// Constraints to evaluate with.
  BoxConstraints constraints, {
  /// The minimum required threshold to maintain the larger than state
  double threshold = ScreenSizes.mobile,
}) {
  Axis axis;

  if (constraints.maxWidth >= threshold) {
    axis = Axis.horizontal;
  } else {
    axis = Axis.vertical;
  }

  return axis;
}
