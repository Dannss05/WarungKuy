import 'package:flutter/material.dart';

import '../core/photo.dart';
import '../core/theme.dart';
import '../state/cart.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Widget _sum(String label, String value, {bool big = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: big ? 16 : 13,
            fontWeight: big ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: big ? 20 : 13,
            fontWeight: big ? FontWeight.w800 : FontWeight.w400,
            color: big ? C.brown : C.dark,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Keranjang')),
    body: AnimatedBuilder(
      animation: cart,
      builder: (context, child) {
        if (cart.lines.isEmpty) {
          return const Center(
            child: Text(
              'Keranjang masih kosong.\nPilih menu dulu, yuk!',
              textAlign: TextAlign.center,
              style: TextStyle(color: C.muted),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (final l in cart.lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Panel(
                          child: Row(
                            children: [
                              Photo(l.item, w: 76, h: 76),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (l.extraNames.isNotEmpty)
                                      Text(
                                        l.extraNames.join(', '),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: C.muted,
                                        ),
                                      ),
                                    Text(
                                      rp(l.unitPrice),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    QtyStepper(l.qty, (d) => cart.change(l, d)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.remove(l),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: C.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(color: C.line),
              _sum('Subtotal', rp(cart.subtotal)),
              _sum('Ongkir (Delivery)', rp(cart.ongkir)),
              const Divider(color: C.line),
              _sum('Total', rp(cart.total), big: true),
              const SizedBox(height: 8),
              BrownButton(
                'Lanjut ke Checkout',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
