import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'breakpoints.dart';
import 'layout_type.dart';

const _kSpacing = 8;

/// Specifies a part of [AdaptiveLayoutData] to depend on.
///
/// [AdaptiveLayout] contains a large number of related properties. Widgets frequently depend on only a few of these
/// attributes. For example, a widget that needs to rebuild when the [AdaptiveLayoutData.margin] changes does not need
/// to be notified when the [AdaptiveLayoutData.spacing] changes. Specifying an aspect avoids unnecessary rebuilds.
enum _AdaptiveLayoutAspect {
  /// Specifies the aspect corresponding to [AdaptiveLayoutData.layoutType].
  type,

  /// Specifies the aspect corresponding to [AdaptiveLayoutData.margin].
  margin,

  /// Specifies the aspect corresponding to [AdaptiveLayoutData.padding].
  padding,

  /// Specifies the aspect corresponding to [AdaptiveLayoutData.spacing].
  spacing;
}

/// Information about a layout of view.
///
/// For example, the [AdaptiveLayoutData.layoutType] property contains the type of layout for the current window.
///
/// To obtain individual attributes in a [AdaptiveLayoutData], prefer to use the attribute-specific functions of
/// [AdaptiveLayout] over obtaining the entire [AdaptiveLayoutData] and accessing its members.
///
/// To obtain the entire current [AdaptiveLayoutData] for a given [BuildContext], use the [AdaptiveLayout.of] function.
/// This can be useful if you are going to use [copyWith] to replace the [AdaptiveLayoutData] with one with an updated
/// property.
@immutable
class AdaptiveLayoutData {
  /// Creates data for a adaptive layout with explicit values.
  ///
  /// In a typical application, calling this constructor directly is rarely needed. Consider using
  /// [AdaptiveLayoutData.fromView] to create data based on a [dart:ui.FlutterView], or [AdaptiveLayoutData.copyWith]
  /// to create a new copy of [AdaptiveLayoutData] with updated properties from a base [AdaptiveLayoutData].
  const AdaptiveLayoutData({
    required this.layoutType,
    required this.margin,
    required this.padding,
    required this.spacing,
  });

  /// Creates data for a [AdaptiveLayout] based on the given `view`.
  ///
  /// Callers of this method should ensure that they also register for notifications so that the [AdaptiveLayoutData]
  /// can be updated when any data used to construct it changes. Notifications to consider are:
  ///
  ///  * [WidgetsBindingObserver.didChangeMetrics] or [dart:ui.PlatformDispatcher.onMetricsChanged],
  ///
  /// In general, [AdaptiveLayout.of], and its associated "...Of" methods, are the appropriate way to obtain
  /// [AdaptiveLayoutData] from a widget. This `fromView` constructor is primarily for use in the implementation of the
  /// framework itself.
  ///
  /// See also:
  ///
  ///  * [AdaptiveLayout.fromView], which constructs [AdaptiveLayoutData] from a provided [FlutterView], makes it
  ///    available to descendant widgets, and sets up the appropriate notification listeners to keep the data updated.
  factory AdaptiveLayoutData.fromView(ui.FlutterView view) {
    final size = view.physicalSize / view.devicePixelRatio;
    final padding = EdgeInsets.fromViewPadding(view.padding, view.devicePixelRatio);
    final double availableWidth = size.width - padding.horizontal;

    return switch (availableWidth) {
      < AdaptiveLayoutBreakpoints.compat => const AdaptiveLayoutData(
          layoutType: AdaptiveLayoutType.compact,
          margin: _kSpacing * 2,
          padding: _kSpacing * 2,
          spacing: _kSpacing * 2,
        ),
      < AdaptiveLayoutBreakpoints.medium => const AdaptiveLayoutData(
          layoutType: AdaptiveLayoutType.medium,
          margin: _kSpacing * 3,
          padding: _kSpacing * 3,
          spacing: _kSpacing * 3,
        ),
      < AdaptiveLayoutBreakpoints.expanded => const AdaptiveLayoutData(
          layoutType: AdaptiveLayoutType.expanded,
          margin: _kSpacing * 3,
          padding: _kSpacing * 3,
          spacing: _kSpacing * 3,
        ),
      < AdaptiveLayoutBreakpoints.large => const AdaptiveLayoutData(
          layoutType: AdaptiveLayoutType.large,
          margin: _kSpacing * 4,
          padding: _kSpacing * 3,
          spacing: _kSpacing * 3,
        ),
      _ => const AdaptiveLayoutData(
          layoutType: AdaptiveLayoutType.extraLarge,
          margin: _kSpacing * 4,
          padding: _kSpacing * 3,
          spacing: _kSpacing * 3,
        )
    };
  }

