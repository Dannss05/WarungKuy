import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';
import '../state/cart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _menu(IconData icon, String title, VoidCallback onTap) => ListTile(
    dense: true,
    leading: Icon(icon, color: C.dark),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right, color: C.muted),
    onTap: onTap,
  );

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    tabIndex.value = 0;
    cart.clear();
    await api.logout();
  }

  @override
  Widget build(BuildContext context) {
    final u = api.user;
    void soon() => toast(context, 'Fitur ini segera hadir');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Row(
          children: [
            Logo(),
            SizedBox(width: 8),
            Text(
              'warungkuy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: C.dark,
              ),
            ),
            Spacer(),
            Icon(Icons.settings_outlined),
          ],
        ),
        const SizedBox(height: 14),
        Panel(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: C.brown,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u?.name ?? 'Pengguna',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      u?.phone ?? '',
                      style: const TextStyle(fontSize: 11, color: C.muted),
                    ),
                    Text(
                      u?.email ?? '',
                      style: const TextStyle(fontSize: 11, color: C.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _menu(
                Icons.receipt_long,
                'Pesanan Saya',
                () => tabIndex.value = 2,
              ),
              _menu(Icons.location_on_outlined, 'Alamat Saya', soon),
              _menu(Icons.credit_card, 'Metode Pembayaran', soon),
              _menu(Icons.notifications_none, 'Notifikasi', soon),
              _menu(Icons.help_outline, 'Bantuan', soon),
              _menu(Icons.info_outline, 'Tentang Warungkuy', soon),
            ],
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton(
          onPressed: () => _logout(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: C.brown,
            side: const BorderSide(color: C.brown),
            minimumSize: const Size.fromHeight(46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Keluar',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
