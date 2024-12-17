import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    required this.value,
    required this.onChanged,
    this.thumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? thumbColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('value', value));
    properties.add(ObjectFlagProperty<ValueChanged<bool>?>.has('onChanged', onChanged));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(ColorProperty('activeTrackColor', activeTrackColor));
    properties.add(ColorProperty('inactiveTrackColor', inactiveTrackColor));
  }
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  bool _value = false;
  bool _interacting = false;

  static const double _trackWidth = 40;
  static const double _trackInnerLength = 32;
  static const double _trackHeight = 24;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller = AnimationController(
      vsync: this,
      value: _value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final textDirection = Directionality.of(context);
    _alignmentAnimation = AlignmentTween(
      begin: AlignmentDirectional.centerStart.resolve(textDirection),
      end: AlignmentDirectional.centerEnd.resolve(textDirection),
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _value) {
      _value = widget.value;
      _animateToValue();
    }
  }

  void _animateToValue() {
    _controller.animateTo(_value ? 1.0 : 0.0);
  }

  void _onValueChanged(bool value) {
    widget.onChanged?.call(value);
    // _animateToValue();
    // _value = value;
  }

  void _onTap() {
    _onValueChanged(!_value);
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      _interacting = true;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta ?? 0 / _trackInnerLength;
    _controller.value += delta;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    bool value = _controller.value > 0.5;
    _onValueChanged(value);
    setState(() {
      _interacting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color thumbColor = widget.thumbColor ?? theme.colorScheme.onPrimary;
    Color activeTrackColor = widget.activeTrackColor ?? theme.colorScheme.primary;
    Color inactiveTrackColor = widget.inactiveTrackColor ?? theme.disabledColor;

    if (widget.onChanged == null) {
      activeTrackColor = Color.alphaBlend(activeTrackColor.withValues(alpha: 0.4), theme.colorScheme.surface);
      inactiveTrackColor = Color.alphaBlend(inactiveTrackColor.withValues(alpha: 0.4), theme.colorScheme.surface);
    }

    Widget child = SizedBox(
      height: _trackHeight,
      width: _trackWidth,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Material(
          color: ColorTween(begin: inactiveTrackColor, end: activeTrackColor).evaluate(_controller),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_trackHeight / 2)),
          clipBehavior: Clip.none,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: child,
          ),
        ),
        child: AlignTransition(
          alignment: _alignmentAnimation,
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _interacting ? _SwitchThumbSplashPainter(color: thumbColor, splashRadius: 16) : null,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: _interacting ? 0.8 : 1,
                child: Material(
                  type: MaterialType.circle,
                  color: thumbColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.onChanged == null) {
      return child;
    }

    return GestureDetector(
      onTap: _onTap,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: child,
    );
  }
}

class _SwitchThumbSplashPainter extends CustomPainter {
  _SwitchThumbSplashPainter({
    required this.color,
    required this.splashRadius,
  });

  final Color color;
  final double splashRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final splashPainter = Paint()..color = color.withValues(alpha: 0.25);
    canvas.drawCircle(center, splashRadius, splashPainter);
  }

  @override
  bool shouldRepaint(covariant _SwitchThumbSplashPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.splashRadius != splashRadius;
}