  /// The current layout type of the current window.
  ///
  /// See also:
  ///
  ///  * [AdaptiveLayout.layoutTypeOf], a method to find and depend on the type defined for a [BuildContext].
  final AdaptiveLayoutType layoutType;

  /// The parts of the window which should be left blank for spacing.
  ///
  /// See also:
  ///
  ///  * [AdaptiveLayout.marginOf], a method to find and depend on the margin defined for a [BuildContext].
  final double margin;

  /// The recommended padding for widgets.
  ///
  /// See also:
  ///
  ///  * [AdaptiveLayout.paddingOf], a method to find and depend on the margin defined for a [BuildContext].
  final double padding;

  /// The recommended space between two widgets horizontally & vertically.
  ///
  /// See also:
  ///
  ///  * [AdaptiveLayout.spacingOf], a method to find and depend on the spacing defined for a [BuildContext].
  final double spacing;

  /// Creates a copy of this adaptive layout data but with the given fields replaced with the new values.
  AdaptiveLayoutData copyWith({
    AdaptiveLayoutType? type,
    double? margin,
    double? padding,
    double? spacing,
  }) {
    return AdaptiveLayoutData(
      layoutType: type ?? layoutType,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AdaptiveLayoutData &&
        other.layoutType == layoutType &&
        other.margin == margin &&
        other.padding == padding &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hashAll([
        layoutType,
        margin,
        padding,
        spacing,
      ]);

  @override
  String toString() {
    final List<String> properties = <String>[
      'type: $layoutType',
      'margin: $margin',
      'padding: $padding',
      'gutter: $spacing',
    ];
    return '${objectRuntimeType(this, 'AdaptiveLayoutData')}(${properties.join(', ')})';
  }
}

/// Establishes a subtree in which layout data resolve to the given data.
///
/// For example, to learn the layout type of the current view (e.g., the [FlutterView] containing your app), you can
/// use [AdaptiveLayout.layoutTypeOf]: `AdaptiveLayout.layoutTypeOf(context)`.
///
/// Querying the current layout data using specific methods (for example, [AdaptiveLayout.layoutTypeOf] or
/// [AdaptiveLayout.marginOf]) will cause your widget to rebuild automatically whenever that specific property changes.
///
/// Querying using [AdaptiveLayout.of] will cause your widget to rebuild automatically whenever _any_ field of the
/// [AdaptiveLayoutData] changes (e.g., if the user rotates their device). Therefore, unless you are concerned with the
/// entire [AdaptiveLayoutData] object changing, prefer using the specific methods (for example:
/// [AdaptiveLayout.layoutTypeOf] and [AdaptiveLayout.marginOf]), as it will rebuild more efficiently.
///
/// If no [AdaptiveLayout] is in scope then [AdaptiveLayout.of] and the "...Of" methods similar to
/// [AdaptiveLayout.layoutTypeOf] will throw an exception. Alternatively, the "maybe-" variant methods (such as
/// [AdaptiveLayout.maybeOf] and [AdaptiveLayout.layoutTypeOf]) can be used, which return null, instead of throwing, when
/// no [AdaptiveLayout] is in scope.
///
/// See also:
///
///  * [AdaptiveLayoutData], the data structure that represents the layout data.
class AdaptiveLayout extends InheritedModel<_AdaptiveLayoutAspect> {
  const AdaptiveLayout({
    super.key,
    required super.child,
    required this.data,
  });

  /// Contains information about the current layout.
  ///
  /// For example, the [AdaptiveLayoutData.layoutType] property contains the current layout of the current window.
  final AdaptiveLayoutData data;

  /// Wraps the [child] in a [AdaptiveLayout] which is built using data from view.
  ///
  /// The injected [AdaptiveLayout] automatically updates when any of the data used to construct it changes.
  static Widget fromView({
    Key? key,
    required Widget child,
  }) {
    return _AdaptiveLayoutFromView(
      key: key,
      child: child,
    );
  }

  /// The data from the closest instance of this class that encloses the given context.
  ///
  /// You can use this function to query the entire set of data held in the current [AdaptiveLayoutData] object. When
  /// any of that information changes, your widget will be scheduled to be rebuilt, keeping your widget up-to-date.
  ///
  /// Since it is typical that the widget only requires a subset of properties of the [AdaptiveLayoutData] object,
  /// prefer using the more specific methods (for example: [AdaptiveLayout.layoutTypeOf] and [AdaptiveLayout.marginOf]),
  /// as those methods will not cause a widget to rebuild when unrelated properties are updated.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// AdaptiveLayoutData data = AdaptiveLayout.of(context);
  /// ```
  ///
  /// If there is no [AdaptiveLayout] in scope, this method will throw a [TypeError] exception in release builds, and
  /// throw a descriptive [FlutterError] in debug builds.
  ///
  /// See also:
  ///
  /// * [maybeOf], which doesn't throw or assert if it doesn't find a [AdaptiveLayout] ancestor. It returns null
  ///   instead.
  /// * [layoutTypeOf] and other specific methods for retrieving and depending on changes of a specific value.
  static AdaptiveLayoutData of(BuildContext context) {
    return _of(context);
  }

  static AdaptiveLayoutData _of(
    BuildContext context, [
    _AdaptiveLayoutAspect? aspect,
  ]) {
    assert(() {
      if (context.widget is! AdaptiveLayout &&
          context.getElementForInheritedWidgetOfExactType<AdaptiveLayout>() == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('No AdaptiveLayout widget ancestor found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require a AdaptiveLayout widget ancestor.',
          ),
          context.describeWidget(
            'The specific widget that could not find a AdaptiveLayout ancestor was',
          ),
          context.describeOwnershipChain(
            'The ownership chain for the affected widget is',
          ),
          ErrorHint('No AdaptiveLayout ancestor could be found starting from the context '
              'that was passed to AdaptiveLayout.of(). This can happen because the '
              'context used is not a descendant of a AdaptiveLayoutProvider widget, which introduces '
              'a AdaptiveLayout.'),
        ]);
      }
      return true;
    }());
    return InheritedModel.inheritFrom<AdaptiveLayout>(context, aspect: aspect)!.data;
  }

