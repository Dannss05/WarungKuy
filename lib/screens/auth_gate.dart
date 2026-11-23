import 'package:flutter/material.dart';

import '../services/api.dart';
import 'login_screen.dart';
import 'main_shell.dart';

/// Sudah login -> aplikasi utama. Belum / sesi habis -> halaman masuk.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: api,
    builder: (context, child) =>
        api.loggedIn ? const MainShell() : const LoginScreen(),
  );
}
