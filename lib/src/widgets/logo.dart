part of 'widgets.dart';

class AhlLogo extends StatelessWidget {
  const AhlLogo({
    super.key,
    this.size = const Size(48, 48),
    this.leading,
    this.title,
    this.separation,
    this.foregroundColor,
    this.crossAxisAlignment,
  });

  final Size size;
  final Widget? leading;
  final Widget? title;
  final Widget? separation;
  final CrossAxisAlignment? crossAxisAlignment;

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontFamily: 'Butler',
            fontSize: 20,
            color: foregroundColor ??
                Theme.of(context).textTheme.headlineLarge!.color,
          ),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          leading ??
              Container(
                constraints: BoxConstraints.tight(size),
                child: Image.asset(
                  AhlAssets.logoForm,
                  fit: BoxFit.contain,
                ),
              ),
          separation ??
              const SizedBox(
                width: 30,
              ),
          title ??
              Text(
                "Ajourd'hui l'avenir",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontFamily: 'Butler',
                    ),
              ),
        ],
      ),
    );
  }
}

// Old logo setup
//
// Row(
        //   children: [
        //     SizedBox.fromSize(
        //       size: size,
        //       child: Image.asset(
        //         AhlAssets.logoForm,
        //         fit: BoxFit.contain,
        //       ),
        //     ),
        //     const SizedBox(
        //       width: 30,
        //     ),
        //     Text(
        //       "Ajourd'hui l'avenir",
        //       style: Theme.of(context).textTheme.bodyLarge,
        //     ),
        //   ],
        // );