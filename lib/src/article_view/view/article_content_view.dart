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
        body: ArticleContentView(
          collection: widget.collection,
          article: widget.article,
        ),
      ),
    );
  }
}

class ArticleContentView extends StatelessWidget {
  const ArticleContentView({
    super.key,
    required this.article,
    this.collection,
  });

  final Article? article;
  final String? collection;

  Future<String> get content async {
    final bytes = await firebase.storage
        .child('$collection/${article?.id}/${article?.contentPath}')
        .getData();

    String decodedString = utf8.decode(bytes!.toList());
    return decodedString;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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

    MarkdownConfig minimalisticCorporateConfig = MarkdownConfig(
      configs: [
        H1Config(
          style: resolveHeadlineTextThemeForBreakPoints(screenWidth, context)!,
        ),
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
      constraints: BoxConstraints(
        maxWidth: ContentSize.maxWidth(
          screenWidth,
        ),
      ),
      child: FutureBuilder(
        future: content,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData) {
                return MarkdownWidget(
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
      ),
    );
  }
}
