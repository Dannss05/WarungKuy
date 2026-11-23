import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../state/cart.dart';

class AppUser {
  final int id;
  final String name, phone, email;
  const AppUser(this.id, this.name, this.phone, this.email);

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    j['id'] is num ? (j['id'] as num).toInt() : 0,
    '${j['name'] ?? ''}',
    '${j['phone'] ?? ''}',
    '${j['email'] ?? ''}',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
  };
}

class ApiResult {
  final bool ok;
  final String message;
  final dynamic data;
  const ApiResult(this.ok, this.message, [this.data]);
}

List<Map<String, dynamic>> parseOrders(dynamic data) {
  if (data is! List) return [];
  return data
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}

/// Penghubung ke backend PHP (XAMPP) + penyimpan sesi login.
class Api extends ChangeNotifier {
  String? _token;
  AppUser? user;

  bool get loggedIn => _token != null && user != null;

  /// Dipanggil sekali saat aplikasi dibuka: memulihkan sesi yang tersimpan.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final raw = prefs.getString('user');
      if (token != null && raw != null) {
        _token = token;
        user = AppUser.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map),
        );
      }
    } catch (_) {
      _token = null;
      user = null;
    }
  }

  Future<void> _saveSession(String token, AppUser u) async {
    _token = token;
    user = u;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('user', jsonEncode(u.toJson()));
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _clearSession() async {
    _token = null;
    user = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
    } catch (_) {}
    notifyListeners();
  }

  Future<ApiResult> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final hadToken = _token != null;
    try {
      final uri = Uri.parse('$apiBase/$path');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Auth-Token': ?_token,
      };
      final res = method == 'GET'
          ? await http
                .get(uri, headers: headers)
                .timeout(const Duration(seconds: 15))
          : await http
                .post(uri, headers: headers, body: jsonEncode(body ?? {}))
                .timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      if (decoded is! Map) {
        return const ApiResult(false, 'Respons server tidak valid.');
      }
      if (res.statusCode == 401 && hadToken) {
        await _clearSession(); // sesi habis -> kembali ke halaman login
      }
      return ApiResult(
        decoded['success'] == true,
        '${decoded['message'] ?? ''}',
        decoded['data'],
      );
    } on TimeoutException {
      return const ApiResult(
        false,
        'Server tidak merespons. Cek XAMPP dan koneksi kamu.',
      );
    } on FormatException {
      return const ApiResult(
        false,
        'Respons server tidak valid. Pastikan folder warungkuy_api ada di htdocs dan database sudah diimport.',
      );
    } catch (_) {
      return const ApiResult(
        false,
        'Tidak dapat terhubung ke server. Pastikan Apache dan MySQL di XAMPP menyala, dan alamat di config.dart benar.',
      );
    }
  }

  Future<ApiResult> _authenticate(
    String path,
    Map<String, dynamic> body,
  ) async {
    final r = await _request('POST', path, body: body);
    if (r.ok && r.data is Map) {
      final d = Map<String, dynamic>.from(r.data as Map);
      final token = d['token'];
      final u = d['user'];
      if (token is String && u is Map) {
        await _saveSession(
          token,
          AppUser.fromJson(Map<String, dynamic>.from(u)),
        );
        return r;
      }
      return const ApiResult(false, 'Respons server tidak lengkap.');
    }
    return r;
  }

  Future<ApiResult> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) => _authenticate('register.php', {
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
  });

  Future<ApiResult> login(String email, String password) =>
      _authenticate('login.php', {'email': email, 'password': password});

  Future<void> logout() async {
    await _request('POST', 'logout.php');
    await _clearSession();
  }

  Future<ApiResult> fetchOrders() => _request('GET', 'orders.php');

  Future<ApiResult> createOrder(Cart c, String address) => _request(
    'POST',
    'create_order.php',
    body: {
      'delivery': c.delivery,
      'payment': c.payment,
      'address': address,
      'items': c.lines
          .map(
            (l) => {
              'name': l.item.name,
              'qty': l.qty,
              'price': l.unitPrice,
              'extras': l.extraNames.join(', '),
            },
          )
          .toList(),
    },
  );
}

final Api api = Api();
