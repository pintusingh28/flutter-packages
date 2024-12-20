import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Simplifies svg icons usage in ui with inherited icon theme.
class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    this.size,
    this.color,
    this.matchTextDirection = false,
    this.applyTextScaling,
    this.package,
    super.key,
  });

  final String icon;
  final double? size;
  final Color? color;
  final bool matchTextDirection;
  final bool? applyTextScaling;
  final String? package;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconTheme = IconTheme.of(context);

    Color effectiveColor = color ?? iconTheme.color ?? colorScheme.onSurface;
    double effectiveSize = size ?? iconTheme.size ?? 24;
    if (applyTextScaling ?? iconTheme.applyTextScaling ?? false) {
      effectiveSize = MediaQuery.textScalerOf(context).scale(effectiveSize);
    }

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
