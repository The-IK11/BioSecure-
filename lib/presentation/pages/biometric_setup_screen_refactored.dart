import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets.dart';
import 'bottom_navigation_screen_refactored.dart';

/// Minimal Biometric Setup Screen using Provider
class BiometricSetupScreenRefactored extends StatefulWidget {
  const BiometricSetupScreenRefactored({super.key});

  @override
  State<BiometricSetupScreenRefactored> createState() =>
      _BiometricSetupScreenRefactoredState();
}

class _BiometricSetupScreenRefactoredState
    extends State<BiometricSetupScreenRefactored> {
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  bool _showUsernameError = false;
  bool _showPinError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    setState(() {
      _showUsernameError = _usernameController.text.isEmpty;
      _showPinError = _pinController.text.isEmpty;
    });

    if (_showUsernameError || _showPinError) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.setupBiometric(
      _usernameController.text,
      _pinController.text,
    );

    if (authProvider.isAuthenticated && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric login enabled successfully!'),
          duration: Duration(seconds: 1),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const BottomNavigationScreenRefactored(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF2A1D15),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Set Up Biometric Lock',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Create a secure PIN to protect your biometric login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(210, 180, 150, 0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const FingerprintCircle(),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hasError: _showUsernameError,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _pinController,
                      label: 'Enter PIN',
                      hasError: _showPinError,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),
                    const SizedBox(height: 20),
                    if (authProvider.errorMessage != null)
                      ErrorCard(
                        message: authProvider.errorMessage!,
                        onDismiss: () => authProvider.clearError(),
                      ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () => _handleSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 122, 0, 1.0),
                          shape: const CircleBorder(),
                          elevation: 12,
                          shadowColor:
                              const Color.fromRGBO(255, 122, 0, 0.5),
                          disabledBackgroundColor:
                              const Color.fromRGBO(255, 122, 0, 0.5),
                        ),
                        child: authProvider.isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                                strokeWidth: 3,
                              )
                            : const Icon(
                                Icons.fingerprint,
                                size: 56,
                                color: Colors.black,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tap the fingerprint to confirm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(210, 180, 150, 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
