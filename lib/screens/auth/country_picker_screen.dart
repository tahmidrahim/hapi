import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Get all countries using available method
    _filteredCountries = _getAllCountries();
    _searchController.addListener(_filterCountries);
  }

  // Get all countries using the available methods
  List<Country> _getAllCountries() {
    final countryCodes = [
      'IN', 'US', 'GB', 'CA', 'AU', 'DE', 'FR', 'JP', 'CN', 'RU',
      'BR', 'MX', 'IT', 'ES', 'KR', 'SA', 'AE', 'TR', 'ID', 'VN',
      'TH', 'MY', 'PH', 'SG', 'PK', 'BD', 'LK', 'NP', 'BT', 'MV',
      // Add more country codes as needed
    ];

    return countryCodes
        .map((code) => CountryPickerUtils.getCountryByIsoCode(code))
        // ignore: unnecessary_null_comparison
        .where((country) => country != null)
        .map((country) => country)
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
    final popularCountryCodes = [
      'IN', // India
      'PK', // Pakistan
      'PH', // Philippines
      'BD', // Bangladesh
      'TR', // Turkey
      'VN', // Vietnam
      'ET', // Ethiopia
      'ZA', // South Africa
    ];

    final popularCountries = popularCountryCodes
        .map((code) => CountryPickerUtils.getCountryByIsoCode(code))
        // ignore: unnecessary_null_comparison
        .where((country) => country != null)
        .map((country) => country)
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

          // Popular Countries
          Padding(
            padding: const EdgeInsets.all(16),
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

          // All Countries List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = _selectedCountry?.isoCode == country.isoCode;

                return ListTile(
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
    Navigator.pop(context, country);
  }
}
