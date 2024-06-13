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
    this.actions = const [],
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
  final List<Widget> actions;
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
      onTap: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false),
      child: this.title,
    );

    /// background color of the app bar
    var color = backgroundColor ?? Theme.of(context).colorScheme.surface;

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
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
              Expanded(
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
            ending: const SizedBox.shrink(),
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
        child: IconButton(
          onPressed: () => scaffoldState.openEndDrawer(),
          icon: const Icon(
            Icons.menu,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
