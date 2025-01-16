import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:provider/provider.dart';

import 'notifiers/theme_notifier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    const bool isLoggedIn =
        true; // Vorübergehend auf true gesetzt, bis die Authentifizierung implementiert ist danach wieder auf false setzen

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: isLoggedIn
          ? const MyHomePage()
          : const LoginScreen(), // Conditional navigation
    );
  }
}
