import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140,
            decoration: const BoxDecoration(
              color: C.brown,
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(400, 80),
              ),
            ),
          ),
        ),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Logo(size: 120),
              SizedBox(height: 18),
              Text(
                'warungkuy',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: C.brown,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Makan Enak\nJadi Lebih Mudah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: C.brown,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
