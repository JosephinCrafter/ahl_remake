part of 'article_view.dart';

/// Article Page
class ArticleContentPage extends StatefulWidget {
  const ArticleContentPage({
    super.key,
    required this.article,
    this.collection = "/articles",
  }) : articleId = null;

  const ArticleContentPage.fromId({
    super.key,
    this.collection = "/articles",
    required this.articleId,
  }) : article = null;

  static const String routeName = 'articles';
  final Article? article;
  final String? collection;
  final String? articleId;
  @override
  State<ArticleContentPage> createState() => ArticleContentPageState();
}

class ArticleContentPageState extends State<ArticleContentPage> {
  late ScrollController scrollController;
  late Article? article;
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController(keepScrollOffset: true);

    article = widget.article;
    if (article == null) {
      context.read<ArticleBloc>().add(
            GetArticleByIdEvent(id: widget.articleId),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleBloc, ArticleState<Article>>(
      buildWhen: (previous, current) =>
          previous.articles?[widget.articleId] == null,
      builder: (context, state) {
        String? type = widget.article?.relations?[0]['type'];
        article = article ?? state.articles?[widget.articleId];

        if (article == null) {
          if (state.status == ArticleStatus.failed) {
            context.goNamed(HomePage.routeName);
          }
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: LottieBuilder.asset('animations/loading.json'),
            ),
          );
        }
        switch (type) {
          case 'novena':
            context.goNamed(NovenaPage.routeName, extra: article);
            return const SizedBox();

          default:
            return LayoutBuilder(
              builder: (context, constraints) => Scaffold(
                endDrawer: constraints.maxWidth <= ScreenSizes.large
                    ? const AhlDrawer()
                    : null,
                appBar: const AhlAppBar(),
                body: ListView(
                  controller: scrollController,
                  addAutomaticKeepAlives: true,
                  children: [
                    ArticleContentView(
                      collection: widget.collection,
                      article: article!,
                      controller: scrollController,
                    ),
                    const Gap(25),
                    const NewsLetterPrompt(),
                    const AhlFooter(),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}

class ArticleContentView extends StatefulWidget {
  ArticleContentView({
    this.isProject = false,
    super.key,
    required this.article,
    this.collection = "articles",
    this.controller,
    this.label,
  }) : articleUtils =
            ArticleStorageUtils(article: article, collection: collection!);

  final Article article;
  final String? collection;

  final ArticleStorageUtils articleUtils;
  final ScrollController? controller;
  final bool isProject;
  final String? label;

  @override
  State<ArticleContentView> createState() => _ArticleContentViewState();
}

class _ArticleContentViewState
    extends State<ArticleContentView> /*with AutomaticKeepAliveClientMixin*/ {
  Future<String> contentFetching() async {
    final bytes = await firebase.storage
        .child(
            '${widget.collection}/${widget.article.id}/${widget.article.contentPath}')
        .getData();

    String decodedString = utf8.decode(bytes!.toList());
    return decodedString;
  }

  late Future content;

  late double screenWidth;

  late String articleKey = 'article_${widget.article.title}';
  late SessionStorage cache = SessionStorage();
  late Uint8List? _coverImage;
  late MarkdownConfig minimalisticCorporateConfig;

  @override
  void initState() {
    content = contentFetching();
    widget.articleUtils.getCoverImage();
    super.initState();

    _coverImage = widget.articleUtils.coverImage;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    minimalisticCorporateConfig = MarkdownConfig(
      configs: [
        ImgConfig(
          builder: (String url, Map<String, String>? attribute) {
            if (url.contains('://')) {
              return Align(
                child: AhlImageViewer(
                  url: url,
                  attributes: attribute,
                ),
              );
            }

            try {
              log(url);
              final Future future = firebase.storage.child(url).getData();
              return Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxHeight: resolveForBreakPoint(
                    screenWidth,
                    other: 575,
                    small: 300,
                  ),
                ),
                child: AhlImageViewer.fromFuture(
                  key: ValueKey(url),
                  future: future,
                  attributes: attribute,
                ),
              );
              // return Container();
            } catch (e) {
              log("[ArticleContentViewState] Error getting image: $e");
              return Container(
                alignment: Alignment.center,
                child: const Icon(Icons.warning),
              );
            }
          },
        ),

        H1Config(
          style: const H1Config().style.copyWith(
                fontFamily: "Butler",
                color: AhlTheme.blueNight,
              ),
        ),

        H2Config(
          style: const H2Config().style.copyWith(fontFamily: "Butler"),
        ),
        PConfig(
            textStyle:
                const PConfig().textStyle.copyWith(fontFamily: 'Poppins')),
        LinkConfig(
          style: resolveLabelTextThemeForBreakPoints(
                  MediaQuery.sizeOf(context).width, context)!
              .copyWith(
            color: Theme.of(context).primaryColor,
            decoration: TextDecoration.underline,
            decorationColor: Theme.of(context).primaryColor,
            // height: 5,
          ),
          onTap: (url) {
            launchUrl(Uri.parse(url));
          },
        ),

        // ImgConfig(
        //   builder: (url, attributes) {
        //     return Column(
        //       children: [
        //         Container(
        //           constraints: BoxConstraints(
        //             minWidth: 320,
        //             maxWidth: ContentSize.maxWidth(screenWidth),
        //           ),
        //           decoration: BoxDecoration(
        //             image: DecorationImage(image: NetworkImage(url)),
        //             borderRadius: BorderRadius.circular(BorderSizes.medium),
        //           ),
        //           clipBehavior: Clip.hardEdge,
        //         ),
        //         if (attributes['name'] != null) Text('${attributes["name"]}'),
        //       ],
        //     );
        //   },
        // ),
      ],
    );

    return Center(
      child: Container(
        key: ValueKey(widget.article.title),
        constraints:
            BoxConstraints(maxWidth: ContentSize.maxWidth(screenWidth)),
        // constraints: const BoxConstraints(maxWidth: 1024),
        margin: EdgeInsets.symmetric(
          horizontal: resolveForBreakPoint(
            screenWidth,
            other: Margins.small / 2,
            // extraHuge: Margins.extraHuge,
            // huge: Margins.huge,
            // extraLarge: Margins.extraLarge,
            // large: Margins.large,
          ),
        ),
        // padding: EdgeInsets.symmetric(
        //   horizontal: resolveForBreakPoint(
        //     screenWidth,
        //     small: Margins.small,
        //     medium: Margins.small,
        //     large: Margins.large,
        //     extraLarge: Margins.extraLarge,
        //     other: Margins.huge,
        //   ),
        // ),

        child: buildMarkdownBlock(context),
      ),
    );
  }

  // share button
  Widget shareButton = Builder(
    builder: (context) => Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () {
          var router = GoRouter.of(context);
          String location = router.routeInformationProvider.value.uri.path;
          Share.share("https://aujourdhuilavenir.org$location");
        },
        label: const Text('Partager'),
        icon: const Icon(Icons.share_outlined),
      ),
    ),
  );

  Widget buildMarkdownBlock(BuildContext context) {
    // share button
    Widget supportProjectButton = Builder(
      builder: (context) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () => Navigator.of(context).pushNamed(
          DonationPage.routeName,
          arguments: widget.article,
        ),
        label: Text(AppLocalizations.of(context)!.supportProject),
        icon: SvgPicture.asset(
          'images/SVG/dons.svg',
          width: IconSizes.small,
          height: IconSizes.small,
        ),
      ),
    );

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child:
          // padding: const EdgeInsets.all(Paddings.medium),
          Column(
        children: [
          // title
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.article.title ?? "",
              style: resolveHeadlineTextThemeForBreakPoints(
                MediaQuery.of(context).size.width,
                context,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label ?? DateTimeUtils.localizedFromStringDate(
                  dateString: widget.article.releaseDate, context: context),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Paddings.medium),
            child: AhlDivider(
              leading: 0,
              trailing: 50,
              thickness: 16,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.article.relations?[0]['preview'],
            ),
          ),
          // share button
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: Paddings.medium,
            ),
            child: shareButton,
          ),
          Container(
              height: resolveForBreakPoint(
                screenWidth,
                other: 575,
                small: 300,
              ),
              width: double.maxFinite,
              // constraints: const BoxConstraints.expand(),
              child: AhlImageViewer.fromFuture(
                fit: BoxFit.cover,
                future: Future.value(_coverImage),
              )),

          // markdown content
          Container(
            padding: EdgeInsets.all(
              resolveForBreakPoint(
                screenWidth,
                other: Paddings.big,
                small: 10,
                medium: 10,
              ),
            ),
            child: (cache[articleKey] == null)
                ? FutureBuilder(
                    future: content,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            cache[articleKey] = snapshot.data!;
                            return MarkdownBlock(
                              data: snapshot.data ?? 'Error loading article.',
                              config: minimalisticCorporateConfig,
                            );
                          } else {
                            return Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  Text(
                                      'Error loading article content: ${snapshot.error}')
                                ],
                              ),
                            );
                          }

