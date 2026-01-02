import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // REQUIRED

class CountryPickerScreen extends StatefulWidget {
  const CountryPickerScreen({super.key});

  @override
  State<CountryPickerScreen> createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _filteredCountries = _getAllCountries();
    _searchController.addListener(_filterCountries);
  }

  // Get all countries
  List<Country> _getAllCountries() {
    // You can use CountryPickerUtils.getCountryByIsoCode for specific ones,
    // or typically the package provides a list of all countries.
    // Here is your curated list logic:
    final countryCodes = [
      'IN',
      'US',
      'GB',
      'CA',
      'AU',
      'DE',
      'FR',
      'JP',
      'CN',
      'RU',
      'BR',
      'MX',
      'IT',
      'ES',
      'KR',
      'SA',
      'AE',
      'TR',
      'ID',
      'VN',
      'TH',
      'MY',
      'PH',
      'SG',
      'PK',
      'BD',
      'LK',
      'NP',
      'BT',
      'MV',
    ];

    return countryCodes
        .map((code) {
          try {
            return CountryPickerUtils.getCountryByIsoCode(code);
          } catch (e) {
            return null; // Handle invalid codes safely
          }
        })
        .where((country) => country != null)
        .cast<Country>()
        .toList();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredCountries = _getAllCountries();
      } else {
        _filteredCountries = _getAllCountries()
            .where(
              (country) =>
                  country.name.toLowerCase().contains(query) ||
                  country.isoCode.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Popular countries logic
    final popularCountryCodes = [
      'IN',
      'PK',
      'PH',
      'BD',
      'TR',
      'VN',
      'ET',
      'ZA'
    ];

    final popularCountries = popularCountryCodes
        .map((code) {
          try {
            return CountryPickerUtils.getCountryByIsoCode(code);
          } catch (e) {
            return null;
          }
        })
        .where((country) => country != null)
        .cast<Country>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select country/region',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // Popular Countries Wrap
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: popularCountries.map((country) {
                    return FilterChip(
                      label: Text(country.name),
                      selected: _selectedCountry?.isoCode == country.isoCode,
                      onSelected: (selected) => _selectCountry(country),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // All Countries List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = _selectedCountry?.isoCode == country.isoCode;

                return ListTile(
                  // This relies on the pubspec.yaml asset fix!
                  leading: CountryPickerUtils.getDefaultFlagImage(country),
                  title: Text(
                    country.name,
                    style: GoogleFonts.poppins(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => _selectCountry(country),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectCountry(Country country) {
    // FIXED: Use context.pop to return the value to the previous screen
    context.pop(country);
  }
}
