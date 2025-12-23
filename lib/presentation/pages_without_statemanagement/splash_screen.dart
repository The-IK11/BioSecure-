import 'package:bio_secure/presentation/pages_without_statemanagement/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations for splash screen entrance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Simulate app initialization and navigate after splash
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF2B160A),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2B160A), Color(0xFF1A0E08)],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // Decorative radial glows
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

          // Main content
          SafeArea(
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Thumb/Fingerprint image container with glow
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
                                // Outer glow
                                BoxShadow(
                                  color: Color.fromRGBO(255, 122, 0, 0.15),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                                // Outer shadow
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.fingerprint,
                                size: 80,
                                color: Color.fromRGBO(255, 122, 0, 0.95),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // App name
                          const Text(
                            'BioSecure',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Tagline
                          const Text(
                            'Unlock Smarter. Unlock Secure.',
                            style: TextStyle(
                              color: Color.fromRGBO(210, 180, 150, 0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Loading indicator at bottom
          Positioned(
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
          ),
        ],
      ),
    );
  }
}
