import 'package:flutter/widgets.dart';

/// Defines a set of standard spacing values to maintain visual consistency
/// throughout an application.
///
/// These values are typically used for padding, margins, and gaps between widgets.
/// Using a predefined set of spacing values helps in creating a harmonious
/// and predictable layout.
///
/// Example Usage:
/// ```dart
/// Column(
///   children: [
///     Container(color: Colors.blue, height: 50, width: 50),
///     const SizedBox(height: Spacing.normal), // Use normal spacing
///     Container(color: Colors.red, height: 50, width: 50),
///     Padding(
///       padding: const EdgeInsets.all(Spacing.medium), // Use medium padding
///       child: Text('Padded Text'),
///     ),
///   ],
/// );
/// ```
abstract interface class Spacing {
  /// No spacing (0 logical pixels).
  static const double none = 0;

  /// Extra small spacing (4 logical pixels).
  static const double xSmall = 4;

  /// Small spacing (8 logical pixels).
  static const double small = 8;

  /// Medium spacing (12 logical pixels).
  static const double medium = 12;

  /// Normal spacing (16 logical pixels).
  static const double normal = 16;

  /// Large spacing (20 logical pixels).
  static const double large = 20;

  /// Extra large spacing (24 logical pixels).
  static const double xLarge = 24;

  /// Double extra large spacing (32 logical pixels).
  static const double xxLarge = 32;

  /// Triple extra large spacing (40 logical pixels).
  static const double xxxLarge = 40;
}

/// Defines a set of standard corner radii for consistent rounded corners
/// across an application's UI elements.
///
/// These values are typically used with [BorderRadius] to create various
/// levels of roundedness for containers, cards, buttons, etc.
///
/// Example Usage:
/// ```dart
/// Container(
///   width: 100,
///   height: 100,
///   decoration: BoxDecoration(
///     color: Colors.lightBlue,
///     borderRadius: BorderRadius.all(ShapeCornerRadius.normal), // Apply normal corner radius
///   ),
/// );
/// ```
abstract interface class ShapeCornerRadius {
  /// No corner radius (0 logical pixels).
  static const Radius none = Radius.zero;

  /// Extra small corner radius (4 logical pixels).
  static const Radius extraSmall = Radius.circular(4);

  /// Small corner radius (8 logical pixels).
  static const Radius small = Radius.circular(8);

  /// Medium corner radius (12 logical pixels).
  static const Radius medium = Radius.circular(12);

  /// Normal corner radius (16 logical pixels).
  static const Radius normal = Radius.circular(16);

  /// Large corner radius (20 logical pixels).
  static const Radius large = Radius.circular(20);

  /// Extra large corner radius (24 logical pixels).
  static const Radius extraLarge = Radius.circular(24);
}

/// Defines a set of standard [BorderRadius] values, derived from
/// [ShapeCornerRadius], for consistent rounded borders across an application.
///
/// These values simplify applying uniform rounded corners to widgets that
/// accept a [BorderRadius] property, such as [Container] or [Card].
///
/// Example Usage:
/// ```dart
/// Card(
///   shape: RoundedRectangleBorder(
///     borderRadius: ShapeBorderRadius.medium, // Apply medium border radius
///   ),
///   child: const SizedBox(
///     width: 150,
///     height: 100,
///     child: Center(child: Text('Rounded Card')),
///   ),
/// );
/// ```
abstract interface class ShapeBorderRadius {
  /// No border radius (square corners).
  static const BorderRadius none = BorderRadius.zero;

  /// Extra small border radius, applied to all corners.
  static const BorderRadius extraSmall = BorderRadius.all(ShapeCornerRadius.extraSmall);

  /// Small border radius, applied to all corners.
  static const BorderRadius small = BorderRadius.all(ShapeCornerRadius.small);

  /// Medium border radius, applied to all corners.
  static const BorderRadius medium = BorderRadius.all(ShapeCornerRadius.medium);

  /// Normal border radius, applied to all corners.
  static const BorderRadius normal = BorderRadius.all(ShapeCornerRadius.normal);

  /// Large border radius, applied to all corners.
  static const BorderRadius large = BorderRadius.all(ShapeCornerRadius.large);

  /// Extra large border radius, applied to all corners.
  static const BorderRadius extraLarge = BorderRadius.all(ShapeCornerRadius.extraLarge);
}

/// Defines a set of standard [OutlinedBorder] shapes, primarily
/// [RoundedRectangleBorder] with various corner radii, and a [StadiumBorder].
///
/// These shapes can be used to provide consistent visual styling for widgets
/// that accept a `shape` property, such as [Card], [ButtonTheme], or [Material].
///
/// Example Usage:
/// ```dart
/// ElevatedButton(
///   style: ElevatedButton.styleFrom(
///     shape: Shapes.full, // Use a stadium (pill) shape for the button
///     padding: const EdgeInsets.symmetric(horizontal: Spacing.normal, vertical: Spacing.small),
///   ),
///   onPressed: () {},
///   child: const Text('Full Shape Button'),
/// );
///
/// Card(
///   shape: Shapes.normal, // Use a normal rounded rectangle shape for the card
///   child: const SizedBox(
///     width: 200,
///     height: 100,
///     child: Center(child: Text('Normal Rounded Card')),
///   ),
/// );
/// ```
abstract interface class Shapes {
  /// No border shape (a simple rectangle).
  static const OutlinedBorder none = RoundedRectangleBorder();

  /// A rounded rectangle border with an extra small corner radius.
  static const OutlinedBorder extraSmall = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.extraSmall,
  );

  /// A rounded rectangle border with a small corner radius.
  static const OutlinedBorder small = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.small,
  );

  /// A rounded rectangle border with a medium corner radius.
  static const OutlinedBorder medium = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.medium,
  );

  /// A rounded rectangle border with a normal corner radius.
  static const OutlinedBorder normal = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.normal,
  );

  /// A rounded rectangle border with a large corner radius.
  static const OutlinedBorder large = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.large,
  );

  /// A rounded rectangle border with an extra large corner radius.
  static const OutlinedBorder extraLarge = RoundedRectangleBorder(
    borderRadius: ShapeBorderRadius.extraLarge,
  );

  /// A [StadiumBorder], which is a horizontally stretched oval (pill shape).
  static const OutlinedBorder full = StadiumBorder();
}
