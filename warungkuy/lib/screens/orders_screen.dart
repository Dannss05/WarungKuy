import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/api.dart';
import '../state/cart.dart';
import 'track_screen.dart';

/// Tab "Pesanan": riwayat pesanan dari database (MySQL).
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    tabIndex.addListener(_onTab);
    ordersVersion.addListener(_onVersion);
    _load();
  }

  @override
  void dispose() {
    tabIndex.removeListener(_onTab);
    ordersVersion.removeListener(_onVersion);
    super.dispose();
  }

  void _onTab() {
    if (tabIndex.value == 2) _load();
  }

  void _onVersion() => _load();

  Future<void> _load() async {
    final r = await api.fetchOrders();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (r.ok) {
        _orders = parseOrders(r.data);
        _error = null;
      } else {
        _error = r.message;
      }
    });
  }

  Color _statusColor(String s) =>
      s == 'Selesai' ? Colors.green.shade700 : C.brown;

  Widget _state(Widget child) => ListView(
    children: [SizedBox(height: 300, child: Center(child: child))],
  );

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = _state(const CircularProgressIndicator());
    } else if (_error != null && _orders.isEmpty) {
      body = _state(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.muted),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _load, child: const Text('Coba lagi')),
            ],
          ),
        ),
      );
    } else if (_orders.isEmpty) {
      body = _state(
        const Text(
          'Belum ada pesanan.\nYuk, pesan makanan favoritmu!',
          textAlign: TextAlign.center,
          style: TextStyle(color: C.muted),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: _orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = _orders[i];
          final list = (o['items'] is List) ? o['items'] as List : const [];
          final summary = list
              .whereType<Map>()
              .map((e) => '${e['qty']}x ${e['name']}')
              .join(', ');
          final status = '${o['status']}';
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TrackScreen(order: o)),
            ),
            child: Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${o['code'] ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _statusColor(status),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fmtDate(o['created_at']),
                    style: const TextStyle(fontSize: 11, color: C.muted),
                  ),
                  const SizedBox(height: 8),
                  Text(summary, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(
                    rp(asInt(o['total'])),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Pesanan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: C.dark,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(onRefresh: _load, child: body),
        ),
      ],
    );
  }
}
