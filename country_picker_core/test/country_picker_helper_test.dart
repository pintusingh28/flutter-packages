import 'package:country_picker_core/country_picker_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getCountryByPhoneCode', () {
    test('should return a country for a valid phone code', () {
      final result = CountryPickerHelper.getCountryByPhoneCode('1');
      expect(result, isNotNull);
      expect(result?.name, 'Canada');
    });

    test('should return a country for a phone code with different casing', () {
      final result = CountryPickerHelper.getCountryByPhoneCode('91');
      expect(result, isNotNull);
      expect(result?.name, 'India');
    });

    test('should return null for an invalid phone code', () {
      final result = CountryPickerHelper.getCountryByPhoneCode('999');
      expect(result, isNull);
    });

    test('should return null for an empty phone code', () {
      final result = CountryPickerHelper.getCountryByPhoneCode('');
      expect(result, isNull);
    });
  });

  group('getCountryByIso3Code', () {
    test('should return a country for a valid ISO3 code', () {
      final result = CountryPickerHelper.getCountryByIso3Code('IND');
      expect(result, isNotNull);
      expect(result?.name, 'India');
    });

    test('should return a country for a lowercase ISO3 code', () {
      final result = CountryPickerHelper.getCountryByIso3Code('ind');
      expect(result, isNotNull);
      expect(result?.name, 'India');
    });

    test('should return null for an invalid ISO3 code', () {
      final result = CountryPickerHelper.getCountryByIso3Code('XYZ');
      expect(result, isNull);
    });

    test('should return null for an empty ISO3 code', () {
      final result = CountryPickerHelper.getCountryByIso3Code('');
      expect(result, isNull);
    });
  });

  group('getCountryByIsoCode', () {
    test('should return a country for a valid ISO code', () {
      final result = CountryPickerHelper.getCountryByIsoCode('US');
      expect(result, isNotNull);
      expect(result?.name, 'United States of America');
    });

    test('should return a country for a lowercase ISO code', () {
      final result = CountryPickerHelper.getCountryByIsoCode('us');
      expect(result, isNotNull);
      expect(result?.name, 'United States of America');
    });

    test('should return null for an invalid ISO code', () {
      final result = CountryPickerHelper.getCountryByIsoCode('ZZ');
      expect(result, isNull);
    });

    test('should return null for an empty ISO code', () {
      final result = CountryPickerHelper.getCountryByIsoCode('');
      expect(result, isNull);
    });
  });

  group('getCountryByName', () {
    test('should return a country for a valid name', () {
      final result = CountryPickerHelper.getCountryByName('Germany');
      expect(result, isNotNull);
      expect(result?.isoCode, 'DE');
    });

    test('should return a country for a name with different casing', () {
      final result = CountryPickerHelper.getCountryByName('india');
      expect(result, isNotNull);
      expect(result?.isoCode, 'IN');
    });

    test('should return null for an invalid name', () {
      final result = CountryPickerHelper.getCountryByName('Neverland');
      expect(result, isNull);
    });

    test('should return null for an empty name', () {
      final result = CountryPickerHelper.getCountryByName('');
      expect(result, isNull);
    });
  });
}
