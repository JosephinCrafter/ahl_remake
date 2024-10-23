part of 'widgets.dart';

class AhlFooter extends StatelessWidget {
  const AhlFooter({super.key, this.actionColor = const Color(0xFFA0ABC0)});

  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    // var footerButtons = ActionsLists.actionLocalized(context).entries.map(
    //       (e) => Align(
    //         alignment: Alignment.centerLeft,
    //         child: TextButton(
    //           onPressed: () {
    //             if (e.value != null) {
    //               Navigator.pushNamed(context, e.value!);
    //             }
    //           },
    //           child: Text(
    //             e.key,
    //             style: TextStyle(
    //               fontFamily: 'Aileron',
    //               color: actionColor,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );

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
                      callback: () => context.goNamed(PrayersPage.routeName),
                      text: AppLocalizations.of(context)!.prayerSpace,
                    ),
                    FooterLowLevelButton(
                      callback: () => context.goNamed(PrayersPage.routeName),
                      text: AppLocalizations.of(context)!.todaysRosary,
                    ),
                    FooterLowLevelButton(
                      callback: () => context.goNamed(PrayersPage.routeName),
                      text: AppLocalizations.of(context)!.office,
                    ),
                    FooterLowLevelButton(
                      callback: () => context.goNamed(PrayersPage.routeName),
                      text: AppLocalizations.of(context)!.todaySaint,
                    ),
                    FooterLowLevelButton(
                      callback: () {
                        context.goNamed(PrayersPage.routeName);
                      },
                      text: AppLocalizations.of(context)!.priesIntention,
                    ),
                    FooterLowLevelButton(
                      callback: () {
                        context.go('/novena/saint_dominic_day_1');
                      },
                      text: AppLocalizations.of(context)!.novena,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FooterProminentButton(
                      callback: () => context.go(ProjectsPage.routeName),
                      text: AppLocalizations.of(context)!.projectsSpace,
                    ),
                    FooterLowLevelButton(
                      callback: () => context.go('/projects/cantine'),
                      text: 'Cantine',
                    ),
                    FooterLowLevelButton(
                      callback: () => context.go('/projects/dispensaire'),
                      text: 'Dispensaire',
                    ),
                    FooterLowLevelButton(
                      callback: () => context.go('/projects/grande_salle'),
                      text: 'Grande Salle',
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FooterProminentButton(
                      callback: () => context.go(WhoWeArePage.routeName),
                      text: AppLocalizations.of(context)!.domSisters,
                    ),
                    FooterLowLevelButton(
                      callback: () => context.go(WhoWeArePage.routeName),
                      text: AppLocalizations.of(context)!.whoWeAre,
                    ),
                    // FooterLowLevelButton(
                    //   callback: () =>
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text(
                    //         AppLocalizations.of(context)!.devInProgress,
                    //       ),
                    //     ),
                    //   ),
                    //   text: AppLocalizations.of(context)!.realized,
                    // ),
                    // FooterLowLevelButton(
                    //   callback: () => context.go(ProjectsPage.routeName),
                    //   text: AppLocalizations.of(context)!.initiative,
                    // ),
                  ],
                )
              ],
            ),

            const Gap(45),

            /// Sisters denomination
            // Flex(
            //   textDirection: TextDirection.ltr,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   direction: resolveForBreakPoint(
            //     MediaQuery.of(context).size.width,
            //     other: Axis.horizontal,
            //     small: Axis.vertical,
            //     medium: Axis.vertical,
            //   ),

            Wrap(
              verticalDirection: VerticalDirection.down,

              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.spaceBetween,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              // runSpacing: 200,
              spacing: 50,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 100,
                  ),
                  child: Column(
                    textDirection: TextDirection.ltr,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                                // vertical: Paddings.big,
                                horizontal: Paddings.small + 5)
                            .copyWith(bottom: 0),
                        child: Text(
                          '© ${DateTime.now().year}',
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
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
                          AppLocalizations.of(context)!.appTitle,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: theme.AhlTheme.yellowLight),
                        ),
                      ),
                    ],
                  ),
                ),
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
              ],
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
