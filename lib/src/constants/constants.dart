part of '../ahl_barrel.dart';

class BorderSizes {
  //30
  static const double big = 30;

  // 26
  static const double medium = 26;
}

class Margins {
  /// 200
  static const double big = 200;

  /// big / 2 = 100
  static const double medium = 100;

  /// big / 4 = 50
  static const double small = 50;

  /// 37
  static const double mobileLarge = 37;

  /// 24
  static const double mobileMedium = 24;

  /// 12
  static const double mobileSmall = 12;

  /// 166 : Top margin of the hero header
  static const double heroHeaderExtraTop = 166;
}

class ScreenSizes {
  static const double mobile = 600;
  static const double tablet = 1080;
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

  static const double medium = 24;
  static const double large = medium * 2;
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
  static const double heroHeaderExtrasWidth = 450;
}

class Durations {
  Durations._();

  /// 300 ms
  static const Duration subtle = Duration(milliseconds: 300);
}
