import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogoContainer(),
              const SizedBox(height: 24),
              _buildHeaderText(),
              const SizedBox(height: 32),
              _buildLoginButton(
                context,
                'Continue with Apple',
                Icons.apple,
                Colors.white,
                () => _handleLogin(context, 'Apple'),
              ),
              const SizedBox(height: 12),
              _buildLoginButton(
                context,
                'Continue with Google',
                Icons.g_mobiledata,
                Colors.black,
                () => _handleLogin(context, 'Google'),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.grey[300],
              ),
              const SizedBox(height: 12),
              _buildLoginButton(
                context,
                'Continue with Email',
                Icons.email_outlined,
                Colors.black,
                () => _handleLogin(context, 'Email'),
                backgroundColor: Colors.white,
                textColor: Colors.black,
                borderColor: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              _buildTermsText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoContainer() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/zeta_logo.jpeg'),
              fit: BoxFit.scaleDown,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.01),
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText() {
    return const Text(
      'Organize your work and\nlife, finally.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String text,
    IconData icon,
    Color iconColor,
    VoidCallback onPressed, {
    Color backgroundColor = Colors.black,
    Color? borderColor,
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By continuing you agree to Todoist\'s ',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {/* Navigate to Terms */},
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {/* Navigate to Privacy Policy */},
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  void _handleLogin(BuildContext context, String method) {
    // Add login logic here
    print('Logging in with $method');
  }
}
