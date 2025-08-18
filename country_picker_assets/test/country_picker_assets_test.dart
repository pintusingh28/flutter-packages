import 'package:country_picker_assets/country_picker_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getFlagImageAssetPath', () {
    test('should return the correct asset path for a valid ISO code', () {
      final path = CountryPickerAssets.getFlagImageAssetPath('US');
      expect(path, 'assets/us.png');
    });

    test('should return a lowercase path regardless of input casing', () {
      final path = CountryPickerAssets.getFlagImageAssetPath('In');
      expect(path, 'assets/in.png');
    });

    test('should return a valid path string for an empty input', () {
      final path = CountryPickerAssets.getFlagImageAssetPath('');
      expect(path, 'assets/.png');
    });
  });

  group('getDefaultFlagImage', () {
    testWidgets('should return a valid Image widget with default properties', (
      WidgetTester tester,
    ) async {
      final imageWidget = CountryPickerAssets.getDefaultFlagImage('DE');

      // We don't need to pump the widget for this test, we can directly
      // inspect its properties.
      expect(imageWidget, isA<Image>());

      // Verify the image provider and asset path.
      final imageProvider = imageWidget.image as AssetImage;
      expect(imageProvider, isA<AssetImage>());
      expect(imageProvider.assetName, 'assets/de.png');
      expect(imageProvider.package, 'country_picker_assets');

      // Verify default dimensions.
      expect(imageWidget.width, 24.0);
      expect(imageWidget.height, 24.0);
    });

    testWidgets('should return an Image widget with custom dimensions', (
      WidgetTester tester,
    ) async {
      const customWidth = 50.0;
      const customHeight = 30.0;

      final imageWidget = CountryPickerAssets.getDefaultFlagImage(
        'JP',
        width: customWidth,
        height: customHeight,
      );

      // Verify custom dimensions.
      expect(imageWidget.width, customWidth);
      expect(imageWidget.height, customHeight);

      // Verify other properties remain correct.
      final imageProvider = imageWidget.image as AssetImage;
      expect(imageProvider.assetName, 'assets/jp.png');
      expect(imageProvider.package, 'country_picker_assets');
    });

    testWidgets('should return a valid Image widget for an empty ISO code', (
      WidgetTester tester,
    ) async {
      final imageWidget = CountryPickerAssets.getDefaultFlagImage('');

      // Verify the image provider and asset path for empty input.
      final imageProvider = imageWidget.image as AssetImage;
      expect(imageProvider, isA<AssetImage>());
      expect(imageProvider.assetName, 'assets/.png');
      expect(imageProvider.package, 'country_picker_assets');
    });
  });
}
