import 'package:ahl/src/utils/breakpoint_resolver.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Breakpoint resolver test',
    () {
      final testValues = [
        'small',
        'medium',
        'large',
        'extraLarge',
        'huge',
        'extraHuge'
      ];

      final breakPoints = <double>[
        450,
        500,
        820,
        1100,
        1500,
        1920,
      ];

      for (int i = 0; i < breakPoints.length; i++) {
        double constraints =
            breakPoints[i]; //BoxConstraints(maxWidth: breakPoints[i]);
        String result = resolveForBreakPoint<String>(
          constraints,
          other: testValues.last,
          small: testValues[0],
          medium: testValues[1],
          large: testValues[2],
          extraLarge: testValues[3],
          huge: testValues[4],
          extraHuge: testValues.last,
        );
        expect(result == testValues[i], true);
      }
    },
  );
}
