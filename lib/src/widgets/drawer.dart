part of 'widgets.dart';

class AhlDrawer extends StatelessWidget {
  const AhlDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Drawer(
        clipBehavior: Clip.antiAlias,
        width: constraints.maxWidth,
        child: Scaffold(
          backgroundColor: theme.AhlTheme.yellowLight,
          appBar: AhlAppBar(
            backgroundColor: theme.AhlTheme.yellowLight,
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
              tag: 'menu_button_tag1',
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
                right: 20,
                bottom: 50,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: theme.AhlTheme.yellowLight,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          LocaleUtils.changeLocale(
                            context,
                            const Locale('fr'),
                          );
                        },
                        child: const Text('Français'),
                      ),
                      TextButton(
                        onPressed: () {
                          LocaleUtils.changeLocale(
                            context,
                            const Locale('en'),
                          );
                        },
                        child: const Text('English'),
                      ),
                    ],
                  ),
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
