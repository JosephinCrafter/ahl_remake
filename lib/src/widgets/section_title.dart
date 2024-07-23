part of "widgets.dart";

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.isUpperCase = true,
    this.titleStyle,
    this.caretColor,
  });

  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final Color? titleColor;
  final Color? caretColor;
  final bool isUpperCase;

  @override
  Widget build(BuildContext context) {
    return Align(
      // padding: const EdgeInsets.symmetric(vertical: Paddings.huge),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: Paddings.actionSeparator,
            ),
            child: Text(
              (isUpperCase) ? title.toUpperCase() : title,
              style: titleStyle ??
                  resolveHeadlineTextThemeForBreakPoints(
                    MediaQuery.of(context).size.width,
                    context,
                  )!
                      .copyWith(
                    color: titleColor ?? Colors.white,
                  ),
            ),
          ),
          subtitle != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Paddings.listSeparator,
                  ),
                  child: Text(
                    subtitle!,
                    style: resolveBodyTextThemeForBreakPoints(
                      MediaQuery.of(context).size.width,
                      context,
                    )!
                        .copyWith(color: titleColor ?? Colors.white),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            width: 60,
            height: 18,
            color: caretColor ?? Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
