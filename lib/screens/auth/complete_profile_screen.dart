// lib/screens/auth/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  // Country? _selectedCountry; // Not needed for now
  DateTime? _selectedDateOfBirth;
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

                  // Date of Birth Field
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

                  // ========== COUNTRY SECTION COMMENTED OUT START ==========
                  /*
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
                  */
                  // ========== COUNTRY SECTION COMMENTED OUT END ==========

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

  // ========== COUNTRY LOGIC COMMENTED OUT START ==========
  /*
  Future<void> _selectCountry(BuildContext context) async {
    final country = await showDialog<Country>(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: const InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: const Text('Select your country'),
        onValuePicked: (Country value) {
          Navigator.pop(context, value);
        },
      ),
    );

    if (country != null) {
      setState(() => _selectedCountry = country);
    }
  }
  */
  // ========== COUNTRY LOGIC COMMENTED OUT END ==========

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  bool _canProceed() {
    return _selectedGender != null &&
        _nameController.text.trim().isNotEmpty &&
        // _selectedCountry != null && // DISABLED VALIDATION
        _selectedDateOfBirth != null;
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.completeProfile(
        name: _nameController.text.trim(),
        gender: _selectedGender!,
        // Pass a default value since the user can't select one
        country: 'BD',
        dateOfBirth: _selectedDateOfBirth!,
      );

      if (mounted) {
        context.go('/recommended-friends');
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
