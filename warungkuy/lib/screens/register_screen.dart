import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  bool _hide = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    _pass2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final r = await api.register(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (r.ok) {
      Navigator.pop(context); // AuthGate sudah menampilkan beranda di bawahnya
    } else {
      toast(context, r.message);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Daftar')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Buat akun baru',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: C.dark,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Isi data kamu supaya bisa mulai pesan.',
                  style: TextStyle(color: C.muted),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: fieldDeco('Nama lengkap', Icons.person_outline),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: fieldDeco('Nomor HP', Icons.phone_outlined),
                validator: (v) => (v == null || v.trim().length < 9)
                    ? 'Nomor HP tidak valid'
                    : null,
              ),
              const SizedBox(height: 14),
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
                    icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _pass2,
                obscureText: _hide,
                decoration: fieldDeco('Ulangi kata sandi', Icons.lock_outline),
                validator: (v) =>
                    v != _pass.text ? 'Kata sandi tidak sama' : null,
              ),
              const SizedBox(height: 24),
              BrownButton(
                _loading ? 'Memproses...' : 'Buat Akun',
                _loading ? () {} : _submit,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
