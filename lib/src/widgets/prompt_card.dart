part of 'widgets.dart';

class PromptCard extends StatefulWidget {
  const PromptCard({
    super.key,
    this.constraints,
    required this.backgroundImage,
    required this.title,
    this.subtitle,
    this.bottomHeight,
    this.backgroundColor,
  });

  final BoxConstraints? constraints;
  final ImageProvider backgroundImage;
  final Widget title;
  final Widget? subtitle;
  final double? bottomHeight;
  final Color? backgroundColor;

  @override
  State<PromptCard> createState() => _PromptCardState();
}

class _PromptCardState extends State<PromptCard>
    with SingleTickerProviderStateMixin {
  /// global key to ge access the widget
  static final GlobalKey containerKey =
      GlobalKey(debugLabel: "backgroundImage");
  final duration = Durations.subtle;

  /// animation controller
  late AnimationController _controller;

  double _elevation = 5;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverCallBack(bool isHovered) {
    animateZoomInOut(isHovered);
    elevate(isHovered);
  }

  /// setup zoom animation
  void animateZoomInOut(bool isHovered) {
    if (isHovered) {
      _controller.forward();
    } else {
      // _controller.isCompleted
      _controller.reverse();
    }
  }

  void elevate(bool isHovered) {
    setState(() {
      if (isHovered) {
        _elevation = 25;
      } else {
        // _controller.isCompleted
        _elevation = 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // todo: make it dynamic image with storage
    // final Reference imageRef =
    //     storage.child('/static/sj.jpg');
    // final imageUrl = imageRef.getDownloadURL();
    // var image = imageRef.getData();

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: _elevation,
      child: InkWell(
        onHover: _onHoverCallBack,
        onTap: () {},
        child: Container(
          constraints: widget.constraints ??
             BoxConstraints.loose(const Size( 342, 378)),
          child: Stack(
            children: [
              // FutureBuilder(
              //   future: Future.delayed(const Duration(milliseconds: 1)),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return
              Animate(
                effects: [
                  ScaleEffect(
                    duration: duration,
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.bounceInOut,
                  ),
                ],
                controller: _controller,
                child: Container(
                  key: containerKey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              //       ;
              //     } else if (snapshot.hasError) {
              //       return Container(
              //         decoration: BoxDecoration(
              //           image: DecorationImage(
              //             image: AssetImage(
              //                 AhlAssets.logoFormTypoHorizontalColoredDark),
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       );
              //     } else {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //   },
              // )

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(Paddings.medium),
                  constraints:
                      BoxConstraints.expand(height: widget.bottomHeight ?? 80),
                  color: widget.backgroundColor ??
                      Theme.of(context).colorScheme.background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        overflow: TextOverflow.ellipsis ,
                        style: Theme.of(context).textTheme.headlineSmall!,
                        child: widget.title,),
                      DefaultTextStyle(
                        overflow: TextOverflow.ellipsis ,
                        style: Theme.of(context).textTheme.labelLarge!,
                        child: widget.subtitle ?? const SizedBox.shrink(),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