  /// The data from the closest instance of this class that encloses the given context, if any.
  ///
  /// Use this function if you want to allow situations where no [AdaptiveLayout] is in scope. Prefer using
  /// [AdaptiveLayout.of] in situations where a adaptive layout is always expected to exist.
  ///
  /// If there is no [AdaptiveLayout] in scope, then this function will return null.
  ///
  /// You can use this function to query the entire set of data held in the current [AdaptiveLayoutData] object. When
  /// any of that information changes, your widget will be scheduled to be rebuilt, keeping your widget up-to-date.
  ///
  /// Since it is typical that the widget only requires a subset of properties of the [AdaptiveLayoutData] object,
  /// prefer using the more specific methods (for example: [AdaptiveLayout.maybeLayoutTypeOf] and
  /// [AdaptiveLayout.maybeMarginOf]), as those methods will not cause a widget to rebuild when unrelated properties
  /// are updated.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// AdaptiveLayoutData? adaptiveLayoutData = AdaptiveLayout.maybeOf(context);
  /// if (adaptiveLayoutData == null) {
  ///   // Do something else instead.
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * [of], which will throw if it doesn't find a [AdaptiveLayout] ancestor, instead of returning null.
  /// * [maybeLayoutTypeOf] and other specific methods for retrieving and depending on changes of a specific value.
  static AdaptiveLayoutData? maybeOf(BuildContext context) {
    return _maybeOf(context);
  }

  static AdaptiveLayoutData? _maybeOf(
    BuildContext context, [
    _AdaptiveLayoutAspect? aspect,
  ]) {
    return InheritedModel.inheritFrom<AdaptiveLayout>(context, aspect: aspect)?.data;
  }

