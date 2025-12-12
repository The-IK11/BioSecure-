import 'package:flutter/material.dart';
import 'package:bio_secure/presentation/bottom_navigation_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  final FocusNode _confirmPinFocus = FocusNode();
  final _authStorage= FlutterSecureStorage();
  final LocalAuthentication localAuthentication=LocalAuthentication();
 
  bool _showPinError = false;
  bool _showConfirmPinError = false;
  String _errorMessage = '';

  bool _isLoading = false;
 static const   String _biometricEnabledKey='biometric_enabled';
 static const   String _biometricPinKey='biometric_pin';

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocus.dispose();
    _confirmPinFocus.dispose();
    super.dispose();
  }

  void _handleSubmit()async {
    setState(() {
      _showPinError = _pinController.text.isEmpty;
      _showConfirmPinError = _confirmPinController.text.isEmpty;
      _errorMessage = '';

    });

    if (_showPinError || _showConfirmPinError) {
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        _errorMessage = 'PINs do not match. Please try again.';
      });
      return;
    }

    if (_pinController.text.length < 4) {
      setState(() {
        _errorMessage = 'PIN must be at least 4 digits.';
      });
      return;
    }
 //await _authStorage.write(key:_biometricEnabledKey , value: 'true');
 ///await _authStorage.write(key:_biometricPinKey , value: _pinController.text);
    // Show loading state
    setState(() => _isLoading = true);

    // Simulate biometric setup delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Navigate to BottomNavigationScreen on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ),
        );
      }
    });
  }
///Biometric funtionality 
///Check Biometric Environment on device 
Future<bool> checkBiometricSupport() async {
  try{
    final isAvailable=await localAuthentication.canCheckBiometrics;
    final isDeviceSupported=await localAuthentication.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }
  catch(e){
    return false;
}
}
//Biometric Authentication function

Future<void> _authenticateUser() async {

bool isAvailable=await checkBiometricSupport();
if(!isAvailable){
  setState(() {
    _errorMessage='Biometric authentication is not available on this device.';
  });
  try{
    final bool didAuthenticate=await localAuthentication.authenticate(
      localizedReason: 'Please authenticate to enable biometric login',
      biometricOnly: true
      
    );

      if (didAuthenticate) {
        setState(() {
          _errorMessage = "Unlocked Successfully ✔";
        });
      } else {
        setState(() {
          _errorMessage = "Failed 😢 — Try Again";
        });
      }
  }
  catch(e){
    setState(() {
      _errorMessage='An error occurred during biometric authentication.';
    });
  }
}}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1D15),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Header
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

                // Thumb icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromRGBO(139, 69, 19, 0.6),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Color.fromRGBO(255, 122, 0, 1.0),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // First PIN Input
                _buildPinInputField(
                  controller: _pinController,
                  focusNode: _pinFocus,
                  label: 'Enter PIN',
                  hasError: _showPinError,
                  onFieldSubmitted: (_) => _confirmPinFocus.requestFocus(),
                ),

                const SizedBox(height: 24),

                // Confirm PIN Input
                _buildPinInputField(
                  controller: _confirmPinController,
                  focusNode: _confirmPinFocus,
                  label: 'Confirm PIN',
                  hasError: _showConfirmPinError,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),

                const SizedBox(height: 20),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 0, 0, 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 0, 0, 0.3),
                      ),
                    ),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 100, 100, 1.0),
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 48),

                // Submit button with finger icon
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 122, 0, 1.0),
                      shape: const CircleBorder(),
                      elevation: 12,
                      shadowColor: const Color.fromRGBO(255, 122, 0, 0.5),
                      disabledBackgroundColor: const Color.fromRGBO(255, 122, 0, 0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 3,
                            ),
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
  }

  Widget _buildPinInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool hasError,
    required Function(String) onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 8,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: hasError
              ? const Color.fromRGBO(255, 100, 100, 0.8)
              : const Color.fromRGBO(210, 180, 150, 0.7),
        ),
        hintStyle: const TextStyle(
          color: Color.fromRGBO(210, 180, 150, 0.5),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(0, 0, 0, 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(210, 180, 150, 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(255, 122, 0, 0.7),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError
                ? const Color.fromRGBO(255, 0, 0, 0.3)
                : const Color.fromRGBO(210, 180, 150, 0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromRGBO(255, 0, 0, 0.5),
          ),
        ),
        counterText: '',
        suffixIcon: hasError
            ? const Icon(
                Icons.error_outline,
                color: Color.fromRGBO(255, 100, 100, 0.8),
              )
            : null,
      ),
    );
  }
}
