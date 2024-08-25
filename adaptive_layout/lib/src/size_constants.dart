import 'package:flutter/widgets.dart';

abstract interface class Spacing {
  static const double none = 0;

  static const double xSmall = 4;

  static const double small = 8;

  static const double medium = 12;

  static const double normal = 16;

  static const double large = 20;

  static const double xLarge = 24;

  static const double xxLarge = 32;

  static const double xxxLarge = 40;
}

abstract interface class ShapeCornerRadius {
  static const Radius none = Radius.zero;

  static const Radius extraSmall = Radius.circular(4);

  static const Radius small = Radius.circular(8);

  static const Radius medium = Radius.circular(12);

  static const Radius normal = Radius.circular(16);

  static const Radius large = Radius.circular(20);

  static const Radius extraLarge = Radius.circular(24);
}

abstract interface class ShapeBorderRadius {
  static const BorderRadius none = BorderRadius.zero;

  static const BorderRadius extraSmall = BorderRadius.all(ShapeCornerRadius.extraSmall);

  static const BorderRadius small = BorderRadius.all(ShapeCornerRadius.small);

  static const BorderRadius medium = BorderRadius.all(ShapeCornerRadius.medium);

  static const BorderRadius normal = BorderRadius.all(ShapeCornerRadius.normal);

  static const BorderRadius large = BorderRadius.all(ShapeCornerRadius.large);

  static const BorderRadius extraLarge = BorderRadius.all(ShapeCornerRadius.extraLarge);
}

abstract interface class Shapes {
  static const OutlinedBorder none = RoundedRectangleBorder();

  static const OutlinedBorder extraSmall = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.extraSmall,
  );

  static const OutlinedBorder small = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.small,
  );

  static const OutlinedBorder medium = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.medium,
  );

  static const OutlinedBorder normal = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.normal,
  );

  static const OutlinedBorder large = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.large,
  );

  static const OutlinedBorder extraLarge = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.extraLarge,
  );

  static const OutlinedBorder full = StadiumBorder();
}
