import '../ahl_barrel.dart';
import 'package:flutter/material.dart';

T resolveForBreakPoint<T>(
  double screenWidth, {
  T? small,
  T? medium,
  T? large,
  T? extraLarge,
  T? huge,
  T? extraHuge,
  required T other,
}) {
  switch (screenWidth) {
    case < ScreenSizes.small:
      return small ?? other;

    case > ScreenSizes.small && < ScreenSizes.medium:
      return medium ?? other;

    case > ScreenSizes.medium && < ScreenSizes.large:
      return large ?? other;
    case > ScreenSizes.large && < ScreenSizes.extraLarge:
      return extraLarge ?? other;
    case > ScreenSizes.extraLarge && < ScreenSizes.huge:
      return huge ?? other;
    case > ScreenSizes.huge:
      return extraHuge ?? other;

    default:
      return other;
  }
}

TextStyle? resolveBodyTextThemeForBreakPoints(
    double constraints, BuildContext context) {
  return resolveForBreakPoint<TextStyle?>(
    constraints,
    small: Theme.of(context).textTheme.bodyMedium,
    medium: Theme.of(context).textTheme.bodyMedium,
    other: Theme.of(context).textTheme.bodyLarge,
  );
}

TextStyle? resolveTitleTextThemeForBreakPoints(
    double constraints, BuildContext context) {
  return resolveForBreakPoint<TextStyle?>(
    constraints,
    small: Theme.of(context).textTheme.titleSmall,
    medium: Theme.of(context).textTheme.titleMedium,
    other: Theme.of(context).textTheme.titleLarge,
  );
}


TextStyle? resolveHeadlineTextThemeForBreakPoints(
    double constraints, BuildContext context) {
  return resolveForBreakPoint<TextStyle?>(
    constraints,
    small: Theme.of(context).textTheme.headlineSmall,
    medium: Theme.of(context).textTheme.headlineMedium,
    other: Theme.of(context).textTheme.headlineLarge,
  );
}

TextStyle? resolveDisplayTextThemeForBreakPoints(
    double constraints, BuildContext context) {
  return resolveForBreakPoint<TextStyle?>(
    constraints,
    small: Theme.of(context).textTheme.displaySmall,
    medium: Theme.of(context).textTheme.displayMedium,
    other: Theme.of(context).textTheme.displayLarge,
  );
}

double resolveSeparatorSize(
  BuildContext context
){
  return resolveForBreakPoint<double>(
    MediaQuery.of(context).size.width,
    small: 45,
    medium: 45,
    other: 50,
  );
}