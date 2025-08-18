# country_picker_assets

A companion package for Flutter that provides a comprehensive collection of country flag assets.

This package is designed to be the asset-only dependency for other country picker UI libraries. It contains all the
necessary flag images, ensuring that the main UI packages remain lightweight and focused on functionality.

This package should be used in conjunction with a UI component that leverages its assets, such as a country picker
widget.

## Getting started

To use the flag assets in your project, add `country_picker_assets` to your `pubspec.yaml` file.

### From a Git Repository

```yaml
dependencies:
  country_picker_assets:
    git:
      url: https://github.com/pintusingh28/flutter-packages
      path: country_picker_assets
```

### From pub.dev

```yaml
dependencies:
  country_picker_assets: [ latest-version ]
```

## Usage

This package provides a bundle of flag images that are designed to be loaded by a UI component. You should not need to
directly reference the assets in your application code unless you are building your own UI.

The flags are organized by their two-letter ISO 3166-1 alpha-2 code in lowercase, in PNG format.

For example, to display the flag for the United States, the asset path is assets/us.png.

A typical UI library would use Image.asset with the package parameter to load the images correctly:

```dart
// Example using a hypothetical UI package's helper method
// This is how the assets are used under the hood.

import 'package:flutter/material.dart';

Widget displayUsFlag() {
  return Image.asset(
    'assets/us.png',
    package: 'country_picker_assets',
    width: 24,
    height: 24,
  );
}
```

## Supported Flags

This package includes flag images for all countries listed in the `country_picker_core` data library.

## Contributing

Contributions are welcome! If you find any missing flags or issues with existing ones, please open an issue or submit a
pull request to the GitHub repository.

## License

This project is licensed under the BSD 3-Clause License. See the `LICENSE` file for details.