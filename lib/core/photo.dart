
import 'package:flutter/material.dart';
import '../models/item.dart';

class Photo extends StatelessWidget {
  final Item item;
  final double? w, h;
  final double r;

  const Photo(this.item, {super.key, this.w, this.h, this.r = 12});

  @override
  Widget build(BuildContext context) {
    String? imagePath;

    if (item.name == 'Nasi Goreng') {
      imagePath = 'assets/nasi_goreng.png';
    } else if (item.name == 'Indomie Goreng') {
  imagePath = 'assets/indomie_goreng.png';
} else if (item.name == 'Kwetiau Goreng') {
  imagePath = 'assets/kwetiau_goreng.png';
} else if (item.name == 'Teh Obeng') {
  imagePath = 'assets/teh_obeng.png';
} else if (item.name == 'Teh Tarik') {
  imagePath = 'assets/teh_tarik.png';
} else if (item.name == 'Kopi Susu') {
  imagePath = 'assets/kopi_susu.png';
} else if (item.name == 'Kwetiau Siram') {
  imagePath = 'assets/kwetiau_siram.png';
} else if (item.name == 'Mie Goreng') {
  imagePath = 'assets/mie_goreng.png';
}

    return Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(r),
      ),
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(r),
              child: Image.asset(
                imagePath,
                width: w,
                height: h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    item.emoji,
                    style: TextStyle(fontSize: (h ?? 60) * .5),
                  );
                },
              ),
            )
          : Text(
              item.emoji,
              style: TextStyle(fontSize: (h ?? 60) * .5),
            ),
    );
  }
}