// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:ahl/src/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Plus Operator', () {
    test('should add two numbers together', () {
      expect(1 + 1, 2);
    });
  });

  group(
    'actions test',
    () {
      /// The [ActionsLists] contain a static member [ActionsLists.actions] that is
      /// [Map<String,String>]. The key represents the name of the actions. And the
      /// corresponding value is the route name of the action.
      ///
      /// This [Map] is used to set up the [AppBar] actions and [Footer] actions.
      ///
      /// This test try to get the member. This is the only one responsibility of the class.
      test(
        'get action and rootNames from the static action list',
        () {
          var actions = ActionsLists.actions;

          expect(actions.isNotEmpty, true);
        },
      );
    },
  );
}
