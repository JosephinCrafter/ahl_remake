part of 'widgets.dart';

class AhlFooter extends StatelessWidget {
  const AhlFooter({super.key, this.actionColor = const Color(0xFFA0ABC0)});

  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    var footerButtons = ActionsLists.actionLocalized(context).entries.map(
          (e) => Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                if (e.value != null) {
                  Navigator.pushNamed(context, e.value!);
                }
              },
              child: Text(
                e.key,
                style: TextStyle(
                  fontFamily: 'Aileron',
                  color: actionColor,
                ),
              ),
            ),
          ),
        );

    return Container(
      color: theme.AhlTheme.darkNight,
      padding: const EdgeInsets.symmetric(
        horizontal: Paddings.medium,
        vertical: Paddings.big,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ahl logo in the footer.
          //
          // The size of this logo is fix
          Container(
            alignment: Alignment.centerLeft,
            constraints: const BoxConstraints(
              maxHeight: 75,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: Paddings.big,
              horizontal: Paddings.small + 5,
            ),
            child: Image.asset(AhlAssets.logoFormTypoHorizontalColoredDark),
          ),
          const Row(children: []),

          // Footer actions buttons.
          //
          // These buttons are the actions on the app bar and other
          // important or not buttons across the app.
          //
          //  To make them work, we use a default text theme

          Table(
            children: [
              TableRow(
                children: [
                  footerButtons.toList()[Actions.ourProjects.index],
                  footerButtons.toList()[Actions.makeDonation.index],
                ],
              ),
              TableRow(
                children: [
                  footerButtons.toList()[Actions.aboutUs.index],
                  footerButtons.toList()[Actions.news.index],
                ],
              ),
              TableRow(
                children: [
                  footerButtons.toList()[Actions.prayers.index],
                  footerButtons.toList()[Actions.contact.index],
                ],
              ),
            ],
          ),

          /// Sisters denomination
          Padding(
            padding: const EdgeInsets.symmetric(
                    vertical: Paddings.big, horizontal: Paddings.small + 5)
                .copyWith(bottom: 0),
            child: Text(
              AppLocalizations.of(context)!.sisterDenomination,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Paddings.small + 5,
              vertical: Paddings.small,
            ),
            child: Text(
              'Copyright ${DateTime.now().year}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
