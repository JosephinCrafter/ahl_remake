part of '../ahl_barrel.dart';

class BorderSizes {
  /// 45
  static const double huge = 45;

  /// 30
  static const double big = 30;

  /// 26
  static const double medium = 26;

  /// 15
  static const double small = 15;
}

class Margins {
  /// 236
  static const double extraHuge = 236;

  /// 200
  static const double huge = 200;

  /// 50
  static const double extraLarge = 50;

  /// 37
  static const double large = 32;

  /// 24
  static const double medium = 24;

  /// 16
  static const double small = 16;

  /// 166 : Top margin of the hero header
  static const double heroHeaderExtraTop = 166;
}

/// Compute content size based on breakpoints
class ContentSize {
  /// MaxWidth considering the breakpoints as widthConstraints.
  static double maxWidth(double widthConstraints) {
    return resolveForBreakPoint<double>(
      widthConstraints,
      extraHuge: 1128,
      other: 966,
    );
  }
}

class ScreenSizes {
  /// Phone size small than 480.
  static const double small = 480;

  /// Phone size when in landscape mode : 780.
  static const double medium = 780;

  /// Tablet in portrait mode : 1024
  static const double large = 1024;

  /// Tablet in landscape mode and laptop or desktop : 1280
  static const double extraLarge = 1280;

  /// Laptop and desktop more than 1600
  static const double huge = 1600;
}

class Paddings {
  Paddings._();

  /// 45 px
  static const double huge = 45;

  /// 30 px
  static const double big = 30;

  /// 27 px
  static const double drawerAppBarPadding = 27;

  /// 8 px
  static const double appBarPadding = 8;

  /// 15 px
  static const double listSeparator = 15;

  /// 21 px
  static const double actionSeparator = 21;

  /// A padding of 15 px
  static const double medium = 15;

  /// A padding of 7.5 px.
  ///
  /// It is computed as the half of medium.
  static const double small = medium / 2;
}

class Sizes {
  Sizes._();
  static const double appBarSize = 75; // 64 from design
  static const double menuButtonWidth = 400;
  static const double menuButtonListHeight = 400;
  static const double mobileHeroHeaderImageHeight = 350;
  static const double nddLogoSize = 76;

  //  48 px
  static const double iconSize = 48;
}

class IconSizes {
  IconSizes._();

  /// 24
  static const double medium = 24;

  /// 48
  static const double large = medium * 2;

  /// 12
  static const double small = medium / 2;
}

class ButtonGeometry {
  ButtonGeometry._();

  static const EdgeInsets elevatedButtonPaddings =
      EdgeInsets.symmetric(vertical: 10);
}

class HeroHeaderGeometry {
  HeroHeaderGeometry._();

  static const double heroHeaderExtrasHeight = 200;
  static const double heroHeaderExtrasWidth = 650;
}

class AhlDurations {
  AhlDurations._();

  /// 300 ms
  static const Duration subtle = Duration(milliseconds: 300);
}
