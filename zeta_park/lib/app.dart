import 'package:flutter/material.dart';
import 'package:flutter_application_1/notifiers/login_notifier.dart'; // Import LoginNotifier
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifiers/theme_notifier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LoginNotifier()), // Provide LoginNotifier
        ChangeNotifierProvider(create: (_) => ThemeNotifier(false)),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return FutureBuilder<bool>(
            future: _checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final bool isLoggedIn = snapshot.data ?? false;
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeNotifier.isDarkMode
                      ? ThemeData.dark()
                      : ThemeData.light(),
                  home: isLoggedIn
                      ? const MyHomePage()
                      : const LoginScreen(), // Conditional navigation
                  routes: {
                    '/login': (context) => const LoginScreen(),
                    '/home': (context) => const MyHomePage(),
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
