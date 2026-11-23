import 'package:flutter/foundation.dart';

/// Kalau aplikasi dijalankan di HP asli (bukan emulator), isi dengan IP laptop
/// yang menjalankan XAMPP, contoh: '192.168.1.5'. Kosongkan untuk emulator/Chrome.
const String manualHost = '';

/// Alamat folder backend PHP di htdocs XAMPP.
String get apiBase {
  if (manualHost.isNotEmpty) return 'http://$manualHost/warungkuy_api';
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2/warungkuy_api'; // alamat laptop dari emulator Android
  }
  return 'http://localhost/warungkuy_api';
}
