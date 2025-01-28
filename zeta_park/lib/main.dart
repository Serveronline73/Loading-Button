// Importieren der notwendigen Pakete
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/data_manager.dart';
import 'package:flutter_application_1/repository/firestore_data_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifiers/theme_notifier.dart';
import 'repository/firebase_auth_repository.dart';

// Hauptfunktion der App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

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
        Provider<FirebaseAuthRepository>(
          create: (context) => FirebaseAuthRepository(),
        ),
        Provider<FirestoreDataRepository>(
          create: (context) => FirestoreDataRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(isDarkMode),
        ),
        ChangeNotifierProvider(
          create: (context) => RoleManager(),
        ),
        Provider(
          create: (context) => DataManager(),
        ), // DataManager Provider hinzufügen
      ],
      child: const MyApp(),
    ),
  );
}
