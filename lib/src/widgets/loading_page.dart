import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key, this.work});

  final Future? work;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      // animationBehavior: AnimationBehavior.preserve,
      // reverseDuration: const Duration(seconds: 3),
    )..addStatusListener((status) => animation(status));
  }

  @override
  void dispose() {
    super.dispose();
    lottieController.dispose();
  }

  void animation(AnimationStatus status) {
    widget.work!.whenComplete(() {
      lottieController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    //todo: change asset to ahl loading
    return DotLottieLoader.fromAsset(
      'assets/animations/loading.json',
      frameBuilder: (context, composition) {
        if (composition == null) {
          return const Align(
            child: CircularProgressIndicator(),
          );
        }
        return Align(
          child: Lottie.memory(
            composition.animations.values.single,
            onLoaded: (p0) => lottieController.forward(),
            reverse: true,
            repeat: true,
            animate: true,
            frameRate: FrameRate.max,
            backgroundLoading: true,
            controller: lottieController,
          ),
        );
      },
    );
  }
}
