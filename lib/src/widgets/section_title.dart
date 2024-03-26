part of "widgets.dart";

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2 * Paddings.huge),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Paddings.listSeparator,
            ),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.white,
                          fontFamily: "Butler",
                        ),
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
