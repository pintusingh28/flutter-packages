/// Represents a country with its associated details.
///
/// Each country has a common name, ISO codes, phone details,
/// and localized names.
class Country {
  /// Creates a [Country] instance.
  ///
  /// All parameters are required.
  ///
  /// - [name]: The common name of the country (e.g., "United States").
  /// - [isoCode]: The 2-letter ISO 3166-1 alpha-2 code (e.g., "US").
  /// - [iso3Code]: The 3-letter ISO 3166-1 alpha-3 code (e.g., "USA").
  /// - [phoneDetail]: Details related to the country's phone numbering plan.
  /// - [translations]: A map of language codes to localized country names
  ///   (e.g., {"fr": "États-Unis"}).
  const Country({
    required this.name,
    required this.isoCode,
    required this.iso3Code,
    required this.phoneDetail,
    required this.translations,
  });

  /// Creates a [Country] instance from a JSON map.
  ///
  /// Expects the map to contain keys 'name', 'isoCode', 'iso3Code',
  /// 'phoneDetail' (which is a map for [PhoneDetail.fromJson]),
  /// and 'translations' (which is a map of String to String).
  factory Country.fromJson(Map<String, dynamic> map) {
    return Country(
      name: map['name'] as String,
      isoCode: map['isoCode'] as String,
      iso3Code: map['iso3Code'] as String,
      phoneDetail: PhoneDetail.fromJson(map['phoneDetail'] as Map<String, dynamic>),
      translations: Map<String, String>.from(map['translations'] as Map),
    );
  }

  /// The common name of the country (e.g., "United States").
  final String name;

  /// The 2-letter ISO 3166-1 alpha-2 code (e.g., "US").
  final String isoCode;

  /// The 3-letter ISO 3166-1 alpha-3 code (e.g., "USA").
  final String iso3Code;

  /// Details related to the country's phone numbering plan.
  /// See [PhoneDetail] for more information.
  final PhoneDetail phoneDetail;

  /// A map of language codes (e.g., "fr", "es") to localized country names.
  final Map<String, String> translations;

  /// Converts this [Country] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'iso3Code': iso3Code,
      'phoneDetail': phoneDetail.toJson(), // Assuming PhoneDetail has toJson
      'translations': translations,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Country &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              isoCode == other.isoCode &&
              iso3Code == other.iso3Code &&
              phoneDetail == other.phoneDetail &&
              // Consider deep equality for maps if necessary,
              // though for simple String maps, default equality might be fine.
              translations.toString() == other.translations.toString(); // Basic map comparison

  @override
  int get hashCode =>
      name.hashCode ^
      isoCode.hashCode ^
      iso3Code.hashCode ^
      phoneDetail.hashCode ^
      translations.hashCode;
}

/// Represents details of a country's phone numbering plan.
class PhoneDetail {
  /// Creates a [PhoneDetail] instance.
  ///
  /// All parameters are required.
  ///
  /// - [code]: The international direct dialing (IDD) code or country calling code (e.g., "+1").
  /// - [maxLength]: The typical maximum length of a national significant number.
  /// - [minLength]: The typical minimum length of a national significant number.
  const PhoneDetail({
    required this.code,
    required this.maxLength,
    required this.minLength,
  });

  /// Creates a [PhoneDetail] instance from a JSON map.
  ///
  /// Expects the map to contain keys 'code' (String),
  /// 'maxLength' (int), and 'minLength' (int).
  factory PhoneDetail.fromJson(Map<String, dynamic> map) {
    return PhoneDetail(
      code: map['code'] as String,
      maxLength: map['maxLength'] as int,
      minLength: map['minLength'] as int,
    );
  }

  /// The international direct dialing (IDD) code, also known as the country calling code (e.g., "+1", "44").
  final String code;

  /// The typical maximum length of a national significant number (excluding the country code).
  final int maxLength;

  /// The typical minimum length of a national significant number (excluding the country code).
  final int minLength;

  /// Converts this [PhoneDetail] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'maxLength': maxLength,
      'minLength': minLength,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PhoneDetail &&
              runtimeType == other.runtimeType &&
              code == other.code &&
              maxLength == other.maxLength &&
              minLength == other.minLength;

  @override
  int get hashCode => code.hashCode ^ maxLength.hashCode ^ minLength.hashCode;
}
