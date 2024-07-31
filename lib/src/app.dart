import 'dart:developer';

import 'package:ahl/src/article_view/event/event.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/pages/novena_page/novena_page.dart';
import 'package:ahl/src/pages/projects/project_page_view.dart';
import 'package:ahl/src/project_space/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_article/firebase_article.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:ahl/src/pages/homepage/donation/donation_page.dart';
import 'package:ahl/src/pages/prayers/prayers_page.dart';
import 'package:ahl/src/pages/projects/projects_page.dart';
import 'package:ahl/src/pages/rosary/rosary_page.dart';
import 'package:ahl/src/pages/who_we_are/who_we_are.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/article_view/bloc/bloc.dart';
import 'article_view/state/state.dart';
import 'firebase_constants.dart';
import 'pages/homepage/homepage.dart';
import 'theme/theme.dart';
import 'settings/settings_controller.dart';

/// The route widget of the website.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    this.home,
  });

  final SettingsController settingsController;
  final Widget? home;

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocal(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale('fr', 'FR');
  late SettingsController settingsController;

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: HomePage.routeName,
        builder: (_, __) => const HomePage(),
        routes: [
          /// Project
          GoRoute(
            path: ProjectsPage.routeName,
            name: ProjectsPage.routeName,
            builder: (_, __) => const ProjectsPage(),
            routes: [
              GoRoute(
                path: ":projectId",
                // name: ProjectsPage.routeName,
                builder: (context, state) {
                  // get article id from path
                  String? projectId = state.pathParameters["projectId"];

                  //? Not working
                  // when no project isn't specified, go to the all project.
                  // if (state.pathParameters.isEmpty || articleId == null) {
                  //   return const ProjectsPage();
                  // } else {
                  //   context.read<ProjectBloc>().add(
                  //         GetArticleByIdEvent(id: articleId),
                  //       );
                  //   return BlocBuilder<ProjectBloc, ArticleState<Article>>(
                  //     builder: (context, state) {
                  //       // get project
                  //       var project = state.articles?[articleId];
                  //       if (project == null) {
                  //         return const ProjectsPage();
                  //       } else {
                  //         return ProjectPageView(project: project);
                  //       }
                  //     },
                  //   );
                  // }

                  // Passing the article name to ProjectPageView instead
                  if (projectId != null && projectId.trim() != "") {
                    return ProjectPageView(
                      projectId: projectId,
                    );
                  } else {
                    return const ProjectsPage();
                  }
                },
              ),
            ],
          ),
          // GoRoute(
          //   path: ArticleView.routeName,
          //   builder: (_, __) => const ProjectsPage(),
          //   routes: [

          // Articles
          GoRoute(
            name: ArticleContentPage.routeName,
            path: "${ArticleContentPage.routeName}/:articleId",
            // name: ProjectsPage.routeName,
            builder: (context, state) {
              // get article id from path
              String? articleId = state.pathParameters["articleId"];

              // Passing the article name to ProjectPageView instead
              if (state.extra != null) {
                return ArticleContentPage(
                  article: state.extra as Article,
                );
              } else /*if (articleId != null && articleId.trim() != "")*/ {
                return ArticleContentPage.fromId(articleId: articleId);
              }
              // else {
              //   return const ArticlesPage();
              // }
            },
          ),

          GoRoute(
            name: NovenaPage.routeName,
            path: "${NovenaPage.routeName}/:novenaId",
            // name: ProjectsPage.routeName,
            builder: (context, state) {
              // get article id from path
              String? articleId = state.pathParameters["novenaId"];

              // Passing the article name to ProjectPageView instead
              if (state.extra != null) {
                return NovenaPage(
                  novena: state.extra as Article,
                );
              } else /*if (articleId != null && articleId.trim() != "")*/ {
                return NovenaPage.fromId(novenaId: articleId);
              }
              // else {
              //   return const ArticlesPage();
              // }
            },
          ),
          //   ],
          // ),
          GoRoute(
            path: PrayersPage.routeName,
            name: PrayersPage.routeName,
            builder: (_, __) => const PrayersPage(),
            routes: [
              GoRoute(
                path: RosaryPage.routeName,
                name: RosaryPage.routeName,
                builder: (_, __) => const RosaryPage(),
              ),
            ],
          ),
          GoRoute(
            path: WhoWeArePage.routeName,
            name: WhoWeArePage.routeName,
            builder: (_, __) => const WhoWeArePage(),
          ),
          GoRoute(
            path: DonationPage.routeName,
            name: DonationPage.routeName,
            builder: (_, __) => const DonationPage(),
          ),
        ],
      ),
    ],
  );

  void changeLanguage(Locale locale) {
    setState(
      () {
        _locale = locale;
        settingsController.updateLocales([locale]);
      },
    );
  }

  @override
  void initState() {
    settingsController = widget.settingsController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ArticleBloc(
            repo: ArticlesRepository<Article>(firestoreInstance: firestore),
          ),
        ),
        BlocProvider(
          create: (context) => ProjectBloc(
            firebaseFirestore: firestore,
          ),
        ),
      ],
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return LayoutBuilder(
            builder: (context, constraints) => MaterialApp.router(
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'ahl',

              // Provide the generated AppLocalizations to the MaterialApp. This
              // allows descendant Widgets to display the correct translations
              // depending on the user's locale.
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,

              // Use AppLocalizations to configure the correct application title
              // depending on the user's locale.
              //
              // The appTitle is defined in .arb files found in the localization
              // directory.
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,

              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: AhlTheme.lightTheme(
                MediaQuery.maybeOf(context)!.size.width,
              ),
              darkTheme: ThemeData.dark(
                useMaterial3: true,
              ),
              themeMode: settingsController.themeMode,

              // Define a function to handle named routes in order to support
              // Flutter web url navigation and deep linking.
              // onGenerateRoute: (RouteSettings routeSettings) {
              //   log("Route settings is $routeSettings");

              //   return MaterialPageRoute<void>(
              //     settings: routeSettings,
              //     builder: (BuildContext context) {
              //       return FutureBuilder(
              //         future: firebaseApp,
              //         builder: (context, snapshot) {
              //           if (snapshot.hasData) {
              //             switch (routeSettings.name) {
              //               case SettingsView.routeName:
              //                 return SettingsView(
              //                     controller: settingsController);
              //               case SampleItemDetailsView.routeName:
              //                 return const SampleItemDetailsView();
              //               case HomePage.routeName:
              //                 return HomePage();
              //               case ProjectsPage.routeName:
              //                 return const ProjectsPage();
              //               case PrayersPage.routeName:
              //                 return const PrayersPage();
              //               case RosaryPage.routeName:
              //                 return const RosaryPage();
              //               case SaintsPage.routeName:
              //                 return const SaintsPage();
              //               case ArticlesPage.routeName:
              //                 return const ArticlesPage();
              //               case WhoWeArePage.routeName:
              //                 return const WhoWeArePage();
              //               case DonationPage.routeName:
              //                 return const DonationPage();
              //               // todo: add 400 not found page
              //               default:
              //                 return widget.home ?? HomePage();
              //             }
              //           } else {
              //             return Scaffold(
              //               body: LoadingView(
              //                 work: firebaseApp,
              //               ),
              //             );
              //           }
              //         },
              //       );
              //     },
              //   );
              // },

              routerConfig: router,
            ),
          );
        },
      ),
    );
  }
}
