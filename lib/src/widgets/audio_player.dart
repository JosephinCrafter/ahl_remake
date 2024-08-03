part of 'widgets.dart';

class FirebaseAudioPlayer extends StatefulWidget {
  const FirebaseAudioPlayer({
    super.key,
    required this.article,
    this.collection = 'articles',
  });
  final Article article;
  final String? collection;

  @override
  State<FirebaseAudioPlayer> createState() => _FirebaseAudioPlayerState();
}

class _FirebaseAudioPlayerState extends State<FirebaseAudioPlayer> {
  late Map<String, dynamic>? audioMap;

  late Future<String> url;

  @override
  void initState() {
    super.initState();
    audioMap = widget.article.relations?[0]['audio'];
  }

  Future<String> getAudioUrl() async {
    String? audioFileName;

    audioFileName = audioMap?['file'];
    if (audioFileName == null) {
      throw NullRejectionException(false);
    } else {
      String path = '${widget.collection}/${widget.article.id}/$audioFileName';
      return storage.child(path).getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    url = getAudioUrl();
    return Container(
      padding: const EdgeInsets.all(Paddings.medium,)
          .add(const EdgeInsets.only(top: 12.5,),),
      // color: Theme.of(context).colorScheme.secondaryContainer,
      child: FutureBuilder(
        future: url,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AudioPlayerView(
              color: Theme.of(context).colorScheme.secondary,
              buttonColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Theme.of(context).colorScheme.secondaryContainer,
              secondaryActiveColor:
                  Theme.of(context).colorScheme.secondaryContainer,
              iconSize: 48,
              title: Text(audioMap?['title']),
              timeStyle: Theme.of(context).textTheme.labelSmall,
              url: snapshot.requireData,
            );
          } else if (snapshot.hasError) {
            log("[$runtimeType : ${DateTime.now()}] ${snapshot.error}");
            return Container();
          }

          return Container(
            height: 100,
            color: Theme.of(context).colorScheme.surfaceContainer,
          )
              .animate(
                onInit: (controller) => controller.repeat(
                  period: Durations.medium2,
                ),
              )
              .shimmer(
                curve: Curves.easeInOut,
              );
        },
      ),
    );
  }
}
