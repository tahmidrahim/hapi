// lib/services/utils/country_service.dart
import 'package:country_pickers/countries.dart'; // Contains the 'countryList' constant
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart'; // Contains CountryPickerUtils

class CountryService {
  // FIX: Access 'countryList' directly (it's a global constant, not inside Utils)
  static final List<Country> _allCountries = countryList;

  static List<Country> getAllCountries() {
    return _allCountries;
  }

  static Country? getCountryByCode(String isoCode) {
    if (isoCode.isEmpty) return null;
    try {
      return CountryPickerUtils.getCountryByIsoCode(isoCode);
    } catch (e) {
      return null;
    }
  }

  static List<Country> searchCountries(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _allCountries
        .where(
          (country) =>
              country.name.toLowerCase().contains(lowerQuery) ||
              country.isoCode.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  static List<Country> getPopularCountries() {
    final popularCodes = ['US', 'GB', 'IN', 'PK', 'BD', 'CN', 'JP', 'DE', 'FR'];
    return popularCodes
        .map((code) {
          try {
            return CountryPickerUtils.getCountryByIsoCode(code);
          } catch (e) {
            return null;
          }
        })
        .whereType<Country>()
        .toList();
  }
}
