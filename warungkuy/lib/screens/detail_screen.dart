import 'package:flutter/material.dart';

import '../core/photo.dart';
import '../core/theme.dart';
import '../models/item.dart';
import '../state/cart.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Item item;
  const DetailScreen(this.item, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Set<int> _picked = {};
  int _qty = 1;
  bool _fav = false;

  @override
  void initState() {
    super.initState();
    if (!widget.item.drink) _picked.add(0); // Telur dipilih secara default
  }

  void _addToCart() {
    final names = _picked.map((i) => extras[i].name).toList();
    final extraPrice = _picked.fold<int>(0, (s, i) => s + extras[i].price);
    cart.add(widget.item, extraNames: names, extraPrice: extraPrice, qty: _qty);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Photo(it, w: double.infinity, h: 260, r: 0),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: C.dark),
                        ),
                      ),
                      const Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => setState(() => _fav = !_fav),
                          icon: Icon(
                            _fav ? Icons.favorite : Icons.favorite_border,
                            color: C.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  it.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: C.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rp(it.price),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(it.desc, style: const TextStyle(color: C.muted)),
                if (!it.drink) ...[
                  sectionTitle('Pilih Tambahan'),
                  Panel(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (int i = 0; i < extras.length; i++)
                          CheckboxListTile(
                            dense: true,
                            value: _picked.contains(i),
                            activeColor: C.brown,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                _picked.add(i);
                              } else {
                                _picked.remove(i);
                              }
                            }),
                            title: Text(extras[i].name),
                            secondary: Text(
                              '+${rp(extras[i].price)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: C.muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Center(
                  child: QtyStepper(
                    _qty,
                    (d) => setState(() => _qty = (_qty + d).clamp(1, 99)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: BrownButton(
              'Tambah ke Keranjang',
              _addToCart,
              icon: Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
