import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'biometric_setup_screen.dart';

/// Screen that asks the user to provide a PIN and a username.
///
/// Behavior:
/// - Shows two fields: Username (text) and PIN (obscured, numeric).
/// - Both are required to enable submit.
/// - Submit navigates to `BiometricSetupScreen`.
class CreateNewAccountScreen extends StatefulWidget {
  const CreateNewAccountScreen({super.key});

  @override
  State<CreateNewAccountScreen> createState() => _CreateNewAccountScreenState();
}

class _CreateNewAccountScreenState extends State<CreateNewAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool get _canSubmit {
    return _pinController.text.trim().isNotEmpty && _usernameController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _pinController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_canSubmit) {
      // show a small error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both username and PIN')),
      );
      return;
    }

    // Save PIN and username to secure storage
    const storage = FlutterSecureStorage();
    
    try {
      await storage.write(key: 'user_pin', value: _pinController.text);
      await storage.write(key: 'username', value: _usernameController.text);

      // Navigate to BiometricSetupScreen after successful save
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BiometricSetupScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }
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
        child: SingleChildScrollView(
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
                    'Create a secure PIN and username to protect your biometric login.',
                    style: TextStyle(color: Color.fromRGBO(210, 180, 150, 0.9)),
                  ),
          
                  const SizedBox(height: 28),
           
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
             
                  const SizedBox(height: 16),
                  
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
          
                  const SizedBox(height: 24),
          
                  // Helper text
                  Text(
                    'Note: Provide both username and PIN. You can change these later in Profile.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
          
                  const SizedBox(height: 50),
                  
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
      ),
    );
  }
}
