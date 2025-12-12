import 'package:flutter/material.dart';
import 'bottom_navigation_screen.dart';

/// Screen that asks the user to provide a PIN or a username.
///
/// Behavior:
/// - Shows two fields: PIN (obscured, numeric) and Username (text).
/// - User may provide either one. At least one is required to enable submit.
/// - Submit navigates to `BottomNavigationScreen`.
class CreateNewAccountScreen extends StatefulWidget {
  const CreateNewAccountScreen({super.key});

  @override
  State<CreateNewAccountScreen> createState() => _CreateNewAccountScreenState();
}

class _CreateNewAccountScreenState extends State<CreateNewAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool get _canSubmit {
    return _pinController.text.trim().isNotEmpty || _usernameController.text.trim().isNotEmpty;
  }

  bool get _pinsMatch {
    if (_pinController.text.isEmpty && _confirmPinController.text.isEmpty) return true;
    return _pinController.text == _confirmPinController.text;
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) {
      // show a small error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a PIN or a username')),
      );
      return;
    }

    if (_pinController.text.isNotEmpty && _pinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match')),
      );
      return;
    }

    // Here you would normally persist the PIN/username securely.
    // For now we navigate to the BottomNavigationScreen.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BottomNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1D15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
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
                  'Provide either a secure PIN or a username. You can use a PIN for quick biometric flows later.',
                  style: TextStyle(color: Color.fromRGBO(210, 180, 150, 0.9)),
                ),

                const SizedBox(height: 28),

                // PIN field
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'PIN',
                    labelStyle: const TextStyle(color: Color.fromRGBO(210, 180, 150, 0.9)),
                    hintText: 'Enter a 4-6 digit PIN',
                    hintStyle: const TextStyle(color: Color.fromRGBO(180, 160, 140, 0.7)),
                    filled: true,
                    fillColor: const Color.fromRGBO(0, 0, 0, 0.18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Confirm PIN field
                TextFormField(
                  controller: _confirmPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Confirm PIN',
                    labelStyle: const TextStyle(color: Color.fromRGBO(210, 180, 150, 0.9)),
                    hintText: 'Re-enter your PIN',
                    hintStyle: const TextStyle(color: Color.fromRGBO(180, 160, 140, 0.7)),
                    filled: true,
                    fillColor: const Color.fromRGBO(0, 0, 0, 0.18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Color.fromRGBO(210, 180, 150, 0.9)),
                    hintText: 'Enter a username',
                    hintStyle: const TextStyle(color: Color.fromRGBO(180, 160, 140, 0.7)),
                    filled: true,
                    fillColor: const Color.fromRGBO(0, 0, 0, 0.18),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 24),

                // Helper text
                Text(
                  'Note: Provide at least one of the above. You can change these later in Profile.',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _canSubmit ? _submit : null,
                    icon: const Icon(Icons.fingerprint, color: Colors.black),
                    label: const Text('Create Account', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _canSubmit ? const Color.fromRGBO(255, 122, 0, 1.0) : const Color.fromRGBO(120, 100, 80, 0.5),
                      shape: const StadiumBorder(),
                      elevation: 10,
                      shadowColor: const Color.fromRGBO(255, 122, 0, 0.35),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
