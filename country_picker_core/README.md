# country_picker_core

A core library for Flutter that provides a comprehensive, structured list of countries and their associated data. This
package is designed to be the foundational layer for building any country selection or data display UI, such as phone
number input fields, registration forms, or country lists.

It is a data-only package, containing no UI components, making it flexible and lightweight for various use cases.

## Features

- **Comprehensive Data**: A meticulously curated list of all countries with their common names, ISO codes (alpha-2 and
  alpha-3), and phone details.
- **Structured Models**: Clean and well-defined data models for `Country` and its nested `PhoneDetail`.
- **Static Helper Methods**: Provides easy-to-use static methods to quickly look up a country by its phone code, ISO
  code, or name.
- **Case-Insensitive Search**: All lookup methods perform case-insensitive comparisons for user-friendly searching.

## Getting started

This package is intended for use as a core library. Add the dependency to your `pubspec.yaml` file.

### From a Git Repository

```yaml
dependencies:
  country_picker_core:
    git:
      url: https://github.com/pintusingh28/flutter-packages
      path: country_picker_core
```

### From pub.dev

```yaml
dependencies:
  country_picker_core: ^0.0.1
```

## Usage

1. The `Country` Data Model
   The core of this package is the `Country` class, which holds all the relevant information for each country.

2. Accessing the Country List
   The entire list of countries is available as a global, static variable named `countryList`.

    ```dart
    import 'package:country_picker_core/country_picker_core.dart';
    
    void main() {
      // Get the full list of countries
      List<Country> allCountries = countryList;
      print('Total countries: ${allCountries.length}');
    
      // Print the first country's name
      if (allCountries.isNotEmpty) {
        print('First country: ${allCountries.first.name}');
      }
    }
    ```

3. Using the Helper Methods
   Use the `CountryPickerHelper` mixin to perform quick, case-insensitive lookups.

    ```dart
    import 'package:country_picker_core/country_picker_core.dart';
    
    void main() {
      // Find a country by its phone code
      Country? usCountry = CountryPickerHelper.getCountryByPhoneCode('+1');
      print('Country with phone code +1: ${usCountry?.name}');
      // Output: Country with phone code +1: United States
      
      // Find a country by its ISO3 code
      Country? indCountry = CountryPickerHelper.getCountryByIso3Code('IND');
      print('Country with ISO3 code IND: ${indCountry?.name}');
      // Output: Country with ISO3 code IND: India
      
      // Find a country by its ISO2 code
      Country? gbrCountry = CountryPickerHelper.getCountryByIsoCode('GB');
      print('Country with ISO2 code GB: ${gbrCountry?.name}');
      // Output: Country with ISO2 code GB: United Kingdom
      
      // Find a country by its name
      Country? canCountry = CountryPickerHelper.getCountryByName('Canada');
      print('Country with name Canada: ${canCountry?.isoCode}');
      // Output: Country with name Canada: CA
      
      // Handle cases where a country is not found
      Country? unknownCountry = CountryPickerHelper.getCountryByName('Atlantis');
      if (unknownCountry == null) {
      print('Country not found.');
      }
      // Output: Country not found.
    }
    ```

## Contributing

Contributions are welcome! If you find any data inaccuracies or have suggestions for improvements, please feel free
to open an issue or submit a pull request on the GitHub repository.

## License

This project is licensed under the Apache License. See the `LICENSE` file for details.