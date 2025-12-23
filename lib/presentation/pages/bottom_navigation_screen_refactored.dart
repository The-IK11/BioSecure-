import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_widgets.dart';
import '../pages_without_statemanagement/login_screen.dart';

/// Minimal Bottom Navigation Screen using Provider
class BottomNavigationScreenRefactored extends StatefulWidget {
  const BottomNavigationScreenRefactored({super.key});

  @override
  State<BottomNavigationScreenRefactored> createState() =>
      _BottomNavigationScreenRefactoredState();
}

class _BottomNavigationScreenRefactoredState
    extends State<BottomNavigationScreenRefactored> {
  int _selectedIndex = 0;

  void _handleLogout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _handleDisableBiometric(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.disableBiometric();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric login disabled')),
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
            backgroundColor: const Color(0xFF1A0E08),
            elevation: 0,
            title: const Text(
              'BioSecure',
              style: TextStyle(
                color: Color.fromRGBO(255, 122, 0, 1.0),
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),
          body: _buildBody(_selectedIndex, authProvider),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            backgroundColor: const Color(0xFF1A0E08),
            selectedItemColor: const Color.fromRGBO(255, 122, 0, 1.0),
            unselectedItemColor: const Color.fromRGBO(210, 180, 150, 0.6),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(int index, AuthProvider authProvider) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                FingerprintCircle(size: 100, iconSize: 50),
                const SizedBox(height: 40),
                const Text(
                  'Welcome!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Logged in as: ${authProvider.currentUser ?? "User"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(210, 180, 150, 0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                StatusCard(
                  title: 'Biometric Status',
                  value: authProvider.isBiometricEnabled ? 'Enabled ✓' : 'Disabled',
                  bgColor: authProvider.isBiometricEnabled
                      ? const Color.fromRGBO(76, 175, 80, 0.2)
                      : const Color.fromRGBO(244, 67, 54, 0.2),
                ),
                const SizedBox(height: 24),
                SuccessCard(message: 'You are securely authenticated!'),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      case 1:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 32),
                SettingItem(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: authProvider.isBiometricEnabled ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: authProvider.isBiometricEnabled,
                    onChanged: (_) => _handleDisableBiometric(context),
                    activeColor: const Color.fromRGBO(255, 122, 0, 1.0),
                  ),
                ),
                const SizedBox(height: 24),
                SettingItem(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Manage your security settings',
                ),
                const SizedBox(height: 24),
                SettingItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage notifications',
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      case 2:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                ProfileHeader(username: authProvider.currentUser ?? 'User'),
                const SizedBox(height: 48),
                ProfileStats(),
                const SizedBox(height: 48),
                CustomElevatedButton(
                  label: 'Logout',
                  onPressed: () => _handleLogout(context),
                  icon: Icons.logout,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
