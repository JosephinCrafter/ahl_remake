part of 'widgets.dart';

enum Actions {
  aboutUs,
  home,
  news,
  ourProjects,
  prayers,
  makeDonation,
  contact,
}

/// A short hand to get website tabs.
///
/// The website tabs like home, prayers, and over tabs are called action. They
/// are accessed via the [AppBar] or [Footer].
///
/// To get localized map string, use [actionLocalized] function that takes a
/// [BuildContext] argument and return a map with the localized title and the
/// corresponding route name as value.
class ActionsLists {
  ActionsLists._();

  /// Return a map of localized action denomination and their routeName as Value.
  ///
  /// Call this function inside a build method to get the corresponding route
  /// an action.
  ///
  /// Outside a [build] method, consider using the [actions].
  static Map<String, String?> actionLocalized(BuildContext context) {
    Map<String, String?> actions = <String, String?>{
      AppLocalizations.of(context)!.aboutUs: null,
      AppLocalizations.of(context)!.homeText: HomePage.routeName,
      AppLocalizations.of(context)!.news: null,
      AppLocalizations.of(context)!.ourProjects: null,
      AppLocalizations.of(context)!.prayers: null,
      AppLocalizations.of(context)!.makeDonation: null,
      AppLocalizations.of(context)!.contact: null,
    };

    return actions;
  }

  /// A simple map of string that has as key action names and as value route
  /// names.
  static Map<String, String?> actions = {
    "about_us": null,
    "home": HomePage.routeName,
    "news": null,
    "our_projects": null,
    "prayers": null,
  };

  /// A List of actions as widget.
  ///
  /// This list was optimized for the app drawer. For specific implementation
  /// like in footer, consider building actionsWidgets from [ActionsLists.actions]
  /// or [ActionsLists.actionLocalized] to make mapping between actions and
  /// Widgets.
  static final List<Widget> actionsWidgets = <Widget>[
    Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: TextButton(
          onPressed: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: Paddings.medium),
            child: Text(
              AppLocalizations.of(context)!.aboutUs,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    ),
    Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: TextButton(
          onPressed: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: Paddings.medium),
            child: Text(
              AppLocalizations.of(context)!.prayers,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    ),
    Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: TextButton(
          onPressed: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: Paddings.medium),
            child: Text(
              AppLocalizations.of(context)!.ourProjects,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    ),
    Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Paddings.small),
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ArticleView.routeName);
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: Paddings.medium),
            child: Text(
              AppLocalizations.of(context)!.articles,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Aileron',
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    ),
    Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 64),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Container(
            padding: ButtonGeometry.elevatedButtonPaddings,
            child: Text(AppLocalizations.of(context)!.makeDonation),
          ),
        ),
      ),
    ),
  ];
}
