Provides adaptive layout sizes for creating responsive design

## Getting started

Add package dependency in your project:
```yaml
dependencies:
  adaptive_layout:
    git:
      url: https://github.com/pintusingh28/flutter-packages
      path: adaptive_layout
```

## Usage

Wrap your app with `AdaptiveLayout` widget.
```dart
runApp(
  AdaptiveLayout.fromView(
    child: MyApp(),
  ),
);
```

```dart
// retrieve layout data
final layoutData = AdaptiveLayout.of(context);

// retrieve layout type
final layoutType = AdaptiveLayout.layoutTypeOf(context);
```