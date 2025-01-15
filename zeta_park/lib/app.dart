import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/my_home_page.dart';
import 'package:provider/provider.dart';

import 'notifiers/theme_notifier.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Zeta Park Villalari Kusadasi',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: const MyHomePage(),
      ),
    );
  }
}
