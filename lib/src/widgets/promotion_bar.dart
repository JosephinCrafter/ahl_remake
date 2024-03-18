part of 'widgets.dart';

class PromotionBar extends StatefulWidget {
  const PromotionBar({
    super.key,
    required this.child,
    this.isShown = true,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;
  final bool isShown;

  @override
  State<PromotionBar> createState() => _PromotionBarState();
}

class _PromotionBarState extends State<PromotionBar> {
  _PromotionBarState();

  late bool isShown;

  @override
  void initState() {
    super.initState();
    isShown = widget.isShown;
  }

  @override
  Widget build(BuildContext context) {
    return isShown
        ? Container(
            color: widget.backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.child,
                IconButton(
                  onPressed: close,
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  void close() => setState(() {
        isShown = false;
      });

  void open() {
    if (isShown == true) {
      return;
    } else {
      setState(() => isShown = true);
    }
  }
}

/// The construction message that appear on
/// the top of the home page.
Widget inConstructionPromotionalBar = Builder(
  builder: (context) {
    return PromotionBar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Paddings.small),
                child: Icon(
                  Icons.build_circle_rounded,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!
                  .inConstructionPromotionalMessage,
            )
          ],
        ),
      ),
    );
  },
);
