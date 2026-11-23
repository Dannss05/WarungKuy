import 'package:flutter/material.dart';

import '../core/photo.dart';
import '../core/theme.dart';
import '../models/item.dart';
import '../state/cart.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';
import 'dine_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _option(IconData icon, String title, String sub, VoidCallback onTap) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Panel(
            child: Row(
              children: [
                Icon(icon, color: C.brown, size: 30),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: C.dark,
                        ),
                      ),
                      Text(
                        sub,
                        style: const TextStyle(fontSize: 10, color: C.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _fav(BuildContext context, Item it) => Expanded(
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(it)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Photo(it, h: 76),
            const SizedBox(height: 6),
            Text(
              it.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            Text(
              rp(it.price),
              style: const TextStyle(fontSize: 11, color: C.muted),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    children: [
      Row(
        children: [
          const Logo(),
          const SizedBox(width: 8),
          const Text(
            'warungkuy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: C.dark,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => toast(context, 'Belum ada notifikasi baru'),
            icon: const Icon(Icons.notifications_none),
          ),
          AnimatedBuilder(
            animation: cart,
            builder: (context, child) => IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              icon: Badge(
                isLabelVisible: cart.count > 0,
                label: Text('${cart.count}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      
Container(
  height: 120,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    image: const DecorationImage(
      image: AssetImage('assets/banner.png'),
      fit: BoxFit.fitWidth,
    ),
    gradient: const LinearGradient(
      colors: [
        Color(0x993D210F),
        Color(0x334D2D16),
      ],
    ),
  ),
  child: ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    'assets/banner.png',
    width: double.infinity,
    fit: BoxFit.fitWidth,
  ),
),
),

      const SizedBox(height: 12),
      Row(
        children: [
          _option(
            Icons.delivery_dining,
            'Delivery',
            'Antar ke lokasi kamu',
            () {
              cart.setDelivery(true);
              tabIndex.value = 1;
            },
          ),
          const SizedBox(width: 10),
          _option(Icons.restaurant, 'Dine In', 'Makan di tempat', () {
            cart.setDelivery(false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DineInScreen()),
            );
          }),
        ],
      ),
      sectionTitle('Menu Favorit', onMore: () => tabIndex.value = 1),
      Row(children: [for (final f in foods.take(3)) _fav(context, f)]),
      sectionTitle('Minuman Favorit', onMore: () => tabIndex.value = 1),
      Row(children: [for (final d in drinks) _fav(context, d)]),
    ],
  );
}
