import 'package:flutter/material.dart';

class C {
  static const bg = Color(0xFFFBF3E6);
  static const card = Color(0xFFFFFAF1);
  static const brown = Color(0xFF7A4A2B);
  static const dark = Color(0xFF4A2A18);
  static const line = Color(0xFFEBDCC6);
  static const muted = Color(0xFF8C7360);
}

String rp(int v) =>
    'Rp ${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';

int asInt(dynamic v) {
  if (v is num) return v.toInt();
  return int.tryParse('$v') ?? 0;
}

void toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
}

InputDecoration fieldDeco(String label, IconData icon, {Widget? suffix}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: C.muted),
    suffixIcon: suffix,
    filled: true,
    fillColor: C.card,
    enabledBorder: border(C.line),
    focusedBorder: border(C.brown),
    errorBorder: border(Colors.red.shade300),
    focusedErrorBorder: border(Colors.red.shade400),
  );
}

class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: C.brown,
      borderRadius: BorderRadius.circular(size * .28),
    ),
    child: Image.asset(
  'assets/logo.png',
  width: size,
  height: size,
  fit: BoxFit.contain,
)
    
  );
}

class BrownButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  const BrownButton(this.label, this.onTap, {super.key, this.icon});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: C.brown,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: C.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: C.line),
    ),
    child: child,
  );
}

Widget sectionTitle(String t, {VoidCallback? onMore}) => Padding(
  padding: const EdgeInsets.only(top: 18, bottom: 10),
  child: Row(
    children: [
      Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: C.dark,
        ),
      ),
      const Spacer(),
      if (onMore != null)
        GestureDetector(
          onTap: onMore,
          child: const Text(
            'Lihat Semua ›',
            style: TextStyle(fontSize: 12, color: C.muted),
          ),
        ),
    ],
  ),
);

class QtyStepper extends StatelessWidget {
  final int qty;
  final ValueChanged<int> onChange;
  const QtyStepper(this.qty, this.onChange, {super.key});

  Widget _btn(IconData i, int d) => InkWell(
    onTap: () => onChange(d),
    borderRadius: BorderRadius.circular(8),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: C.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(i, size: 16, color: C.dark),
    ),
  );

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _btn(Icons.remove, -1),
      SizedBox(
        width: 36,
        child: Center(
          child: Text(
            '$qty',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      _btn(Icons.add, 1),
    ],
  );
}

String fmtDate(dynamic s) {
  final d = DateTime.tryParse('$s'.replaceFirst(' ', 'T'));
  if (d == null) return '$s';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
}
