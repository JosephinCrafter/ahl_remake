import 'package:ahl/src/utils/firebase_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "GetCollection ",
    () {
      test(
        'on single element',
        () {
          String? collection = getCollection('/collection/document');

          expect(collection, 'collection');
        },
      );
      test(
        'on multiple element',
        () {
          String? collection =
              getCollection('/collection/document/anotherCollection/document');

          expect(collection, 'collection/document/anotherCollection');
        },
      );
      test(
        'no collection',
        () {
          String? collection =
              getCollection('document');

          expect(collection, null);
        },
      );
    },
  );
}
