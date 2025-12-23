import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages_without_statemanagement/login_screen.dart';

/// Minimal Splash Screen with animations
class SplashScreenRefactored extends StatefulWidget {
  const SplashScreenRefactored({super.key});

  @override
  State<SplashScreenRefactored> createState() => _SplashScreenRefactoredState();
}

class _SplashScreenRefactoredState extends State<SplashScreenRefactored>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Initialize auth provider
        context.read<AuthProvider>().initializeAuth().then((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B160A),
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
          _buildLoadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B160A), Color(0xFF1A0E08)],
        ),
      ),
      child: Stack(
        children: [
          // Top glow
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.1,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color.fromRGBO(255, 122, 0, 0.1),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          // Bottom glow
          Positioned(
            bottom: -size.width * 0.3,
            right: -size.width * 0.15,
            child: Container(
              width: size.width * 1.0,
              height: size.width * 1.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color.fromRGBO(139, 69, 19, 0.15),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fingerprint circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 122, 0, 0.3),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(255, 122, 0, 0.15),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 80,
                        color: Color.fromRGBO(255, 122, 0, 0.95),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'BioSecure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unlock Smarter. Unlock Secure.',
                      style: TextStyle(
                        color: Color.fromRGBO(210, 180, 150, 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(255, 122, 0, 0.7),
            ),
            strokeWidth: 3,
            backgroundColor: const Color.fromRGBO(255, 122, 0, 0.2),
          ),
        ),
      ),
    );
  }
}
