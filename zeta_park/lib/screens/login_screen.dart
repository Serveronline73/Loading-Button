// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/notifiers/login_notifier.dart'; // Import LoginNotifier
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/firebase_auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final bool _isCodeSent = false;
  final String _fixedValidationCode = '123456';
  String _errorMessage = '';
  final ValueNotifier<bool> isCodeSentNotifier = ValueNotifier(false);

  final List<String> validEmailDomains = [
    '.com',
    '.de',
    '.com.tr',
    '.yahoo',
    '.gmail',
    '.gmx',
    '.yandex',
    '.yaani',
    '.yahoo.de'
  ];

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateRequestCodeButtonState);
  }

  void _updateRequestCodeButtonState() {
    setState(() {});
  }

  bool _isValidEmail(String email) {
    if (email.contains('@')) {
      // for (var domain in validEmailDomains) {
      //   if (email.endsWith(domain)) {
      //     return true;
      //   }
      // }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoContainer(),
                const SizedBox(height: 24),
                _buildHeaderText(),
                const SizedBox(height: 12),
                _buildAdminLoginSection(),
                SizedBox(height: 24),
                _buildTermsText(context),
              ],
            ),
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
                Colors.white.withAlpha(25),
                Colors.black.withAlpha(128),
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
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailInput() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'Bitte Email eingeben',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildAdminLoginSection() {
    return Column(
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email eingeben',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Passwort',
            prefixIcon: const Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        _buildLoginButton(
          context,
          'Login',
          Icons.login,
          Colors.black,
          () => _handleLogin(context, 'Admin'),
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey[300],
        ),
      ],
    );
  }

  void _handleLogin(BuildContext context, String method) async {
    final email = emailController.text;
    final code = passwordController.text;
    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Invalid email address';
      });
      return;
    }
    final response =
        await context.read<FirebaseAuthRepository>().signIn(email, code);
    if (response == null) {
      if (code == "admin12") {
        context.read<RoleManager>().setAdmin(isAdmin: true);
      } else {
        context.read<RoleManager>().setAdmin(isAdmin: false);
      }
      Provider.of<LoginNotifier>(context, listen: false).login();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      setState(() {
        _errorMessage = response;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Fehler'),
            content: const Text('Bitte Email oder Passwort überprüfen'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    emailController.removeListener(_updateRequestCodeButtonState);
    emailController.dispose();
    adminEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
