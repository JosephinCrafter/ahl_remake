part of 'widgets.dart';

class AhlLogo extends StatelessWidget {
  const AhlLogo({
    super.key,
    this.size = const Size(34, 34),
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
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontFamily: 'Butler',
            fontSize: 22,
            color: foregroundColor,
          ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 250,
        ),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            leading ??
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints.tight(size),
                    child: Image.asset(
                      AhlAssets.logoForm,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            separation ??
                const SizedBox(
                  width: 15,
                ),
            title ??
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ajourd'hui l'avenir",
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontFamily: 'Butler',
                              ),
                    ),
                  ),
                ),
          ],
        ),
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