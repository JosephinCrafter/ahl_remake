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
      alignment: Alignment.center,
      color: theme.AhlTheme.darkNight,
      padding: const EdgeInsets.symmetric(
        horizontal: Paddings.medium,
        vertical: Paddings.big,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ContentSize.maxWidth(MediaQuery.of(context).size.width),
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

            // Footer actions buttons.
            //
            // These buttons are the actions on the app bar and other
            // important or not buttons across the app.
            //
            //  To make them work, we use a default text theme

            // Table(
            //   children: [
            //     TableRow(
            //       children: [
            //         footerButtons.toList()[Actions.ourProjects.index],
            //         footerButtons.toList()[Actions.makeDonation.index],
            //       ],
            //     ),
            //     TableRow(
            //       children: [
            //         footerButtons.toList()[Actions.aboutUs.index],
            //         footerButtons.toList()[Actions.news.index],
            //       ],
            //     ),
            //     TableRow(
            //       children: [
            //         footerButtons.toList()[Actions.prayers.index],
            //         footerButtons.toList()[Actions.contact.index],
            //       ],
            //     ),
            //   ],
            // ),

            // Home
            FooterPageButton(
              callback: () {
                Navigator.of(context).pushNamed(HomePage.routeName);
              },
              icon: const Icon(Icons.home_filled),
              text: AppLocalizations.of(context)!.homeText,
            ),
            const Gap(45),

            Wrap(
              direction: Axis.horizontal,
              runSpacing: Paddings.huge,
              spacing: Paddings.huge,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FooterProminentButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(PrayersPage.routeName),
                      text: AppLocalizations.of(context)!.priesSpace,
                    ),
                    FooterLowLevelButton(
                      callback: () =>
                          Navigator.of(context).pushNamed(RosaryPage.routeName),
                      text: AppLocalizations.of(context)!.rosary,
                    ),
                    FooterLowLevelButton(
                      callback: () {},
                      text: AppLocalizations.of(context)!.priesIntention,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FooterProminentButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.projectsSpace,
                    ),
                    FooterLowLevelButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.inProgress,
                    ),
                    FooterLowLevelButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.realized,
                    ),
                    FooterLowLevelButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.initiative,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FooterProminentButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(WhoWeArePage.routeName),
                      text: AppLocalizations.of(context)!.domSisters,
                    ),
                    FooterLowLevelButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(WhoWeArePage.routeName),
                      text: AppLocalizations.of(context)!.whoWeAre,
                    ),
                    FooterLowLevelButton(
                      callback: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.devInProgress,
                          ),
                        ),
                      ),
                      text: AppLocalizations.of(context)!.realized,
                    ),
                    FooterLowLevelButton(
                      callback: () => Navigator.of(context)
                          .pushNamed(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.initiative,
                    ),
                  ],
                )
              ],
            ),

            const Gap(45),

            Container(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FooterIconButton(
                    callback: () {
                      launchUrl(
                        Uri.parse("https://web.facebook.com/LaureSabes"),
                      );
                    },
                    icon: MyFlutterIcons.facebook_circled,
                  ),
                  FooterIconButton(
                    callback: () {
                      launchUrl(
                        Uri.parse(
                            "https://www.youtube.com/@DominicainesMissionnairesMada"),
                      );
                    },
                    icon: MyFlutterIcons.youtube,
                  ),
                  FooterIconButton(
                    callback: () {
                      //todo: implement whatsapp
                    },
                    icon: MyFlutterIcons.whatsapp,
                  ),
                ],
              ),
            ),

            /// Sisters denomination
            Padding(
              padding: const EdgeInsets.symmetric(
                      vertical: Paddings.big, horizontal: Paddings.small + 5)
                  .copyWith(bottom: 0),
              child: Text(
                '© ${DateTime.now().year}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: theme.AhlTheme.yellowLight,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Paddings.small + 5,
                vertical: Paddings.small,
              ),
              child: Text(
                AppLocalizations.of(context)!.sisterDenomination,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: theme.AhlTheme.yellowLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The page button in footer.
class FooterPageButton extends StatelessWidget {
  const FooterPageButton({
    super.key,
    required this.callback,
    required this.icon,
    required this.text,
  });

  /// This buttons callback.
  final VoidCallback callback;

  /// This buttons leading Widget.
  final Widget icon;

  /// This button text
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white;
              } else {
                return theme.AhlTheme.yellowLight.withAlpha(0x88);
              }
            },
          ),
        ),
        onPressed: callback,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Paddings.small),
              child: icon,
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}

class FooterProminentButton extends StatelessWidget {
  const FooterProminentButton({
    super.key,
    required this.callback,
    required this.text,
  });

  final VoidCallback callback;

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (states) => theme.AhlTheme.yellowLight,
        ),
        textStyle: WidgetStateTextStyle.resolveWith(
          (states) {
            FontWeight ftw = FontWeight.w400;
            if (states.contains(WidgetState.hovered)) {
              ftw = FontWeight.w600;
            }

            return Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: ftw,
                );
          },
        ),
      ),
      onPressed: callback,
      child: Text(
        text,
      ),
    );
  }
}

class FooterLowLevelButton extends StatelessWidget {
  const FooterLowLevelButton({
    super.key,
    required this.callback,
    required this.text,
  });

  final VoidCallback callback;

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (states) => theme.AhlTheme.yellowLight.withAlpha(0x88),
        ),
        textStyle: WidgetStateTextStyle.resolveWith((states) {
          FontWeight ftw = FontWeight.w400;
          if (states.contains(WidgetState.hovered)) {
            ftw = FontWeight.w600;
          }

          return Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: ftw,
              );
        }),
      ),
      onPressed: callback,
      child: Text(
        text,
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  const FooterIconButton({
    super.key,
    required this.callback,
    required this.icon,
  });

  final VoidCallback callback;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith(
          (states) => theme.AhlTheme.yellowRelax,
        ),
      ),
      onPressed: callback,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
