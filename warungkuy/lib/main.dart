import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/splash_screen.dart';
import 'services/api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await api.init();
  runApp(const WarungKuyApp());
}

class WarungKuyApp extends StatelessWidget {
  const WarungKuyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'warungkuy',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: C.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: C.brown),
      appBarTheme: const AppBarTheme(
        backgroundColor: C.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: C.dark,
        titleTextStyle: TextStyle(
          color: C.dark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    home: const SplashScreen(),
  );
}
