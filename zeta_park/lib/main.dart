// Importieren der notwendigen Pakete
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
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
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(isDarkMode),
      child: const MyApp(),
    ),
  );
}
