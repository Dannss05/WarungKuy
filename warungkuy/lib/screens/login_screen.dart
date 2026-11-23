import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _hide = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final r = await api.login(_email.text.trim(), _pass.text);
    if (!mounted) return; // kalau sukses, AuthGate langsung pindah ke beranda
    setState(() => _loading = false);
    if (!r.ok) toast(context, r.message);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(
              children: [
                const Logo(size: 96),
                const SizedBox(height: 12),
                const Text(
                  'warungkuy',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: C.brown,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Masuk untuk mulai pesan',
                  style: TextStyle(color: C.muted),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: fieldDeco('Email', Icons.email_outlined),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Masukkan email yang valid'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _pass,
                  obscureText: _hide,
                  decoration: fieldDeco(
                    'Kata sandi',
                    Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _hide ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _hide = !_hide),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                ),
                const SizedBox(height: 24),
                BrownButton(
                  _loading ? 'Memproses...' : 'Masuk',
                  _loading ? () {} : _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: C.muted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: C.brown,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
