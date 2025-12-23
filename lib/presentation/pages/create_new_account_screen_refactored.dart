import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets.dart';
import 'biometric_setup_screen_refactored.dart';

/// Minimal Create Account Screen using Provider
class CreateNewAccountScreenRefactored extends StatefulWidget {
  const CreateNewAccountScreenRefactored({super.key});

  @override
  State<CreateNewAccountScreenRefactored> createState() =>
      _CreateNewAccountScreenRefactoredState();
}

class _CreateNewAccountScreenRefactoredState
    extends State<CreateNewAccountScreenRefactored> {
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
    if (_pinController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN must be at least 4 digits')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.createAccount(
      _usernameController.text,
      _pinController.text,
    );

    if (authProvider.state == AuthState.unauthenticated && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BiometricSetupScreenRefactored(),
        ),
      );
    } else if (authProvider.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${authProvider.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF2A1D15),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Create Account'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Set up your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create a secure PIN and username to protect your biometric login.',
                      style: TextStyle(
                        color: Color.fromRGBO(210, 180, 150, 0.9),
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hint: 'Enter a username',
                      hasError: _showUsernameError,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _pinController,
                      label: 'PIN',
                      hint: 'Enter a 4-6 digit PIN',
                      obscureText: true,
                      hasError: _showPinError,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Note: Provide both username and PIN. You can change these later in Profile.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    if (authProvider.errorMessage != null)
                      ErrorCard(
                        message: authProvider.errorMessage!,
                        onDismiss: () => authProvider.clearError(),
                      ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      label: 'Create Account',
                      icon: Icons.fingerprint,
                      isLoading: authProvider.isLoading,
                      enabled: _usernameController.text.isNotEmpty &&
                          _pinController.text.isNotEmpty,
                      onPressed: () => _handleSubmit(context),
                    ),
                    const SizedBox(height: 12),
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
