part of 'article_view.dart';

class HighlightArticleTile extends StatefulWidget {
  const HighlightArticleTile({
    super.key,
    this.labelBuilder,
  });
  final String Function({Article? article})? labelBuilder;

  @override
  State<HighlightArticleTile> createState() => _HighlightArticleTileState();
}

class _HighlightArticleTileState extends State<HighlightArticleTile>
    with AutomaticKeepAliveClientMixin {
  final SessionStorage _cache = SessionStorage();

  final String _highlightArticleStateKey = 'isHighlightArticleReady';
  late Future computation;
  late String? label;

  @override
  void initState() {
    super.initState();

    computation = firebase.firebaseApp;
  }

  String? buildLabel({required Article? article}) {
    var type = article?.relations?[0]['type'];

    if (type != null && type == 'novena') {
      return "NEUVAINE";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      key: const Key('Highlight Article'),
      future: computation,
      builder: (context, snapshot) {
        // if firebase is correctly initialized
        if (snapshot.hasData) {
          return BlocProvider(
            create: (BuildContext context) => ArticleBloc(
              repo: ArticlesRepository(
                firestoreInstance: firebase.firestore,
                // collection: 'articles',
              ),
            )
              ..add(
                const GetHighlightArticleEvent(),
              )
              ..add(const GetHighlightCollectionEvent()),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ContentSize.maxWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: BlocBuilder<ArticleBloc, ArticleState<Article>>(
                  // buildWhen: (previous, current) =>
                  //     current.highlightCollection == null || current.articles == null || current.articles!.isEmpty,
                  builder: (context, state) {
                    /// generate label
                    label = (widget.labelBuilder != null)
                        ? widget.labelBuilder!(article: state.highlightArticle)
                        : buildLabel(article: state.highlightArticle);

                    String? highlightCollection = state.highlightCollection;

                    switch (state.status) {
                      /// failed to trigger state
                      case ArticleStatus.failed:
                        developer.log('${state.error}');
                        return Container(
                          padding: const EdgeInsets.all(4.0),
                          // color: Theme.of(context).colorScheme.onErrorContainer,
                          margin: const EdgeInsets.symmetric(
                            horizontal: Margins.medium,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.warning_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );

                      /// case done;
                      case ArticleStatus.succeed:
                        // update caching info

                        _cache[_highlightArticleStateKey] = 'true';

                        // String releaseMonth = DateTimeUtils.localMonth(
                        //   DateTimeUtils.parseReleaseDate(
                        //           state.articles![0]!.releaseDate ??
                        //               '2024-04-28')
                        //       .month,
                        //   context,
                        // );
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: Margins.medium,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   monthTextResolve(
                              //     context,
                              //     releaseMonth,
                              //   ).toUpperCase(),
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .labelLarge!
                              //       .copyWith(
                              //         color:
                              //             Theme.of(context).colorScheme.primary,
                              //       ),
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: (state.highlightArticle != null)
                                    ? CardArticleTile(
                                        label: label,
                                        article: state.highlightArticle!,
                                        collection:
                                            highlightCollection ?? 'articles',
                                      )
                                    : const Text(
                                        "[HighLightArticleTile] Error: HighLightArticle is null"),
                              ),
                              // Container(
                              //   margin: const EdgeInsets.symmetric(
                              //     vertical: Margins.medium,
                              //   ),
                              //   alignment: Alignment.centerRight,
                              //   child: TextButton(
                              //     onPressed: () {
                              //       Navigator.of(context)
                              //           .pushNamed(ArticlesPage.routeName);
                              //     },
                              //     child: Text(
                              //       AppLocalizations.of(context)!.allArticles,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );

                      /// while waiting
                      default:
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(BorderSizes.medium),
                          ),

                          height: 408,
                          margin: const EdgeInsets.symmetric(
                            horizontal: Margins.medium,
                          ),
                          alignment: Alignment.center,
                          // child: const CircularProgressIndicator(),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer()
                            .then(delay: Durations.long1);
                    }
                  },
                ),
              ),
            ),
          );
        } else {
          developer.log('article error: ${snapshot.error}');
          return Container(
            height: 310,
            margin: const EdgeInsets.symmetric(
              horizontal: Margins.medium,
            ),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  void goToReadingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ArticleContentPage(
            article: context.read<ArticleBloc>().state.highlightArticle,
          );
        },
      ),
    );
  }

  //
  bool keepAlive = false;
  @override
  bool get wantKeepAlive {
    return _cache[_highlightArticleStateKey] == 'true';
  }
}
