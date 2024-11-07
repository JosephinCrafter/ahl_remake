part of '../../ahl_barrel.dart';

/// This source file collect all assets in the project and provide handier
/// way to interact with them.
///
/// To each assets correspond an

class AhlAssets {
  const AhlAssets._(); // Prevent for instantiation

  static String get releasePath =>
      kDebugMode ? '' : 'assets/'; // used to set up path when deployed

  static String heroBk = "${releasePath}images/hero_bk.webp";
  static String heroBkAlt = "${releasePath}images/praying_alt.webp";
  static String logoForm = "${releasePath}images/logo_form_colored.webp";
  static String logoFormTypoHorizontalColored =
      "${releasePath}images/logo_form_typo_horizon_colored.webp";
  static String logoFormTypoHorizontalColoredDark =
      "${releasePath}images/logo_form_typo_horizontal_colored_dark.webp";
  static String logoNdd = "${releasePath}images/logo_ndd.webp";
  static String priorAvatar = "${releasePath}images/prior_avatar.webp";

  static String prayersSpaceCover =
      "${releasePath}images/prayers_space_banner.webp";
  @Deprecated("use projectSpaceCover instead.")
  static String projectHeroHeader =
      "${releasePath}images/projects_hero_header.webp";
  static String cantineImage = "${releasePath}images/cantine_hero.webp";
  static String rosaryHeroHeader =
      "${releasePath}images/rosary_hero_header.webp";
  static String praying = "${releasePath}images/praying.webp";
  static String prayingAlt = "${releasePath}images/praying_alt.webp";
  static String requestMotif = "${releasePath}images/motif_prayer.jpg";
  static String projectSpaceCover =
      '${releasePath}images/project_space_banner.webp';
  static String dons = '${releasePath}images/SVG/dons.svg';
  static String doneAnimation = '${releasePath}animations/done.lottie';
}
