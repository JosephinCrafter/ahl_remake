part of "widgets.dart";

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {super.key, required this.title, this.subtitle, this.color});

  final String title;
  final String? subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Paddings.huge),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            child: Text(
              title.toUpperCase(),
              style: resolveHeadlineTextThemeForBreakPoints(
                MediaQuery.of(context).size.width,
                context,
              )!
                  .copyWith(
                color: color ?? Colors.white,
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
                        .copyWith(color: color ?? Colors.white),
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            width: 60,
            height: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
