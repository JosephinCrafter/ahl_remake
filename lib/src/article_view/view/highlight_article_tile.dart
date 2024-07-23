part of 'article_view.dart';

class HighlightArticleTile extends StatefulWidget {
  const HighlightArticleTile({super.key});

  @override
  State<HighlightArticleTile> createState() => _HighlightArticleTileState();
}

class _HighlightArticleTileState extends State<HighlightArticleTile>
    with AutomaticKeepAliveClientMixin {
  final SessionStorage _cache = SessionStorage();

  final String _highlightArticleStateKey = 'isHighlightArticleReady';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      key: const Key('Highlight Article'),
      future: firebase.firebaseApp,
      builder: (context, snapshot) {
        // if firebase is correctly initialized
        if (snapshot.hasData) {
          return BlocProvider(
            create: (BuildContext context) => ArticleBloc(
              repo: ArticlesRepository(
                firestoreInstance: firebase.firestore,
                collection: 'articles',
              ),
            )..add(
                const GetHighlightArticleEvent(),
              ),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ContentSize.maxWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                child: BlocBuilder<ArticleBloc, ArticleState<Article>>(
                  builder: (context, state) {
                    switch (state.status) {
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
                                child: CardArticleTile(
                                  article: state.articles![0]!,
                                ),
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
                      default:
                        return Container(
                          height: 408,
                          margin: const EdgeInsets.symmetric(
                            horizontal: Margins.medium,
                          ),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
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
