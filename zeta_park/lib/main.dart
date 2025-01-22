// Importieren der notwendigen Pakete
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:flutter_application_1/screens/statistics_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifiers/theme_notifier.dart';

// Hauptfunktion der App
void main() async {
  // Initialisierung der Widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Laden der gespeicherten Einstellungen
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  // Festlegen der bevorzugten Ausrichtungen des Geräts
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Starten der App mit dem ThemeNotifier
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(isDarkMode),
        ),
        ChangeNotifierProvider(create: (context) => RoleManager()),
        Provider(create: (context) => DataManager()),
      ],
      child: MaterialApp(
        title: 'Zeta Park',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MyHomePage(),
          '/statistics': (context) => const StatisticsScreen(),
        },
      ),
    ),
  );
}
