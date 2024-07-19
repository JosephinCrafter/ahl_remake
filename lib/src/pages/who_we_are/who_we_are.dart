import 'dart:developer' as developer;
import 'dart:math';

import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/who_we_are/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';

class WhoWeArePage extends StatefulWidget {
  const WhoWeArePage({super.key});

  static const String routeName = '/whoWeAre';

  @override
  State<WhoWeArePage> createState() => _WhoWeArePageState();
}

/// The WhoWeArePage is a show to who are the sisters in a suitable animation.
/// - Problem: Display sister information in a beautiful and consumable way.
/// - Approach: Use a GestureDetector to trigger scroll event that animate an
///             animation controller that control the animation.
/// - Step: 1. implement ViewUI: text that displays the current animation value.
///         2. Make Gesture Detector Scrolling change the animation state.
///
class _WhoWeArePageState extends State<WhoWeArePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, lowerBound: 0, upperBound: 100);

    scrollController = ScrollController();
    scrollController.addListener(incrementScrolling);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void incrementDragging(DragUpdateDetails details) {
    setState(() {
      animationController.value += details.delta.dy / 100;
    });
  }

  void incrementScrolling() {
    setState(() {
      animationController.value += scrollController.offset / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AhlAppBar(),
        endDrawer: const AhlDrawer(),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          alignment: Alignment.center,
          child: Text(AppLocalizations.of(context)!.availableSoon,
              style: Theme.of(context).textTheme.headlineLarge),
        )
        // ListView(
        //   children: [
        //     Container(
        //       constraints: BoxConstraints(
        //           maxHeight:
        //               MediaQuery.sizeOf(context).height - Sizes.appBarSize),
        //       child:
        //   ScrollingAnimationPage(
        // animationBuilder: (animationValue) => MyAnimatedWidget(
        //   animation: animationValue,
        // ),
        //     ),
        //   ),
        // ],

        );
  }
}

/// Implement animation on who we are
// todo:
// todo    step 1: - create all widget in a scrolling list
//

class ScrollingAnimationPage extends StatefulWidget {
  final double maxAnimationValue;
  final Function(AnimationController animation) animationBuilder;

  const ScrollingAnimationPage({
    super.key,
    this.maxAnimationValue = 2000,
    required this.animationBuilder,
  });

  @override
  State<ScrollingAnimationPage> createState() => _ScrollingAnimationPageState();
}

class _ScrollingAnimationPageState extends State<ScrollingAnimationPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(updateAnimation);
    _controller = AnimationController(
      lowerBound: 0,
      upperBound: widget.maxAnimationValue,
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  void updateAnimation() {
    _controller.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => widget.animationBuilder(_controller),
        ),
        Scrollbar(
          controller: _scrollController,
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                // color: Colors.accents[Random().nextInt(Colors.accents.length)]
                //     .withAlpha(0x8F),
                height: widget.maxAnimationValue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyAnimatedWidget extends StatelessWidget {
  final AnimationController animation;

  const MyAnimatedWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    developer.log('${animation.value}');
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          FutureBuilder(
            future: WhoWeAreTileState.getImage(),
            builder: (context, snapshot) {
              CrossFadeState crossFadeState = CrossFadeState.showFirst;
              if (snapshot.hasData) {
                crossFadeState = CrossFadeState.showSecond;
              }
              return AnimatedCrossFade(
                layoutBuilder:
                    (topChild, topChildKey, bottomChild, bottomChildKey) =>
                        Stack(
                  children: [bottomChild, topChild.animate().fade()],
                ),
                duration: Durations.long4,
                crossFadeState: crossFadeState,
                secondChild: (snapshot.hasData)
                    ? Align(
                        child: Image.memory(
                          fit: BoxFit.cover,
                          snapshot.data!,
                          height: MediaQuery.sizeOf(context).height / 2,
                        ),
                      )
                    : Container(
                        height: MediaQuery.sizeOf(context).height / 2,
                      ),
                firstChild: Container(
                  height: MediaQuery.sizeOf(context).height / 2,
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Paddings.huge),
            child: SectionTitle(
              caretColor: Theme.of(context).primaryColor,
              isUpperCase: true,
              titleColor: Theme.of(context).colorScheme.onSurface,
              title: AppLocalizations.of(context)!.whoWeAre,
            ),
          ),
          AnimatedSlide(
            // alignment: Alignment(sloganDx(animation), 0),
            // width: MediaQuery.sizeOf(context).width,
            // duration: Durations.medium2,
            duration: Duration.zero,
            offset: Offset(max(2.0 - animation.value / 400, -4.0), 0),
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.visible,
              AppLocalizations.of(context)!.slogan,
              style: const TextStyle(
                fontSize: 64,
                fontFamily: 'Butler',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Offset sloganSlide(AnimationController animation) {
    double dx = 0.0;
    double dy = 0.0;

    if (0 <= animation.value && animation.value <= 150) {
      dx = -animation.value / 100;
    }

    Offset offset = Offset(dx, dy);
    return offset;
  }

  double sloganDx(AnimationController animation) {
    if (0 <= animation.value && animation.value <= 150) {
      double xDistance = -animation.value / 100 + 1;
      developer.log("animation triggered: $xDistance");
      return xDistance;
    }

    return 0;
  }
}
