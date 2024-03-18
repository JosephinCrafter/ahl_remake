import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/ahl_barrel.dart';
import '../theme/theme.dart' as theme;
import '../validation/email_validation.dart';

part 'view/news_letter_view.dart';
part 'bloc/bloc.dart';
part 'event/event.dart';
part 'state/state.dart';
part 'newsletter_repository.dart';
