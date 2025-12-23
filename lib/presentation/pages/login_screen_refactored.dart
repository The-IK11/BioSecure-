import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets.dart';
import 'create_new_account_screen_refactored.dart';
import 'bottom_navigation_screen_refactored.dart';

/// Minimal Login Screen using Provider
class LoginScreenRefactored extends StatefulWidget {
  const LoginScreenRefactored({super.key});

  @override
  State<LoginScreenRefactored> createState() => _LoginScreenRefactoredState();
}

class _LoginScreenRefactoredState extends State<LoginScreenRefactored> {
  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  void _checkBiometric() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isBiometricEnabled) {
      final success = await authProvider.authenticateWithBiometric();
      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomNavigationScreenRefactored()),
        );
      }
    }
  }

  void _handleBiometricLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.authenticateWithBiometric();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavigationScreenRefactored()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const LoginBackground(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FingerprintCircle(size: 140, iconSize: 56),
                            const SizedBox(height: 26),
                            const Text(
                              'BioSecure',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unlock Smarter. Unlock Secure.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.75),
                                fontSize: 16,
                              ),
                            ),
                            if (authProvider.errorMessage != null) ...[
                              const SizedBox(height: 16),
                              ErrorCard(
                                message: authProvider.errorMessage!,
                                onDismiss: () => authProvider.clearError(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomElevatedButton(
                            label: 'Enable Biometric Login',
                            icon: Icons.fingerprint,
                            isLoading: authProvider.isLoading,
                            enabled: !authProvider.isBiometricEnabled,
                            onPressed: () => _handleBiometricLogin(context),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(139, 69, 19, 0.48),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Use PIN Instead',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CreateNewAccountScreenRefactored(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(139, 69, 19, 0.48),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
