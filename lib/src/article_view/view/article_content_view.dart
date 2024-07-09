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
  @override
  void initState() {
    super.initState();
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
          addAutomaticKeepAlives: true,
          children: [
            ArticleContentView(
              collection: widget.collection,
              article: widget.article,
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
  const ArticleContentView({
    super.key,
    required this.article,
    this.collection,
  });

  final Article? article;
  final String? collection;

  @override
  State<ArticleContentView> createState() => _ArticleContentViewState();
}

class _ArticleContentViewState extends State<ArticleContentView> {
  Future<String> contentFetching() async {
    final bytes = await firebase.storage
        .child(
            '${widget.collection}/${widget.article?.id}/${widget.article?.contentPath}')
        .getData();

    String decodedString = utf8.decode(bytes!.toList());
    return decodedString;
  }

  late Future content;

  late double screenWidth;

  @override
  void initState() {
    super.initState();

    content = contentFetching();
  }

  @override
  Widget build(BuildContext context) {
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
        H1Config(
          style: const H1Config().style.copyWith(fontFamily: "Butler"),
        ),

        H2Config(
          style: const H2Config().style.copyWith(fontFamily: "Butler"),
        ),
        PConfig(textStyle: PConfig().textStyle.copyWith(fontFamily: 'Poppins')),
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
    String articleKey = "${widget.article!.contentPath}";
    SessionStorage cache = SessionStorage();

    if (cache[articleKey] == null) {
      return FutureBuilder(
        future: content,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                cache[articleKey] = snapshot.data!;
                return Card(
                  color: const Color(0xFFFAFAFA),
                  child: Container(
                      padding: const EdgeInsets.all(Paddings.medium),
                      child: Column(
                        children: [
                          MarkdownBlock(
                            data: snapshot.data ?? 'Error loading article.',
                            config: minimalisticCorporateConfig,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // todo: implement sharing mechanisme.
                              },
                              label: const Text('Partager'),
                              icon: const Icon(Icons.share_outlined),
                            ),
                          ),
                        ],
                      )),
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
                      Text('Error loading article content: ${snapshot.error}')
                    ],
                  ),
                );
              }

            default:
              return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
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
      );
    } else {
      return Card(
        color: const Color(0xFFFAFAFA),
        child: Container(
          padding: const EdgeInsets.all(Paddings.medium),
          child: Column(
            children: [
              MarkdownBlock(
                data: cache[articleKey] ?? 'Error loading article.',
                config: minimalisticCorporateConfig,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () {
                    //todo: implement sharing mechanism
                  },
                  label: const Text('Partager'),
                  icon: const Icon(Icons.share_outlined),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => throw UnimplementedError();
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
