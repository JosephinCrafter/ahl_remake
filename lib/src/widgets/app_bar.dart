part of 'widgets.dart';

/// class for the appBar
class AhlAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AhlAppBar({
    super.key,
    Size? preferredSize,
    this.title = const AhlLogo(
        // separation: SizedBox.shrink(),
        ),
    this.backgroundColor,
    this.actions,
    this.ending,
    this.crossAxisAlignment,
    this.padding,
    this.bottomBar,
  }) : _preferredSize = preferredSize ??
            const Size.fromHeight(
              Sizes.appBarSize,
            );

  /// The preferred size of this widget
  final Size _preferredSize;
  final Widget title;
  final List<Widget>? actions;
  final Widget? ending;
  final Color? backgroundColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomBar;

  Widget buildContentWidgets(
    BuildContext context, {
    Widget? leadingTitle,
    List<Widget>? actions,
    Widget? ending,
    Widget? bottomBar,
  }) {
    // make logo a button to home
    Widget title = InkWell(
      onTap: () => context.goNamed(
        HomePage.routeName,
      ),
      child: this.title,
    );

    /// background color of the app bar
    var color = backgroundColor ?? theme.AhlTheme.yellowLight;

    /// constraints
    BoxConstraints computedConstraint = BoxConstraints.loose(
      _preferredSize,
    );

    /// Paddings
    EdgeInsetsGeometry computedPadding = padding ??
        const EdgeInsets.all(
          Paddings.appBarPadding,
        );

    TextBaseline? computedTextBaseLine = (crossAxisAlignment != null)
        ? (crossAxisAlignment == CrossAxisAlignment.baseline)
            ? TextBaseline.ideographic
            : null
        : TextBaseline.alphabetic;

    Widget leadingTitle0 = leadingTitle ??
        Flexible(
          flex: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_rounded))
                    .animate()
                    .moveX(begin: -50, end: 0),
              Flexible(
                child: title,
              ),
            ],
          ),
        );

    return Container(
      constraints: computedConstraint,
      color: color,
      padding: computedPadding,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            textBaseline: computedTextBaseLine,
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              leadingTitle0,
              ...?actions,
              ending ?? const AhlMenuButton(),
            ],
          ),
          bottomBar ?? const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // make logo a button to home

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= ScreenSizes.large) {
          // use the mobile appBar
          return buildContentWidgets(
            context,
            actions: actions,
            ending: ending ?? const AhlMenuButton(),
            bottomBar: bottomBar ?? const SizedBox.shrink(),
          );
        } else {
          // Use the default web appBar
          return buildContentWidgets(
            context,
            actions: actions ?? buildActions(context),
            ending: const SizedBox.shrink(),
            bottomBar: bottomBar ?? const SizedBox.shrink(),
          );
          // return Container(
          //   constraints: computedConstraint,
          //   color: color,
          //   padding: computedPadding,
          //   alignment: Alignment.center,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Row(
          //         textBaseline: computedTextBaseLine,
          //         crossAxisAlignment:
          //             crossAxisAlignment ?? CrossAxisAlignment.baseline,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           leadingTitle,
          //           ...actions,
          //         ],
          //       ),
          //       bottomBar ?? const SizedBox.shrink(),
          //     ],
          //   ),
          // );
        }
      },
    );
  }

  static List<Widget> buildActions(BuildContext context) {
    List<Widget> actionsList = [];

    String? currentRouteName = ModalRoute.of(context)?.settings.name;

    TextStyle? resolveStyle(String routeName) {
      return (routeName == currentRouteName)
          ? Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )
          : null;
    }

    TextStyle? resolveStyleIf(bool Function() test) {
      return (test())
          ? Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )
          : null;
    }

    Map actions = {
      AppLocalizations.of(context)!.homeText: HomePage.routeName,
      AppLocalizations.of(context)!.priesSpace: PrayersPage.routeName,
      AppLocalizations.of(context)!.projectsSpace: ProjectsPage.routeName,
      AppLocalizations.of(context)!.whoWeAre: WhoWeArePage.routeName,
      AppLocalizations.of(context)!.makeDonation: DonationPage.routeName,
    };

    Widget donationButton = Flexible(
      flex: 2,
      child: Container(
        alignment: Alignment.centerRight,
        child: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: WidgetStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onPressed: () {
            context.goNamed(DonationPage.routeName);
          },
          // child: FittedBox(
          //   fit: BoxFit.contain,
          child: Text(
            actions.keys.lastOrNull,
          ),
          // ),
        ),
      ),
    );
    Widget homeButton = // Flexible(
        //   //   flex: 1,
        //   child:
        Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () {
          context.goNamed(HomePage.routeName);
        },
        child: Text(
          actions.keys.elementAtOrNull(0),
          style: resolveStyleIf(
            () {
              return (currentRouteName == actions.values.elementAt(0) ||
                  currentRouteName == "/");
            },
          ),
        ),
      ),
      // ),

      // ),
    );

    Widget projectsButton = TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onPressed: () {
        context.goNamed(ProjectsPage.routeName);
      },
      child: Text(
        actions.keys.elementAtOrNull(2),
        style: resolveStyle(actions.values.elementAt(2)),
      ),

      // PopupMenuButton(
      /// This part of the code is defining a `PopupMenuButton` widget. The `child` property is setting
      /// the text that will be displayed on the button. In this case, it is setting the text based on
      /// the key at index 2 of the `actions` map.
      // child: Text(actions.keys.elementAtOrNull(2)),

      // itemBuilder: (context) => [
      //   PopupMenuItem(
      //     onTap: () {
      //       context.goNamed(
      //         ProjectsPage.routeName,
      //       );
      //     },
      //     child: const Text('Projet En cours'),
      //   ),
      //   PopupMenuItem(
      //     onTap: () {
      //       context.goNamed(
      //         ProjectsPage.routeName,
      //       );
      //     },
      //     child: const Text('Initiative des soeurs'),
      //   ),
      //   PopupMenuItem(
      //     onTap: () {
      //       context.goNamed(
      //         ProjectsPage.routeName,
      //       );
      //     },
      //     child: const Text('Soutenir un projet'),
      //   ),
      // ],
      // // style: ButtonStyle(
      //   foregroundColor: WidgetStateColor.resolveWith(
      //     (states) => Theme.of(context).colorScheme.onSurface,
      //   ),
      // ),
      // onChanged: (value) => 1,
      // onPressed: () {},
      // child: Text(
      //   actions.keys.elementAtOrNull(2),
      //   style: resolveStyle(actions.values.elementAtOrNull(2)),
      // ),

      // ),
    );
    Widget aboutUsButton = // Flexible(
        //   //   flex: 1,
        //   child:
        Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () {
          context.goNamed(
            WhoWeArePage.routeName,
          );
        },
        child: Text(
          actions.keys.elementAtOrNull(3),
          style: resolveStyle(actions.values.elementAtOrNull(3)),
        ),
      ),

      // ),
    );
    Widget priersSpaceButton = // Flexible(
        //   //   flex: 1,
        //   child:
        Container(
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: WidgetStateColor.resolveWith(
            (states) => Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onPressed: () {
          context.goNamed(PrayersPage.routeName);
        },
        child: Text(
          actions.keys.elementAtOrNull(1),
          style: resolveStyle(actions.values.elementAtOrNull(1)),
        ),
      ),

      // ),
    );

    actionsList.addAll(
      [
        homeButton,
        priersSpaceButton,
        projectsButton,
        aboutUsButton,
        donationButton,
      ],
    );

    return actionsList;
  }

  @override
  Size get preferredSize => _preferredSize;
}

class AhlMenuButton extends StatelessWidget {
  const AhlMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    ScaffoldState scaffoldState = Scaffold.of(context);
    bool scaffoldHasEndDrawer = scaffoldState.hasEndDrawer;
    if (scaffoldHasEndDrawer) {
      return Hero(
        tag: 'menu_button_tag',
        child: Container(
          alignment: Alignment.center,
          width: 32,
          height: 32,
          // alignment: Alignment.center,
          child: IconButton(
            onPressed: () => scaffoldState.openEndDrawer(),
            icon: Container(
              alignment: Alignment.center,
              child: const FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  size: 24,
                  MyFlutterIcons.menu,
                  applyTextScaling: true,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
