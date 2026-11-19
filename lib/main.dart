import 'package:flutter/material.dart';

import 'pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Valorant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF4655), // Warna Merah Radiant khas Valorant
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
