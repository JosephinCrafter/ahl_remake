part of 'article_view.dart';

/// Article Page
class ArticleContentPage extends StatefulWidget {
  /// Build [ArticleContentPage] from a article object.
  ///
  /// [article] is required to be not null.
  const ArticleContentPage({
    super.key,
    required this.article,
    this.collection = "articles",
  }) : articleId = null;

  /// Build article page from article id.
  const ArticleContentPage.fromId({
    super.key,
    this.collection = "articles",
    required this.articleId,
  }) : article = null;

  /// The article base route name
  static const String routeName = 'articles';

  /// The current article to be displayed.
  final Article? article;

  /// The collection where to look for article files
  final String? collection;

  /// Article id.
  ///
  /// It's a path where to search for the article data on the firestore.
  final String? articleId;

  @override
  State<ArticleContentPage> createState() => ArticleContentPageState();
}

class ArticleContentPageState extends State<ArticleContentPage> {
  /// The page scrollController;
  late ScrollController scrollController;

  /// The current article to be displayed.
  ///
  /// If [widget.article] is not null, then it is that article.
  /// If not, then [article] if fetched from  [ArticleBloc].
  late Article? article;

  Future<String> getImageUrl(Article article) async {
    ArticleStorageUtils articleUtils = ArticleStorageUtils(
        article: article, collection: widget.collection ?? "articles");
    return await articleUtils.getCoverImageUrl() ?? "";
  }

