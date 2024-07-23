import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Project extends Article {
  Project({
    required super.id,
    required super.title,
    super.contentPath,
    super.relations,
    super.releaseDate,
  });

  String? get status {
    return relations?[0]['status'];
  }
}

extension LocalizedProject on Project {
  static String? getProjectStatus(BuildContext context, String projectStatus) {
    switch (projectStatus) {
      case "inProgress":
        return AppLocalizations.of(context)?.inProgress;
      case "waitingBudget":
        return AppLocalizations.of(context)?.waitingBudget;
      case "done":
        return AppLocalizations.of(context)?.done;
      default:
        return "";
    }
  }
}
