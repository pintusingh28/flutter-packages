import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays an SVG asset as an icon, providing similar theming
/// capabilities to Flutter's built-in [Icon] widget.
///
/// This widget uses `flutter_svg` to render SVG files from your asset bundle.
/// It automatically applies color and size based on the nearest [IconTheme],
/// similar to how [Icon] widgets behave. It also respects text scaling settings.
///
/// Example:
/// To use this widget, ensure you have added `flutter_svg` to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   flutter_svg: ^2.0.0 # Use the latest version
/// ```
///
/// And include your SVG assets in your `pubspec.yaml`:
/// ```yaml
/// flutter:
///   assets:
///     - assets/icons/my_icon.svg
/// ```
///
/// Then, in your code:
/// ```dart
/// class MyWidget extends StatelessWidget {
///   const MyWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         // Basic usage
///         const SvgIcon('assets/icons/home.svg', size: 32, color: Colors.blue),
///         const SizedBox(height: 16),
///         // Using IconTheme for consistent styling
///         IconTheme(
///           data: const IconThemeData(color: Colors.green, size: 48),
///           child: const SvgIcon('assets/icons/settings.svg'),
///         ),
///         const SizedBox(height: 16),
///         // Icon from a specific package
///         // SvgIcon('icons/star.svg', package: 'my_icon_package'),
///       ],
///     );
///   }
/// }
/// ```
class SvgIcon extends StatelessWidget {
  /// Creates an [SvgIcon] widget.
  ///
  /// The [icon] argument must be a valid asset path to an SVG file.
  const SvgIcon(
    this.icon, {
    this.size,
    this.color,
    this.matchTextDirection = false,
    this.applyTextScaling,
    this.package,
    super.key,
  });

  /// The path to the SVG asset to display.
  ///
  /// This should be a path relative to your `pubspec.yaml` `assets` section.
  final String icon;

  /// The size of the icon in logical pixels.
  ///
  /// If null, the size is inherited from the nearest [IconTheme].
  /// If no [IconTheme] is found, it defaults to 24.0.
  final double? size;

  /// The color to use when painting the icon.
  ///
  /// If null, the color is inherited from the nearest [IconTheme].
  /// If no [IconTheme] is found, it defaults to `Theme.of(context).colorScheme.onSurface`.
  final Color? color;

  /// Whether to mirror the icon horizontally when the `TextDirection` is
  /// [TextDirection.rtl] (right-to-left).
  ///
  /// Defaults to `false`.
  final bool matchTextDirection;

  /// Whether to apply the current text scale factor to the icon's size.
  ///
  /// If null, it inherits from the nearest [IconTheme]'s `applyTextScaling`
  /// property. If neither is set, it defaults to `false`.
  final bool? applyTextScaling;

  /// The name of the package from which to load the icon.
  ///
  /// This is used when the icon asset is part of a package rather than the
  /// main application.
  final String? package;

  @override
  Widget build(BuildContext context) {
    // Get the current theme's color scheme.
    final colorScheme = Theme.of(context).colorScheme;
    // Get the nearest IconTheme data.
    final iconTheme = IconTheme.of(context);

    // Determine the effective color:
    // 1. Use the provided `color` if not null.
    // 2. Fallback to `iconTheme.color` if available.
    // 3. Fallback to `colorScheme.onSurface` as a default.
    Color effectiveColor = color ?? iconTheme.color ?? colorScheme.onSurface;

    // Determine the effective size:
    // 1. Use the provided `size` if not null.
    // 2. Fallback to `iconTheme.size` if available.
    // 3. Fallback to 24.0 as a default.
    double effectiveSize = size ?? iconTheme.size ?? 24;

    // Apply text scaling if enabled:
    // 1. Check `applyTextScaling` property of this widget.
    // 2. Fallback to `iconTheme.applyTextScaling`.
    // 3. Default to `false`.
    if (applyTextScaling ?? iconTheme.applyTextScaling ?? false) {
      effectiveSize = MediaQuery.textScalerOf(context).scale(effectiveSize);
    }

    // Return the SvgPicture.asset widget with calculated properties.
    return SvgPicture.asset(
      icon,
      fit: BoxFit.contain,
      theme: SvgTheme(currentColor: effectiveColor),
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      width: effectiveSize,
      height: effectiveSize,
      matchTextDirection: matchTextDirection,
      package: package,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('icon', icon));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<bool>('matchTextDirection', matchTextDirection, defaultValue: false));
    properties.add(DiagnosticsProperty<bool?>('applyTextScaling', applyTextScaling, defaultValue: false));
    properties.add(StringProperty('package', package));
  }
}
