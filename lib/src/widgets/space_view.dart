part of 'widgets.dart';

class SpaceView extends StatelessWidget {
  const SpaceView({
    super.key,
    this.headerImage,
    required this.children,
    this.useGradient = true,
  });

  final ImageProvider? headerImage;
  final List<Widget> children;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      // bk image
      Container(
        constraints: const BoxConstraints(minHeight: 650),
        decoration: headerImage != null
            ? BoxDecoration(
                color: const Color(0xFF2e2e2e),
                backgroundBlendMode: BlendMode.multiply,
                image: DecorationImage(
                  opacity: 2.0,
                  fit: BoxFit.cover,
                  image: headerImage ??
                      AssetImage(
                        AhlAssets.prayersHeroHeader,
                      ),
                ),
              )
            : const BoxDecoration(),
      ),

      // gradient
       DecoratedBox(
        decoration: BoxDecoration(
          gradient:useGradient ? LinearGradient(
              colors: [
                Colors.transparent,
                AhlTheme.darkNight.withAlpha(0xFF),
                AhlTheme.blueNight,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0, // this is the ratio of the header image
                650 / 1681 * 2 / 3,
                1,
              ]): null,
        ),

        // contents
        child: Column(
          children: this.children,
        ),
      ),
    ];

    return Stack(
      // height: 2080,
      // width: 500,
      // enableDrag: true,
      children: List.generate(
        children.length,
        (index) => children[index],
      ),
    );
  }
}
