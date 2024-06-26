part of '../ahl_barrel.dart';

/// This source file collect all assets in the project and provide handier
/// way to interact with them.
///
/// To each assets correspond an

class AhlAssets {
  const AhlAssets._(); // Prevent for instantiation

  static String get releasePath =>
      kDebugMode ? '' : 'assets/'; // used to set up path when deployed

  static String heroBk = "${releasePath}images/hero_bk.webp";
  static String heroBkAlt = "${releasePath}images/hero_bk_alt.jpg";
  static String logoForm = "${releasePath}images/logo_form_colored.png";
  static String logoFormTypoHorizontalColored =
      "${releasePath}images/logo_form_typo_horizon_colored.png";
  static String logoFormTypoHorizontalColoredDark =
      "${releasePath}images/logo_form_typo_horizontal_colored_dark.png";
  static String logoNdd = "${releasePath}images/logo_ndd.png";
  static String priorAvatar = "${releasePath}images/prior_avatar.png";

  static String prayersSpaceCover =
      "${releasePath}images/prayers_space_banner.webp";
  @Deprecated("use projectSpaceCover instead.")
  static String projectHeroHeader =
      "${releasePath}images/projects_hero_header.png";
  static String cantineImage = "${releasePath}images/cantine_hero.png";
  static String rosaryHeroHeader =
      "${releasePath}images/rosary_hero_header.jpg";
  static String praying = "${releasePath}images/praying.png";
  static String prayingAlt = "${releasePath}images/praying_alt.png";
  static String requestMotif = "${releasePath}images/motif_prayer.webp";
  static String projectSpaceCover =
      '${releasePath}images/project_space_banner.webp';
}
