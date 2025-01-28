import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/notifiers/login_notifier.dart'; // Import LoginNotifier
import 'package:flutter_application_1/providers/data_provider.dart';
import 'package:flutter_application_1/providers/role.dart';
import 'package:flutter_application_1/repository/firebase_auth_repository.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:provider/provider.dart';

import 'notifiers/theme_notifier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginNotifier(),
        ),
        // Provide LoginNotifier
        ChangeNotifierProvider(
          create: (context) => DataProvider(
            repository: context.read(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeNotifier(false)),
      ],
      child: StreamBuilder<User?>(
        stream: context.read<FirebaseAuthRepository>().signInState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final bool isLoggedIn = snapshot.data != null;
            if (isLoggedIn &&
                snapshot.data!.uid == "3b4qufoN5OPbvEpN6TyE7wv9REE3") {
              context.read<RoleManager>().setAdmin(isAdmin: true);
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,

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
      ),
    );
  }
}
