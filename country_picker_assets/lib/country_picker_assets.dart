// Copyright (c) 2025 Pintu Singh
//
// This file is part of country_picker_assets.
//
// Licensed under the BSD 3-Clause License.
// See the LICENSE file in the project root for details.

import 'package:flutter/material.dart';

/// A mixin that provides static helper methods for retrieving flag assets.
///
/// This mixin is designed to work with a separate Flutter package
/// named `country_picker_assets` which should contain all the flag images.
/// The methods here abstract the asset path logic, ensuring that flags are
/// loaded correctly from the asset bundle of the companion package.
///
/// **Usage:**
/// To use this mixin, the `country_picker_assets` package must be added to your
/// project's `pubspec.yaml` file. The flags are assumed to be in the format
/// `assets/[iso_code].png` (e.g., `assets/us.png`, `assets/in.png`).
///
/// Example:
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:country_picker_assets/country_picker_assets.dart';
///
/// class MyFlagWidget extends StatelessWidget {
///   const MyFlagWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // Get the image path for the US flag
///     final String usFlagPath = CountryPickerAssets.getFlagImageAssetPath('US');
///
///     // Display the US flag using the helper widget
///     return CountryPickerAssets.getDefaultFlagImage(
///       'US',
///       width: 48,
///       height: 48,
///     );
///   }
/// }
/// ```
mixin CountryPickerAssets {
  /// Returns the asset path for a flag image based on its ISO2 country code.
  ///
  /// The path is constructed to point to an asset within the `country_picker_assets`
  /// package's asset bundle. The ISO code is converted to lowercase.
  ///
  /// Parameters:
  /// - `isoCode`: The two-letter ISO 3166-1 alpha-2 code of the country
  /// (e.g., 'US', 'IN').
  ///
  /// Returns:
  /// - A [String] representing the full asset path, such as `"assets/us.png"`.
  static String getFlagImageAssetPath(String isoCode) =>
      "assets/${isoCode.toLowerCase()}.png";

  /// Returns a [Widget] that displays a country's flag image.
  ///
  /// This is a convenience method that creates an `Image.asset` widget,
  /// automatically handling the asset path construction and specifying the
  /// `package` to load the image from the correct asset bundle.
  ///
  /// Parameters:
  /// - `isoCode`: The two-letter ISO 3166-1 alpha-2 code of the country.
  /// - `width`: The desired width of the flag image. Defaults to 24.0.
  /// - `height`: The desired height of the flag image. Defaults to 24.0.
  ///
  /// Returns:
  /// - An `Image.asset` widget configured to display the flag.
  static Image getDefaultFlagImage(
    String isoCode, {
    double width = 24.0,
    double height = 24.0,
  }) {
    return Image.asset(
      getFlagImageAssetPath(isoCode),
      height: height,
      width: width,
      fit: BoxFit.cover,
      package: "country_picker_assets",
    );
  }
}
