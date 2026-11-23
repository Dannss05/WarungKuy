import 'package:flutter/material.dart';

import '../core/photo.dart';
import '../core/theme.dart';
import '../models/item.dart';
import '../state/cart.dart';
import 'detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _filter = 0; // 0 semua, 1 makanan, 2 minuman
  bool _searching = false;
  String _query = '';

  List<Item> _match(List<Item> src) => src
      .where((i) => i.name.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  Widget _chip(String label, int index) => Padding(
    padding: const EdgeInsets.only(right: 10),
    child: ChoiceChip(
      label: Text(label),
      selected: _filter == index,
      onSelected: (_) => setState(() => _filter = index),
      selectedColor: C.brown,
      backgroundColor: C.card,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: _filter == index ? Colors.white : C.dark,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: C.line),
    ),
  );

  Widget _row(Item it) => InkWell(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(it)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Photo(it, w: 72, h: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  it.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: C.dark,
                  ),
                ),
                Text(
                  it.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: C.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  rp(it.price),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              cart.add(it);
              toast(context, '${it.name} masuk keranjang');
            },
            icon: const Icon(Icons.add_circle, color: C.brown, size: 30),
          ),
        ],
      ),
    ),
  );

  Widget _header() {
    if (_searching) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Cari menu...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _searching = false;
              _query = '';
            }),
            icon: const Icon(Icons.close),
          ),
        ],
      );
    }
    return Row(
      children: [
        const Text(
          'Menu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: C.dark,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => setState(() => _searching = true),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = _filter == 2 ? <Item>[] : _match(foods);
    final d = _filter == 1 ? <Item>[] : _match(drinks);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        _header(),
        Row(
          children: [
            _chip('Semua', 0),
            _chip('Makanan', 1),
            _chip('Minuman', 2),
          ],
        ),
        if (f.isNotEmpty) ...[sectionTitle('Makanan'), ...f.map(_row)],
        if (d.isNotEmpty) ...[sectionTitle('Minuman'), ...d.map(_row)],
        if (f.isEmpty && d.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                'Menu tidak ditemukan',
                style: TextStyle(color: C.muted),
              ),
            ),
          ),
      ],
    );
  }
}
