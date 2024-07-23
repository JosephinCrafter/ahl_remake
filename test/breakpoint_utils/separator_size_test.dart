import "dart:developer";

import "package:ahl/src/utils/breakpoint_resolver.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets(
    'resolveSeparatorSize function is screen size adaptive.',
    (WidgetTester tester) async {
      Widget myApp = Builder(
        builder: (context) {
          log("${resolveSeparatorSize(context)}");

          return MediaQuery(
            data: const MediaQueryData(size: Size(320, 650)),
            child: Builder(builder: (context) {
              log("Constraints:${MediaQuery.of(context).size}, Separator Size:${resolveSeparatorSize(context)}");
              return MaterialApp(
                home: Align(
                  child: Text("${resolveSeparatorSize(context)}"),
                ),
              );
            }),
          );
        },
      );

      await tester.pumpWidget(myApp);

      expect(find.text('45.0'), findsOne);
    },
  );
}
