import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/auth/social_login_button.dart';
import '../../services/firebase/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // App Logo/Title
              Center(
                child: Column(
                  children: [
                    Text(
                      'Kapi',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Hapi',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Divider with Text
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or log in with',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 40),

              // Facebook Login Button
              SocialLoginButton(
                icon: Icons.facebook,
                text: 'Facebook',
                color: const Color(0xFF1877F2),
                onPressed: () => _loginWithFacebook(context, ref),
              ),

              const SizedBox(height: 16),

              // Google Login Button
              SocialLoginButton(
                icon: Icons.g_mobiledata,
                text: 'Google',
                color: Colors.white,
                textColor: Colors.black,
                border: Border.all(color: Colors.grey[300]!),
                onPressed: () => _loginWithGoogle(context, ref),
              ),

              const SizedBox(height: 40),

              // Terms & Privacy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    children: [
                      const TextSpan(text: 'Log in means you agree to '),
                      TextSpan(
                        text: 'Terms of Service, ',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginWithFacebook(BuildContext context, WidgetRef ref) async {
    try {
      await AuthService.signInWithFacebook();
      // Navigate to complete profile
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/complete-profile');
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Facebook login failed: $e')));
    }
  }

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    try {
      await AuthService.signInWithGoogle();
      // Navigate to complete profile
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/complete-profile');
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Google login failed: $e')));
    }
  }
}
