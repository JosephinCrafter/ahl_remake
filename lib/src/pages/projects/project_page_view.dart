import 'package:ahl/src/ahl_barrel.dart';
import 'package:ahl/src/article_view/view/article_view.dart';
import 'package:ahl/src/newsletter/newsletter.dart';
import 'package:ahl/src/pages/projects/projects_page.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/project_space/view.dart';
import 'package:ahl/src/widgets/widgets.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectPageView extends StatefulWidget {
  ProjectPageView({
    super.key,
    required this.project,
    this.collection = "projects",
  }) : relatedArticles = buildRelatedArticle(
          const Article(
            id: 'id',
          ),
        ); // change this to the build relations

  /// The current project to be displayed
  final Article project;
  final List<Article> relatedArticles;
  final String collection;

  static List<Article> buildRelatedArticle(Article article) {
    List<Article> relatedArticles = [];

    //  building articles;
    //todo: replace with the real implementation
    relatedArticles.addAll(
      [
        const Article(
          id: 'Fête de fin d\'année',
          releaseDate: '22/06/2024',
          contentPath: 'fete_fin_d\'annee.md',
          title: 'Fête de fin d\'année Cantine',
        ),
        const Article(
          id: 'Rapport fin',
          releaseDate: '17/07/2024',
          contentPath: 'rapport.md',
          title: 'Rapport Cantine 2023-2024',
        ),
      ],
    );

    return relatedArticles;
  }

  @override
  State<StatefulWidget> createState() => _ProjectPageViewState();
}

class _ProjectPageViewState extends State<ProjectPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AhlAppBar(
        preferredSize: const Size.fromHeight(75 + 30),
        bottomBar: Flexible(
          child: Container(
            // constraints: BoxConstraints(
            //   maxWidth: ContentSize.maxWidth(
            //     MediaQuery.sizeOf(context).width,
            //   ),
            // ),
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Description",
                ),
                Tab(
                  text: "Actualités",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectDescriptionContentView(article: widget.project),
          ProjectNewsView(relatedArticles: widget.relatedArticles),
        ],
      ),
    );
  }
}

class ProjectDescriptionContentView extends StatelessWidget {
  const ProjectDescriptionContentView({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    // List<Widget> suggestion = context.read<ProjectBloc>().state.articles?.map<Widget>((element)=>).toList();
    return ListView(
      children: [
        ArticleContentView(
          article: article,
          collection: "/projects",
        ),
        const NewsLetterPrompt(),
        const AhlDivider(leading: 0, trailing: 0),
        //  ...suggestion,
        const AhlDivider(leading: 0, trailing: 0),
        const AhlFooter(),
      ],
    );
  }
}

class ProjectNewsView extends StatelessWidget {
  const ProjectNewsView({
    super.key,
    required this.relatedArticles,
  });

  final List<Article> relatedArticles;

  @override
  Widget build(BuildContext context) {
    // List<Widget> suggestion = context.read<ProjectBloc>().state.articles?.map<Widget>((element)=>).toList();
    return ListView(
      children: [
        //
        Container(
          alignment: Alignment.center,
          height: 500,
          child: Text(
            AppLocalizations.of(context)!.availableSoon,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const NewsLetterPrompt(),
        const AhlDivider(leading: 0, trailing: 0),
        //  ...suggestion,
        const AhlDivider(leading: 0, trailing: 0),
        const AhlFooter(),
      ],
    );
  }
}
