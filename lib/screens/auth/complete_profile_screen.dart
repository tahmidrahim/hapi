// lib/screens/auth/complete_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hapi/providers/navigation_provider.dart';
import 'package:hapi/providers/user_provider.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  String? profileImageUrl;
  String selectedGender = '';
  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // final user = ref.read(userProvider);
    _nameController.text = "Alex";
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Complete your profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Profile Image with Edit Icon
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        user.photoUrl != null && user.photoUrl!.isNotEmpty
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null || user.photoUrl!.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DE9B6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Please choose your gender",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "Cannot modify after select gender",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // Gender Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _genderOption("Boy", Icons.face_retouching_natural),
                _genderOption("Girl", Icons.face_3),
              ],
            ),

            const SizedBox(height: 30),

            // Name Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person, color: Colors.black54),
                  hintText: "Enter your name",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            // Location Input
            _buildLocationTile(),

            const SizedBox(height: 50),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your name')),
                    );
                    return;
                  }
                  if (selectedGender.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your gender'),
                      ),
                    );
                    return;
                  }

                  // Update user with name and gender
                  final currentUser = ref.read(userProvider);
                  ref
                      .read(userProvider.notifier)
                      .updateUser(
                        name: _nameController.text,
                        gender: selectedGender,
                        id: currentUser.id,
                        email: currentUser.email,
                      );

                  ref.read(navigationProvider.notifier).goToHome();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DE9B6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

  Widget _genderOption(String label, IconData icon) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = label),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: isSelected
                ? const Color(0xFF1DE9B6).withOpacity(0.2)
                : Colors.grey[100],
            child: Icon(
              icon,
              size: 40,
              color: isSelected ? const Color(0xFF1DE9B6) : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.black : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on, color: Colors.black54),
          SizedBox(width: 12),
          Text("🇧🇩 ", style: TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              "Bangladesh",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}
