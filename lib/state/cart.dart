import 'package:flutter/foundation.dart';

import '../models/item.dart';

class CartLine {
  final Item item;
  final List<String> extraNames;
  final int extraPrice;
  int qty;
  CartLine(this.item, this.extraNames, this.extraPrice, this.qty);

  int get unitPrice => item.price + extraPrice;
  int get total => unitPrice * qty;
}

class Cart extends ChangeNotifier {
  final List<CartLine> lines = [];
  bool delivery = true;
  String payment = 'COD';

  int get count => lines.fold(0, (s, l) => s + l.qty);
  int get subtotal => lines.fold(0, (s, l) => s + l.total);
  int get ongkir => delivery && lines.isNotEmpty ? 5000 : 0;
  int get total => subtotal + ongkir;

  void setDelivery(bool value) {
    delivery = value;
    notifyListeners();
  }

  void setPayment(String value) {
    payment = value;
    notifyListeners();
  }

  void add(
    Item item, {
    List<String> extraNames = const [],
    int extraPrice = 0,
    int qty = 1,
  }) {
    final key = extraNames.join(',');
    final i = lines.indexWhere(
      (l) => l.item.name == item.name && l.extraNames.join(',') == key,
    );
    if (i >= 0) {
      lines[i].qty += qty;
    } else {
      lines.add(CartLine(item, extraNames, extraPrice, qty));
    }
    notifyListeners();
  }

  void change(CartLine l, int d) {
    l.qty = (l.qty + d).clamp(1, 99);
    notifyListeners();
  }

  void remove(CartLine l) {
    lines.remove(l);
    notifyListeners();
  }

  void clear() {
    lines.clear();
    notifyListeners();
  }
}

final Cart cart = Cart();

/// Tab aktif di bottom navigation (0 Beranda, 1 Menu, 2 Pesanan, 3 Akun).
final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);

/// Naik setiap ada pesanan baru, supaya daftar pesanan memuat ulang.
final ValueNotifier<int> ordersVersion = ValueNotifier<int>(0);
