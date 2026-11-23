import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';
import '../state/cart.dart';
import 'track_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = 'Jl. Melati No. 12, Depok';
  bool _saving = false;

  Future<void> _editAddress() async {
    final v = await showDialog<String>(
      context: context,
      builder: (_) => _AddressDialog(initial: _address),
    );
    if (!mounted) return;
    if (v != null && v.isNotEmpty) setState(() => _address = v);
  }

  Future<void> _order() async {
    if (cart.lines.isEmpty) {
      toast(context, 'Keranjang masih kosong.');
      return;
    }
    final nav = Navigator.of(context);
    setState(() => _saving = true);
    final r = await api.createOrder(cart, _address);
    if (!mounted) return;
    if (r.ok && r.data is Map) {
      final order = Map<String, dynamic>.from(r.data as Map);
      cart.clear();
      ordersVersion.value++;
      tabIndex.value = 2;
      nav.popUntil((route) => route.isFirst);
      nav.push(MaterialPageRoute(builder: (_) => TrackScreen(order: order)));
    } else {
      setState(() => _saving = false);
      toast(context, r.ok ? 'Respons server tidak valid.' : r.message);
    }
  }

  Widget _choice(bool selected, VoidCallback onTap, Widget child) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            selected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: selected ? C.brown : C.muted,
          ),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    ),
  );

  Widget _method(IconData icon, String title, String sub, String price) => Row(
    children: [
      Icon(icon, color: C.brown),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(sub, style: const TextStyle(fontSize: 11, color: C.muted)),
          ],
        ),
      ),
      Text(price, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Checkout')),
    body: AnimatedBuilder(
      animation: cart,
      builder: (context, child) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (cart.delivery) ...[
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Panel(
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: C.brown),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_address)),
                  GestureDetector(
                    onTap: _editAddress,
                    child: const Text(
                      'Ubah',
                      style: TextStyle(color: C.brown, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          sectionTitle('Metode Pengiriman'),
          Panel(
            child: Column(
              children: [
                _choice(
                  cart.delivery,
                  () => cart.setDelivery(true),
                  _method(
                    Icons.delivery_dining,
                    'Delivery',
                    'Antar ke lokasi · Estimasi 30–45 menit',
                    'Rp 5.000',
                  ),
                ),
                _choice(
                  !cart.delivery,
                  () => cart.setDelivery(false),
                  _method(
                    Icons.restaurant,
                    'Dine In',
                    'Makan di tempat · Langsung tersedia',
                    'Gratis',
                  ),
                ),
              ],
            ),
          ),
          sectionTitle('Metode Pembayaran'),
          Panel(
            child: Column(
              children: [
                _choice(
                  cart.payment == 'COD',
                  () => cart.setPayment('COD'),
                  const Text('COD (Bayar di tempat)'),
                ),
                _choice(
                  cart.payment == 'Transfer Bank',
                  () => cart.setPayment('Transfer Bank'),
                  const Text('Transfer Bank'),
                ),
                _choice(
                  cart.payment == 'E-Wallet',
                  () => cart.setPayment('E-Wallet'),
                  const Text('E-Wallet'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Total Pembayaran', style: TextStyle(fontSize: 13)),
              const Spacer(),
              Text(
                rp(cart.total),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: C.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BrownButton(
            _saving ? 'Memproses...' : 'Pesan Sekarang',
            _saving ? () {} : _order,
          ),
        ],
      ),
    ),
  );
}

class _AddressDialog extends StatefulWidget {
  final String initial;
  const _AddressDialog({required this.initial});

  @override
  State<_AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<_AddressDialog> {
  late final TextEditingController _c = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Ubah alamat'),
    content: TextField(
      controller: _c,
      maxLines: 3,
      decoration: const InputDecoration(hintText: 'Alamat lengkap'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, _c.text.trim()),
        child: const Text('Simpan'),
      ),
    ],
  );
}
