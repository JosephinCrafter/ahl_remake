import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {

  test("bare test", () {
    var a = 0;
    var b = a;
    expect(a == b, true);
  });

  testWidgets("Try a test on a widget", (widgetTester) async {
    String title = "App title";
    Widget myApp = MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(
          child: Text("Test App"),
        ),
      ),
    );

    await widgetTester.pumpWidget(myApp);
  });
}
