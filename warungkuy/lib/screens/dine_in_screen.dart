import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/cart.dart';

class DineInScreen extends StatelessWidget {
  const DineInScreen({super.key});

  Widget _perk(IconData icon, String text) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: C.brown),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: C.muted),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dine In')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 190,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFB07A4A), Color(0xFF6B4023)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Text('🪑 🍽️ 🪑', style: TextStyle(fontSize: 48)),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nikmati makanan favorit kamu\ndengan suasana yang nyaman!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: C.dark,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _perk(Icons.favorite_border, 'Tempat bersih\ndan nyaman'),
            _perk(Icons.sentiment_satisfied_alt, 'Pelayanan\nramah'),
            _perk(Icons.menu_book, 'Menu lengkap\n& harga terjangkau'),
          ],
        ),
        const SizedBox(height: 24),
        BrownButton('Pesan Meja', () {
          cart.setDelivery(false);
          tabIndex.value = 1;
          Navigator.pop(context);
        }, icon: Icons.event_seat),
      ],
    ),
  );
}
