part of 'widgets.dart';

class AhlDrawer extends StatelessWidget {
  const AhlDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        width: constraints.maxWidth,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          appBar: AhlAppBar(
            padding: const EdgeInsets.only(left: Paddings.drawerAppBarPadding),
            crossAxisAlignment: CrossAxisAlignment.center,
            title: AhlLogo(
              crossAxisAlignment: CrossAxisAlignment.center,
              leading: const Icon(
                Icons.home_filled,
                color: Colors.black54,
                size: IconSizes.medium,
              ),
              separation: Container(width: 9),
              title: Text(
                AppLocalizations.of(context)!.longAppTitle,
              ),
            ),
            ending: Hero(
              tag: 'menu_button_tag',
              child: IconButton(
                onPressed: () => Scaffold.of(context).closeEndDrawer(),
                icon: const Icon(Icons.close),
              ),
            ),
          ),

          // body of the drawer
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  // constraints: const BoxConstraints(
                  //   maxWidth: Sizes.menuButtonWidth,
                  //   maxHeight: Sizes.menuButtonListHeight,
                  // ),
                  margin: const EdgeInsets.only(left: Paddings.medium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...ActionsLists.actionsWidgets,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Intl.defaultLocale = 'fr_FR';

                        Navigator.of(context)
                            .pushReplacementNamed(HomePage.routeName);
                      },
                      child: const Text('Français'),
                    ),
                    const TextButton(
                      onPressed: null,
                      child: Text('English'),
                    ),
                  ],
                ),
              ),
              const DrawerFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: const BoxConstraints.expand(height: 50),
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: theme.AhlTheme.greenOlive),
        child: Text(
          'N.D.D MADAGASCAR 2023',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontFamily: 'Aileron',
                fontWeight: FontWeight.w100,
              ),
        ),
      ),
    );
  }
}
