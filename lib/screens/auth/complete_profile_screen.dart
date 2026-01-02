// lib/screens/auth/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../../widgets/auth/gender_selection_card.dart';
import '../../services/firebase/auth_service.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  String? _selectedGender;
  Country? _selectedCountry;
  DateTime? _selectedDateOfBirth; // 1. Added State Variable
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete your profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gender Selection
                  Text(
                    'Please choose your gender',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cannot modify after select gender',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gender Options
                  Row(
                    children: [
                      Expanded(
                        child: GenderSelectionCard(
                          title: 'Boy',
                          icon: Icons.man,
                          isSelected: _selectedGender == 'male',
                          onTap: () => setState(() => _selectedGender = 'male'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GenderSelectionCard(
                          title: 'Girl',
                          icon: Icons.woman,
                          isSelected: _selectedGender == 'female',
                          onTap: () =>
                              setState(() => _selectedGender = 'female'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Name Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Added Date of Birth Field
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDateOfBirth == null
                                  ? 'Select date of birth'
                                  : '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: _selectedDateOfBirth != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Country Selection
                  GestureDetector(
                    onTap: () => _selectCountry(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedCountry?.name ?? 'Select country/region',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: _selectedCountry != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _saveProfile : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _selectCountry(BuildContext context) async {
    // Note: Assuming CountryPickerDialog is from a package or your widgets
    final country = await showDialog<Country>(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: const Text('Select your phone code'),
        onValuePicked: (Country value) {
          setState(() => _selectedCountry = value);
        },
        // If your dialog works with onValuePicked directly instead of returning,
        // you might not need the return value here.
        // Adjust based on your specific CountryPickerDialog implementation.
      ),
    );

    // Fallback if dialog returns value
    if (country != null) {
      setState(() => _selectedCountry = country);
    }
  }

  // 3. Helper to pick date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now()
          .subtract(const Duration(days: 365 * 18)), // Default ~18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  // 4. Updated Validation
  bool _canProceed() {
    return _selectedGender != null &&
        _nameController.text.trim().isNotEmpty &&
        _selectedCountry != null &&
        _selectedDateOfBirth != null; // Ensure Date is selected
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      // 5. Pass dateOfBirth to the service
      await AuthService.completeProfile(
        name: _nameController.text.trim(),
        gender: _selectedGender!,
        country: _selectedCountry!.isoCode,
        dateOfBirth: _selectedDateOfBirth!,
      );

      if (mounted) {
        Navigator.pushNamed(context, '/recommended-friends');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
