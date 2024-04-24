import 'package:ahl/src/firebase_constants.dart';
import 'package:ahl/src/validation/email_validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ahl_barrel.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';

part 'view.dart';
part 'bloc.dart';
part 'model.dart';
part 'event.dart';
part 'state.dart';
part 'repository.dart';