  void articleSeoSetup(BuildContext context) {
    if (kIsWeb) {
      log('start seo setup');
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context.mounted) {
          HeadTagUtil.setHead(
            title: article!.title!,
            description: article!.relations![0]['preview'] as String,
            keywords: [
              'Madagascar',
              'Notre Dame de la Delivrande',
              'Sœur Dominicaines Missionnaires de Notre Dame de la Délivrande',
            ],
            // imageUrl: getImageUrl(article!),
            url:
                "https://aujourdhuilavenir.org/${widget.collection ?? "articles"}/${article!.id}",
          );
          CreateHtml.makeWidgetTree(context);
        }
      });
      // Define MetaSEO object
      MetaSEO meta = MetaSEO();

      // set document title to article title
      web.document.title = article!.title!;

      // Set decription to article preview
      meta.description(
          description: article!.relations![0]['preview'] as String);

      // add meta seo data for web app as you want
      meta.ogTitle(ogTitle: article!.title!);
      meta.keywords(
          keywords:
              'Madagascar, Notre Dame de la Delivrande, Sœur Dominicaines Missionnaires de Notre Dame de la Délivrande,');
      // meta.ogImage(ogImage: await getImageUrl(article!));
    } else {
      log('SEO setup is not supported on mobile');
    }
  }

  @override
  void initState() {
    /// get article from [widget]
    article = widget.article;

    super.initState();

    scrollController = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: 0,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    article = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setup seo
    if (article != null) {
      // Make Open Graph setup
      articleSeoSetup(context);
    }

    /// If [article] is null, then retriever it from [ArticleBloc].
    if (article == null) {
      context.read<ArticleBloc>().add(
            GetArticleByIdEvent(id: widget.articleId),
          );
    } else {
      /// when article is not null
      String? type = widget.article!.relations?[0]['type'];

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
    }
    return BlocBuilder<ArticleBloc, ArticleState<Article>>(
      // buildWhen: (previous, current) =>
      //     previous.articles?[widget.articleId] == null,
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

class _ArticleContentViewState extends State<ArticleContentView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    /// SEO setup
    setupSeo(context);

    super.initState();
  }

  /// Ask content.
  Future<String> contentFetching() async {
    SessionStorage cache = SessionStorage();

    /// Read cache if it is available
    String contentKey =
        '${widget.collection}/${widget.article.id}/${widget.article.contentPath}';
    if (cache[contentKey] != null) {
      return cache[contentKey]!;
    }

    /// Make real request
    final bytes = await firebase.storage
        .child(
          contentKey,
        )
        .getData();
    String decodedString = utf8.decode(bytes!.toList());

    /// Add result to cache
    cache[contentKey] = decodedString;

    return decodedString;
  }

  late Future<String> content;

  late double screenWidth;

  // late String articleKey = 'article_${widget.article.title}';
  late SessionStorage cache = SessionStorage();
  late Future<Uint8List?> _coverImage;
  late MarkdownConfig minimalisticCorporateConfig;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    setupSeo(context);
    content = contentFetching();
    widget.articleUtils.getCoverImage();

    _coverImage = widget.articleUtils.getCoverImage();

    screenWidth = MediaQuery.of(context).size.width;

    minimalisticCorporateConfig = MarkdownConfig(
      configs: [
        ImgConfig(
          builder: (String url, Map<String, String>? attribute) {
            SessionStorage cache = SessionStorage();
            if (cache[url] != null) {
              return Align(
                key: SeoKey(
                  TagType.img,
                  src: url,
                  attributes: attribute,
                ),
                child: AhlImageViewer.fromFuture(
                  future: Future.value(
                    decodeUint8ListFromString(
                      cache[url]!,
                    ),
                  ),
                ),
              );
            } else {
              if (url.contains('://')) {
                return Align(
                  key: SeoKey(
                    TagType.img,
                    src: url,
                    attributes: attribute,
                  ),
                  child: AhlImageViewer(
                    url: url,
                    attributes: attribute,
                  ),
                );
              }

              try {
                log(url);
                final Future<Uint8List?> future =
                    firebase.storage.child(url).getData();

                future.then(
                  (value) {
                    if (value != null) {
                      if (cache[url] == null) {
                        cache[url] = encodeUint8ListToString(value);
                      }
                    }
                  },
                );
                return Container(
                  alignment: Alignment.center,
                  // constraints: BoxConstraints(
                  //   maxHeight: resolveForBreakPoint(
                  //     screenWidth,
                  //     other: 575,
                  //     small: 300,
                  //   ),
                  // ),
                  child: AhlImageViewer.fromFuture(
                    key: SeoKey(
                      TagType.img,
                      src: url,
                      attributes: attribute,
                    ),
                    // key: ValueKey(url),
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
            }
          },
        ),

        H1Config(
          style: const H1Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
        ),

        H2Config(
          style: const H2Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 28,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
        ),
        H3Config(
          style: const H2Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 24,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
        ),
        H4Config(
          style: const H2Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 22,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
        ),
        H5Config(
          style: const H2Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
        ),
        H6Config(
          style: const H2Config().style.copyWith(
                fontFamily: "Poppins",
                color: AhlTheme.blackCharcoal,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
        ),
        PConfig(
          textStyle: const PConfig().textStyle.copyWith(
                fontFamily: 'Poppins',
                color: const Color(0xFF3F403C),
              ),
        ),
        LinkConfig(
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
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
  Widget shareButtonBig = Builder(
    builder: (context) => Container(
      constraints: const BoxConstraints(maxWidth: 400),
      alignment: Alignment.center,
      child: OutlinedButton.icon(
        onPressed: () {
          var router = GoRouter.of(context);
          String location = router.routeInformationProvider.value.uri.path;
          Share.share("https://aujourdhuilavenir.org$location");
        },
        icon: const Icon(
          Icons.share_outlined,
          size: IconSizes.large,
        ),
        label: Container(
          height: 75,
          alignment: Alignment.center,
          child: Text(
            'Partager',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    ),
  );

  // share button
  Widget shareButton = Builder(
    builder: (context) => OutlinedButton.icon(
      onPressed: () {
        var router = GoRouter.of(context);
        String location = router.routeInformationProvider.value.uri.path;
        Share.share("https://aujourdhuilavenir.org$location");
      },
      label: const Text('Partager'),
      icon: const Icon(Icons.share_outlined),
    ),
  );

  Widget buildMarkdownBlock(BuildContext context) {
    //seo
    setupSeo(context);

    // share button
    Widget supportProjectButton = Builder(
      builder: (context) => Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pushNamed(
            DonationPage.routeName,
            arguments: widget.article,
          ),
          icon: SvgPicture.asset(
            AhlAssets.dons,
            width: IconSizes.large,
            height: IconSizes.large,
          ),
          label: Container(
            alignment: Alignment.center,
            height: 75,
            // width: 250,
            child: Text(
              AppLocalizations.of(context)!.supportProject,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
      ),
    );

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child:
          // padding: const EdgeInsets.all(Paddings.medium),
          Column(
        children: [
          // label
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              key: SeoKey(TagType.p,
                  text: widget.label ?? "", alt: "Article date"),
              widget.label ??
                  DateTimeUtils.localizedFromStringDate(
                      dateString: widget.article.releaseDate, context: context),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),

          // title
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.article.title ?? "",
              key: SeoKey(TagType.h1, text: widget.article.title ?? ""),
              style: resolveHeadlineTextThemeForBreakPoints(
                MediaQuery.of(context).size.width,
                context,
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: Paddings.medium),
          //   child: AhlDivider(
          //     leading: 0,
          //     trailing: 50,
          //     thickness: 16,
          //   ),
          // ),

          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(widget.article.relations?[0]['preview'],
                key: SeoKey(
                  TagType.p,
                  text: widget.article.relations?[0]['preview'],
                )),
          ),
          // share button
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: Paddings.medium,
            ),
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 20,
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                ListenPodcastButton(
                  key: SeoKey(TagType.a,
                      text: "Listen Podcast", alt: "Play Podcast Button"),
                  article: widget.article,
                  collection: widget.collection,
                ),
                shareButton,
              ],
            ),
          ),
          SizedBox(
            height: resolveForBreakPoint(
              screenWidth,
              other: 575,
              small: 300,
            ),
            width: double.maxFinite,
            // constraints: const BoxConstraints.expand(),
            child: AhlImageViewer.fromFuture(
              fit: BoxFit.cover,
              future: _coverImage,
            ),
          ),

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
              child: FutureBuilder(
                future: content,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return MarkdownBlock(
                          key: SeoKey(TagType.p,
                              text: snapshot.data ?? "Empty article"),
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
              )),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 20, horizontal: Paddings.medium),
            child: shareButtonBig,
          ),

          if (widget.isProject)
            Container(
              padding: const EdgeInsets.all(Paddings.medium),
              alignment: Alignment.center,
              child: supportProjectButton,
            ),
          Gap(
            resolveSeparatorSize(context),
          ),
        ],
      ),
    );
  }
}

class ListenPodcastButton extends StatelessWidget {
  const ListenPodcastButton({
    super.key,
    required this.article,
    this.collection,
    this.iconSize = 24,
  });

  final Article article;
  final String? collection;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (article.relations?[0]['audio'] != null) {
      return ElevatedButton.icon(
        // shape: const StadiumBorder(),
        // backgroundColor: Colors.transparent,
        style: ElevatedButton.styleFrom(
          // padding: const EdgeInsets.symmetric(
          //   vertical: 10,
          //   horizontal: 16,
          // ),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          AppLocalizations.of(context)!.listenPodcast,
        ),
        icon: const Icon(Icons.play_arrow),
        onPressed: () {
          PersistentBottomSheetController? controller;
          controller = Scaffold.maybeOf(context)?.showBottomSheet((context) {
            return Container(
              constraints: const BoxConstraints.tightFor(
                height: 125,
              ),
              child: Stack(
                children: [
                  FirebaseAudioPlayer(
                    article: article,
                    collection: collection,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.minimize, size: iconSize),
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          onPressed: () {
                            controller?.close();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close_rounded, size: iconSize),
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                          onPressed: () {
                            controller?.close();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      );
    } else {
      return const SizedBox.shrink();
    }
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
    //seo
    setupSeo(context);

    if (widget.url != null && widget.url!.contains("://")) {
      return SizedBox(
        height: double.tryParse(widget.attributes?['height'] ?? ""),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              DialogRoute(
                context: context,
                builder: (context) => ImageViewer(
                  child: Image.network(
                    cacheHeight: 500,
                    cacheWidth: 500,
                    gaplessPlayback: false,
                    widget.url!,
                    fit: widget.fit,
                  ),
                ),
              ),
            );
          },
          child: Image.network(
            key: SeoKey(TagType.img, src: widget.url ?? ""),
            widget.url!,
            fit: widget.fit,
          ),
        ),
      );
    }
    return SizedBox(
      height: double.tryParse(widget.attributes?['height'] ?? ""),
      child: FutureBuilder(
        future: imageFuture,
        key: ValueKey(widget.url),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
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
              }
              if (snapshot.hasError) {
                return Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(Icons.error),
                      Text("Error getting Image: ${snapshot.error}"),
                      Text('Data: $snapshot'),
                    ],
                  ),
                );
              }
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            default:
              return Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