                        default:
                          return Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.height - 50,
                            child: const CircularProgressIndicator(),
                          );

                        // default:
                        //   return Align(
                        //     alignment: Alignment.center,
                        //     child: Icon(
                        //       Icons.warning_rounded,
                        //       color: Theme.of(context).colorScheme.error,
                        //     ),
                        //   );
                      }
                    },
                  )
                : MarkdownBlock(
                    data: cache[articleKey] ?? 'Error loading article.',
                    config: minimalisticCorporateConfig,
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 20, horizontal: Paddings.medium),
            child: shareButton,
          ),

          if (widget.isProject)
            Container(
              padding: const EdgeInsets.all(Paddings.medium),
              alignment: Alignment.center,
              child: supportProjectButton,
            ),
        ],
      ),
    );
  }
}

class AhlImageViewer extends StatefulWidget {
  const AhlImageViewer({
    super.key,
    required this.url,
    this.attributes,
    this.fit = BoxFit.contain,
  }) : future = null;

  const AhlImageViewer.fromFuture(
      {super.key, required this.future, this.attributes, this.fit})
      : url = null;

  final Future? future;
  final String? url;
  final Map<String, String>? attributes;
  final BoxFit? fit;

  @override
  State<AhlImageViewer> createState() => _AhlImageViewerState();
}

class _AhlImageViewerState extends State<AhlImageViewer> {
  late Future imageFuture;

  @override
  void initState() {
    developer.log("[AhlImageViewer] State is initialized.");
    super.initState();

    if (widget.url != null) {
      imageFuture = firebase.storage.child(widget.url!).getData();
    } else {
      imageFuture = widget.future!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url != null && widget.url!.contains("://")) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            DialogRoute(
              context: context,
              builder: (context) => ImageViewer(
                child: Image.network(
                  widget.url!,
                  fit: widget.fit,
                ),
              ),
            ),
          );
        },
        child: Image.network(
          widget.url!,
          fit: widget.fit,
        ),
      );
    }
    return FutureBuilder(
      future: imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  DialogRoute(
                    context: context,
                    builder: (context) => ImageViewer(
                      child: Image.memory(snapshot.data!),
                    ),
                  ),
                );
              },
              child: Image.memory(
                Uint8List.fromList(
                  snapshot.data!,
                ),
                fit: widget.fit,
              ),
            );
          } catch (e) {
            return Container();
          }
        } else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
