import 'package:flutter/material.dart';

class Item {
  final String name, desc, emoji;
  final int price;
  final bool drink;
  final Color color;
  const Item(
    this.name,
    this.desc,
    this.price,
    this.emoji,
    this.color, {
    this.drink = false,
  });
}

class Extra {
  final String name;
  final int price;
  const Extra(this.name, this.price);
}

const List<Item> foods = [
  Item(
    'Indomie Goreng',
    'Indomie goreng spesial dengan telur dan sayur.',
    15000,
    '🍜',
    Color(0xFFE9B873),
  ),
  Item(
    'Nasi Goreng',
    'Nasi goreng dengan bumbu khas warungkuy.',
    18000,
    '🍛',
    Color(0xFFD99A4E),
  ),
  Item(
    'Kwetiau Goreng',
    'Kwetiau goreng dengan ayam dan sayur.',
    18000,
    '🍝',
    Color(0xFFE2A95B),
  ),
  Item(
    'Kwetiau Siram',
    'Kwetiau dengan kuah gurih dan sayur.',
    18000,
    '🥘',
    Color(0xFFEBC48A),
  ),
  Item(
    'Mie Goreng',
    'Mie goreng spesial dengan telur dan sayur.',
    16000,
    '🍜',
    Color(0xFFDDA45C),
  ),
];

const List<Item> drinks = [
  Item(
    'Teh Obeng',
    'Es teh manis segar.',
    7000,
    '🥤',
    Color(0xFFC77B3C),
    drink: true,
  ),
  Item(
    'Teh Tarik',
    'Teh susu tarik hangat.',
    8000,
    '🧋',
    Color(0xFFD9A36B),
    drink: true,
  ),
  Item(
    'Kopi Susu',
    'Kopi susu gula aren.',
    10000,
    '☕',
    Color(0xFFCFB8A0),
    drink: true,
  ),
];

const List<Extra> extras = [
  Extra('Telur', 2000),
  Extra('Sosis', 3000),
  Extra('Keju', 3000),
];
