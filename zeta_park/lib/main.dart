// Importieren der notwendigen Pakete
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'notifiers/login_notifier.dart';
import 'notifiers/theme_notifier.dart';
import 'repository/firebase_auth_repository.dart';

// Hauptfunktion der App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        ChangeNotifierProvider(create: (_) => RoleManager()),
        // ChangeNotifierProvider(create: (_) => DataManager()),
        Provider<FirebaseAuthRepository>(
            create: (context) => FirebaseAuthRepository()),
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(isDarkMode),
        ),
        ChangeNotifierProvider(create: (_) => LoginNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}
