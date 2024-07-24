part of 'article_view.dart';

/// Article Page
class ArticleContentPage extends StatefulWidget {
  const ArticleContentPage(
      {super.key, this.article, this.collection = "/articles"});

  static const String routeName = '/articles';
  final Article? article;
  final String? collection;
  @override
  State<ArticleContentPage> createState() => ArticleContentPageState();
}

class ArticleContentPageState extends State<ArticleContentPage> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {
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
              article: widget.article!,
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

class ArticleContentView extends StatefulWidget {
  ArticleContentView({
    super.key,
    required this.article,
    this.collection = "articles",
    this.controller,
  }) : articleUtils =
            ArticleStorageUtils(article: article, collection: collection!);

  final Article article;
  final String? collection;

  final ArticleStorageUtils articleUtils;
  final ScrollController? controller;

  @override
  State<ArticleContentView> createState() => _ArticleContentViewState();
}

class _ArticleContentViewState extends State<ArticleContentView>
    with AutomaticKeepAliveClientMixin {
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

  @override
  void initState() {
    content = contentFetching();
    widget.articleUtils.getCoverImage();
    super.initState();

    _coverImage = widget.articleUtils.coverImage;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Style for Markdown from Flutter_markdown
    // final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
    //   p: AhlTheme.bodyMedium,
    //   h1: AhlTheme.headlineLarge,
    //   h2: AhlTheme.headlineMedium,
    //   h3: AhlTheme.headlineSmall,
    //   h4: AhlTheme.titleLarge,
    //   h5: AhlTheme.titleMedium,
    //   h6: AhlTheme.titleSmall,
    //   a: AhlTheme.label.copyWith(color: AhlTheme.primaryColor),
    //   code: AhlTheme.bodySmall.copyWith(color: AhlTheme.blackCharcoal),
    //   blockquote: AhlTheme.bodyMedium.copyWith(
    //     color: AhlTheme.blackCharcoal,
    //     fontStyle: FontStyle.italic,
    //   ),
    //   strong: AhlTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
    //   em: AhlTheme.bodyMedium.copyWith(fontStyle: FontStyle.italic),
    // );
    // styleSheet:
    //     MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
    //   p: AhlTheme.bodyMedium,
    //   h1: AhlTheme.headlineLarge,
    //   h2: AhlTheme.headlineMedium,
    //   h3: AhlTheme.headlineSmall,
    //   h4: AhlTheme.titleLarge,
    //   h5: AhlTheme.titleMedium,
    //   h6: AhlTheme.titleSmall,
    //   a: AhlTheme.label.copyWith(color: AhlTheme.primaryColor),
    //   code: AhlTheme.bodySmall
    //       .copyWith(color: AhlTheme.blackCharcoal),
    //   blockquote: AhlTheme.bodyMedium.copyWith(
    //     color: AhlTheme.blackCharcoal,
    //     fontStyle: FontStyle.italic,
    //   ),
    //   strong: AhlTheme.bodyMedium
    //       .copyWith(fontWeight: FontWeight.bold),
    //   em: AhlTheme.bodyMedium
    //       .copyWith(fontStyle: FontStyle.italic),
    // ),

    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: resolveForBreakPoint(
          screenWidth,
          other: Margins.small,
          extraHuge: Margins.extraHuge,
          huge: Margins.huge,
          extraLarge: Margins.extraLarge,
          large: Margins.large,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: resolveForBreakPoint(
          screenWidth,
          small: Margins.small,
          medium: Margins.small,
          large: Margins.large,
          extraLarge: Margins.extraLarge,
          other: Margins.huge,
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 1024),
      child: buildMarkdownBlock(context),
    );
  }

  Widget buildMarkdownBlock(BuildContext context) {
    MarkdownConfig minimalisticCorporateConfig = MarkdownConfig(
      configs: [
        ImgConfig(builder: (String url, Map<String, String>? attribute) {
          final Future future = firebase.storage.child(url).getData();
          return AhlImageViewer.fromFuture(
            future: future,
            attributes: attribute,
          );
        }),

        /// todo: implements styles
        ///
        H1Config(
          style: const H1Config().style.copyWith(fontFamily: "Butler"),
        ),

        H2Config(
          style: const H2Config().style.copyWith(fontFamily: "Butler"),
        ),
        PConfig(
            textStyle:
                const PConfig().textStyle.copyWith(fontFamily: 'Poppins')),
        LinkConfig(
          onTap: (url) {
            launchUrl(Uri.parse(url));
          },
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Colors.blue,
              ),
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

    // share button
    Widget shareButton = Builder(
      builder: (context) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () {
            //todo: implement sharing mechanism
          },
          label: const Text('Partager'),
          icon: const Icon(Icons.share_outlined),
        ),
      ),
    );

    return Card(
      color: const Color(0xFFFAFAFA),
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
              style: resolveDisplayTextThemeForBreakPoints(
                MediaQuery.of(context).size.width,
                context,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
            alignment: Alignment.centerLeft,
            child: Text(
              DateTimeUtils.localizedFromStringDate(
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
            child: Text(widget.article.relations?[0]['preview']),
          ),
          // share button
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: Paddings.medium),
            child: shareButton,
          ),
          Container(
              height: resolveForBreakPoint(
                screenWidth,
                other: 575,
                small: 300,
              ),
              child: AhlImageViewer.fromFuture(
                future: Future.value(_coverImage),
              )),

          // markdown content
          Container(
            padding: const EdgeInsets.all(Paddings.medium),
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
            padding: const EdgeInsets.all(Paddings.medium),
            child: shareButton,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => cache[articleKey] != null;
}

class AhlImageViewer extends StatefulWidget {
  const AhlImageViewer({
    super.key,
    required this.url,
    this.attributes,
  }) : future = null;

  const AhlImageViewer.fromFuture(
      {super.key, required this.future, this.attributes})
      : url = null;

  final Future? future;
  final String? url;
  final Map<String, String>? attributes;

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
