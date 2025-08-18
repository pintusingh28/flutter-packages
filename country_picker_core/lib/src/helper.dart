import 'country_list.dart';
import 'country_model.dart';

/// A utility mixin that provides static helper methods to retrieve a [Country]
/// object from a predefined list of countries based on various identifiers.
///
/// This mixin is useful for lookups in country pickers or other UI components
/// that need to find country data from a phone code, ISO code, or name.
/// The underlying country data is assumed to be provided by `country_list.dart`.
mixin CountryPickerHelper {
  /// Retrieves a [Country] object from the list by its phone country code.
  ///
  /// The search is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// final country = CountryPickerHelper.getCountryByPhoneCode('91');
  /// // Returns the Country object for India
  /// ```
  ///
  /// - Parameters:
  ///   - `phoneCode`: The phone dialing code (e.g., '91').
  ///
  /// - Returns:
  ///   - The [Country] object corresponding to the `phoneCode`, or `null`
  ///   if not found.
  static Country? getCountryByPhoneCode(String phoneCode) {
    try {
      return countryList.firstWhere((country) =>
          country.phoneDetail.code.toLowerCase() == phoneCode.toLowerCase());
    } catch (error) {
      return null;
    }
  }

  /// Retrieves a [Country] object from the list by its ISO 3166-1 alpha-3 code.
  ///
  /// The search is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// final country = CountryPickerHelper.getCountryByIso3Code('IND');
  /// // Returns the Country object for India
  /// ```
  ///
  /// - Parameters:
  ///   - `iso3Code`: The three-letter ISO code (e.g., 'IND').
  ///
  /// - Returns:
  ///   - The [Country] object corresponding to the `iso3Code`, or `null`
  ///   if not found.
  static Country? getCountryByIso3Code(String iso3Code) {
    try {
      return countryList.firstWhere((country) =>
          country.iso3Code.toLowerCase() == iso3Code.toLowerCase());
    } catch (error) {
      return null;
    }
  }

  /// Retrieves a [Country] object from the list by its ISO 3166-1 alpha-2 code.
  ///
  /// The search is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// final country = CountryPickerHelper.getCountryByIsoCode('IN');
  /// // Returns the Country object for India
  /// ```
  ///
  /// - Parameters:
  ///   - `isoCode`: The two-letter ISO code (e.g., 'IN').
  ///
  /// - Returns:
  ///   - The [Country] object corresponding to the `isoCode`, or `null`
  ///   if not found.
  static Country? getCountryByIsoCode(String isoCode) {
    try {
      return countryList.firstWhere(
          (country) => country.isoCode.toLowerCase() == isoCode.toLowerCase());
    } catch (error) {
      return null;
    }
  }

  /// Retrieves a [Country] object from the list by its official name.
  ///
  /// The search is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// final country = CountryPickerHelper.getCountryByName('India');
  /// // Returns the Country object for India
  /// ```
  ///
  /// - Parameters:
  ///   - `name`: The name of the country (e.g., 'India').
  ///
  /// - Returns:
  ///   - The [Country] object corresponding to the `name`, or `null`
  ///   if not found.
  static Country? getCountryByName(String name) {
    try {
      return countryList.firstWhere(
          (country) => country.name.toLowerCase() == name.toLowerCase());
    } catch (error) {
      return null;
    }
  }
}
