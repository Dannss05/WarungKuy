import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';

class TrackScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  const TrackScreen({super.key, required this.order});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  static const _statuses = ['Diterima', 'Dimasak', 'Dikirim', 'Selesai'];
  late Map<String, dynamic> _order = widget.order;
  bool _refreshing = false;

  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final r = await api.fetchOrders();
    if (!mounted) return;
    setState(() => _refreshing = false);
    if (!r.ok) {
      toast(context, r.message);
      return;
    }
    final id = asInt(_order['id']);
    for (final o in parseOrders(r.data)) {
      if (asInt(o['id']) == id) {
        setState(() => _order = o);
        break;
      }
    }
  }

  Widget _step(IconData icon, String label, int index, int current) {
    final completed = index < current || (current == 3 && index == 3);
    final active = index == current && !completed;
    final on = completed || active;
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: on ? C.brown : C.line,
          child: Icon(
            completed ? Icons.check : icon,
            color: on ? Colors.white : C.muted,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: C.dark,
            fontWeight: active ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _line(bool on) => Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 21),
      child: Container(height: 2, color: on ? C.brown : C.line),
    ),
  );

  Widget _itemRow(Map it) {
    final extra = '${it['extras'] ?? ''}';
    final label = extra.isEmpty
        ? '${it['qty']}x ${it['name']}'
        : '${it['qty']}x ${it['name']} ($extra)';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            rp(asInt(it['price']) * asInt(it['qty'])),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final delivery = _order['delivery'] == true;
    final status = '${_order['status']}';
    var current = _statuses.indexOf(status);
    if (current < 0) current = 0;

    String title;
    String subtitle;
    switch (current) {
      case 0:
        title = 'Pesanan Diterima';
        subtitle = 'Restoran sedang mengonfirmasi pesanan kamu.';
        break;
      case 1:
        title = 'Pesanan Sedang Dimasak';
        subtitle =
            'Tim kami sedang menyiapkan pesanan kamu\ndengan penuh cinta ❤️';
        break;
      case 2:
        title = delivery
            ? 'Pesanan Dalam Perjalanan'
            : 'Pesanan Segera Disajikan';
        subtitle = delivery
            ? 'Kurir sedang menuju lokasi kamu.'
            : 'Pesanan kamu akan segera diantar ke meja.';
        break;
      default:
        title = 'Pesanan Selesai';
        subtitle = 'Selamat menikmati! Terima kasih sudah memesan 🙏';
    }

    final items = (_order['items'] is List)
        ? _order['items'] as List
        : const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Pesanan'),
        actions: [
          IconButton(
            onPressed: _refreshing ? null : _refresh,
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _step(Icons.receipt, 'Pesanan\nDiterima', 0, current),
              _line(current > 0),
              _step(Icons.soup_kitchen, 'Dimasak', 1, current),
              _line(current > 1),
              _step(
                delivery ? Icons.delivery_dining : Icons.restaurant,
                delivery ? 'Dikirim' : 'Disajikan',
                2,
                current,
              ),
              _line(current > 2),
              _step(Icons.check, 'Selesai', 3, current),
            ],
          ),
          const SizedBox(height: 28),
          const Center(child: Logo(size: 100)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: C.dark,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          if (current < 3)
            Panel(
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: C.brown),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery ? 'Estimasi tiba' : 'Estimasi siap',
                        style: const TextStyle(fontSize: 11, color: C.muted),
                      ),
                      Text(
                        delivery ? '30 – 45 menit' : '15 – 20 menit',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_order['code'] ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      fmtDate(_order['created_at']),
                      style: const TextStyle(fontSize: 11, color: C.muted),
                    ),
                  ],
                ),
                const Divider(color: C.line),
                for (final it in items.whereType<Map>()) _itemRow(it),
                const Divider(color: C.line),
                Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    Text(
                      rp(asInt(_order['total'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: C.brown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${_order['payment'] ?? ''} · ${_order['address'] ?? ''}',
                  style: const TextStyle(fontSize: 11, color: C.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          BrownButton(
            'Hubungi Restoran',
            () => toast(context, 'Fitur telepon restoran belum dihubungkan.'),
            icon: Icons.phone,
          ),
        ],
      ),
    );
  }
}
