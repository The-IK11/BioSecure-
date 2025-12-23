import 'package:flutter/material.dart';

/// Custom text input field widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final bool hasError;
  final String? errorText;
  final Widget? suffixIcon;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.focusNode,
    this.onFieldSubmitted,
    this.hasError = false,
    this.errorText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Custom elevated button with orange theme
class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final double height;
  final IconData? icon;

  const CustomElevatedButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.height = 60,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        onPressed: (enabled && !isLoading) ? onPressed : null,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Icon(icon ?? Icons.check, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? const Color.fromRGBO(255, 122, 0, 1.0)
              : const Color.fromRGBO(120, 100, 80, 0.5),
          shape: const StadiumBorder(),
          elevation: 10,
          shadowColor: const Color.fromRGBO(255, 122, 0, 0.35),
        ),
      ),
    );
  }
}

/// Fingerprint circle widget
class FingerprintCircle extends StatelessWidget {
  final double size;
  final double bgOpacity;
  final double iconSize;

  const FingerprintCircle({
    this.size = 100,
    this.bgOpacity = 0.9,
    this.iconSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(139, 69, 19, bgOpacity),
      ),
      child: Center(
        child: Icon(
          Icons.fingerprint,
          size: iconSize,
          color: const Color.fromRGBO(255, 122, 0, 1.0),
        ),
      ),
    );
  }
}

/// Error message card
class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorCard({
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 0, 0, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(255, 0, 0, 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color.fromRGBO(255, 100, 100, 0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color.fromRGBO(255, 100, 100, 1.0),
                fontSize: 13,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: Color.fromRGBO(255, 100, 100, 0.8),
              ),
            ),
        ],
      ),
    );
  }
}

/// Success message card
class SuccessCard extends StatelessWidget {
  final String message;

  const SuccessCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 255, 0, 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(0, 255, 0, 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color.fromRGBO(100, 255, 100, 0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color.fromRGBO(100, 255, 100, 1.0),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(255, 122, 0, 1.0),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Login background with gradient and glows
class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
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
          Positioned(
            top: -size.width * 0.25,
            left: -size.width * 0.15,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color.fromRGBO(255, 122, 0, 0.12), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.35,
            right: -size.width * 0.1,
            child: Container(
              width: size.width * 1.1,
              height: size.width * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color.fromRGBO(139, 69, 19, 0.18), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status card widget for home screen
class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;

  const StatusCard({
    required this.title,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(255, 122, 0, 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromRGBO(255, 122, 0, 1.0),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings item widget
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 22, 10, 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(255, 122, 0, 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, color: const Color.fromRGBO(255, 122, 0, 1.0)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color.fromRGBO(210, 180, 150, 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Profile header with user info
class ProfileHeader extends StatelessWidget {
  final String username;

  const ProfileHeader({required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(255, 122, 0, 0.8),
                Color.fromRGBO(255, 152, 0, 0.6),
              ],
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          username,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'BioSecure User',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(210, 180, 150, 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// Stats widget for profile
class ProfileStats extends StatelessWidget {
  final String logins;
  final String secured;
  final String devices;

  const ProfileStats({
    this.logins = '42',
    this.secured = '100%',
    this.devices = '1',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn(logins, 'Logins'),
        _buildStatColumn(secured, 'Secured'),
        _buildStatColumn(devices, 'Devices'),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color.fromRGBO(255, 122, 0, 1.0),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(210, 180, 150, 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
