import 'package:ahl/src/article_view/state/state.dart';
import 'package:ahl/src/project_space/bloc.dart';
import 'package:ahl/src/project_space/model.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../articles/article_view_test.dart';

void main() {
  group('ProjectBloc test', () {
    blocTest("initialize bloc", build: () => ProjectBloc(firebaseFirestore: fakeFirestore),
    expect: () => [
      isA<ArticleState<Project>>()
    ] );
  });
}
