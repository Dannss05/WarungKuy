import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/cart.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: tabIndex,
    builder: (context, i, child) => Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: i,
          children: const [
            HomeScreen(),
            MenuScreen(),
            OrdersScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i,
        onTap: (v) => tabIndex.value = v,
        type: BottomNavigationBarType.fixed,
        backgroundColor: C.card,
        selectedItemColor: C.brown,
        unselectedItemColor: C.muted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Akun',
          ),
        ],
      ),
    ),
  );
}
