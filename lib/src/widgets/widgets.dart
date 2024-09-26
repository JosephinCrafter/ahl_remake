import 'dart:developer';
import 'dart:js_interop';

import 'package:ahl/src/pages/prayers/prayers_page.dart';
import 'package:audio_player/audio_player.dart';
import 'package:firebase_article/firebase_article.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ahl_barrel.dart';
import '../localization/locale_utils.dart';
import '../pages/homepage/donation/donation_page.dart';
import '../pages/homepage/homepage.dart';
import '../pages/projects/projects_page.dart';
import '../pages/who_we_are/who_we_are.dart';
import '../theme/theme.dart' as theme;
import '../theme/theme.dart';
import '../utils/breakpoint_resolver.dart';
import 'my_flutter_app_icons.dart';
import '../firebase_constants.dart';

part 'app_bar.dart';
part 'logo.dart';
part 'drawer.dart';
part 'actions.dart';
part 'promotion_bar.dart';
part 'footer.dart';
part 'prayers_request.dart';
part 'section_title.dart';
part 'prompt_card.dart';
part 'space_view.dart';
part 'forms_prompt.dart';
part 'audio_player.dart';
