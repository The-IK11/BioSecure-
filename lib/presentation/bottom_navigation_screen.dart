import 'package:flutter/material.dart';

/// BottomNavigationScreen - matches the provided design screenshot.
///
/// - Welcome header with fingerprint circle
/// - Welcome title and subtitle
/// - Biometric status card (icon + label + status)
/// - Support text
/// - Large orange "Authenticate Now" button
/// - Bottom navigation bar with Home, Settings, Profile
class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  void _onTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF2A1D15),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 18),

              // fingerprint circle
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(139, 69, 19, 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.fingerprint,
                    color: Color.fromRGBO(255, 122, 0, 1.0),
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Title
              const Text(
                'Welcome to BioSecure',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Secure access at your fingertips.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(210, 180, 150, 0.9),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // Biometric status card
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.14),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.03)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.35),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Row(
                  children: [
                    // circular icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 0, 0, 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield, // approximate shield icon
                          color: Color.fromRGBO(255, 122, 0, 1.0),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Biometric Status',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Enabled',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 122, 0, 1.0),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Your device supports fingerprint & face\nunlock.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const Spacer(),

              // Authenticate Now button
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: trigger authentication flow
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 122, 0, 1.0),
                    shape: const StadiumBorder(),
                    elevation: 12,
                    shadowColor: const Color.fromRGBO(255, 122, 0, 0.45),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Authenticate Now', style: TextStyle(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),

      // bottom navigation (custom styled to match screenshot)
      bottomNavigationBar: Container(
        color: const Color(0xFF2A1D15),
        child: SafeArea(
          child: SizedBox(
            height: 78,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  label: 'Home',
                  icon: Icons.home,
                  isActive: _currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  label: 'Settings',
                  icon: Icons.settings,
                  isActive: _currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  label: 'Profile',
                  icon: Icons.person,
                  isActive: _currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color.fromRGBO(255, 122, 0, 1.0);
    final inactiveColor = const Color.fromRGBO(210, 180, 150, 0.7);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