  /// Returns [AdaptiveLayoutData.layoutType] for the nearest [AdaptiveLayoutData] ancestor or throws an exception, if
  /// no such ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.layoutType]
  /// property of the ancestor [AdaptiveLayout] changes.
  static AdaptiveLayoutType layoutTypeOf(BuildContext context) {
    return _of(context, _AdaptiveLayoutAspect.type).layoutType;
  }

  /// Returns [AdaptiveLayoutData.layoutType] for the nearest [AdaptiveLayoutData] ancestor or null, if no such
  /// ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.layoutType]
  /// property of the ancestor [AdaptiveLayout] changes.
  static AdaptiveLayoutType? maybeLayoutTypeOf(BuildContext context) {
    return _maybeOf(context, _AdaptiveLayoutAspect.type)?.layoutType;
  }

  /// Returns [AdaptiveLayoutData.margin] for the nearest [AdaptiveLayoutData] ancestor or throws an exception, if no
  /// such ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.margin]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double marginOf(BuildContext context) {
    return _of(context, _AdaptiveLayoutAspect.margin).margin;
  }

  /// Returns [AdaptiveLayoutData.margin] for the nearest [AdaptiveLayoutData] ancestor or null, if no such ancestor
  /// exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.margin]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double? maybeMarginOf(BuildContext context) {
    return _maybeOf(context, _AdaptiveLayoutAspect.margin)?.margin;
  }

  /// Returns [AdaptiveLayoutData.padding] for the nearest [AdaptiveLayoutData] ancestor or throws an exception, if no
  /// such ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.padding]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double paddingOf(BuildContext context) {
    return _of(context, _AdaptiveLayoutAspect.padding).padding;
  }

  /// Returns [AdaptiveLayoutData.margin] for the nearest [AdaptiveLayoutData] ancestor or null, if no such ancestor
  /// exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.padding]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double? maybePaddingOf(BuildContext context) {
    return _maybeOf(context, _AdaptiveLayoutAspect.padding)?.padding;
  }

  /// Returns [AdaptiveLayoutData.spacing] for the nearest [AdaptiveLayoutData] ancestor or throws an exception, if no
  /// such ancestor exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.spacing]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double spacingOf(BuildContext context) {
    return _of(context, _AdaptiveLayoutAspect.spacing).spacing;
  }

  /// Returns [AdaptiveLayoutData.spacing] for the nearest [AdaptiveLayoutData] ancestor or null, if no such ancestor
  /// exists.
  ///
  /// Use of this method will cause the given [context] to rebuild any time that the [AdaptiveLayoutData.spacing]
  /// property of the ancestor [AdaptiveLayout] changes.
  static double? maybeSpacingOf(BuildContext context) {
    return _maybeOf(context, _AdaptiveLayoutAspect.spacing)?.spacing;
  }

  @override
  bool updateShouldNotify(AdaptiveLayout oldWidget) => data != oldWidget.data;

  @override
  bool updateShouldNotifyDependent(
    AdaptiveLayout oldWidget,
    Set<Object> dependencies,
  ) {
    return dependencies.any((dependency) {
      return dependency is _AdaptiveLayoutAspect &&
          switch (dependency) {
            _AdaptiveLayoutAspect.type => data.layoutType != oldWidget.data.layoutType,
            _AdaptiveLayoutAspect.margin => data.margin != oldWidget.data.margin,
            _AdaptiveLayoutAspect.padding => data.padding != oldWidget.data.padding,
            _AdaptiveLayoutAspect.spacing => data.spacing != oldWidget.data.spacing,
          };
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<AdaptiveLayoutData>('data', data, showName: false),
    );
  }
}

class _AdaptiveLayoutFromView extends StatefulWidget {
  const _AdaptiveLayoutFromView({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<_AdaptiveLayoutFromView> createState() => _AdaptiveLayoutFromViewState();
}

class _AdaptiveLayoutFromViewState extends State<_AdaptiveLayoutFromView> with WidgetsBindingObserver {
  AdaptiveLayoutData? _data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final view = View.of(context);
    _updateData(view);
    assert(_data != null);
  }

  @override
  void didChangeMetrics() {
    final view = View.of(context);
    _updateData(view);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _updateData(ui.FlutterView view) {
    final AdaptiveLayoutData newData = AdaptiveLayoutData.fromView(view);
    if (newData != _data) {
      setState(() {
        _data = newData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      data: _data!,
      child: widget.child,
    );
  }
}
