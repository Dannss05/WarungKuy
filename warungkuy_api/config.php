<?php
// ====== Pengaturan database (default XAMPP) ======
const DB_HOST = '127.0.0.1';
const DB_NAME = 'warungkuy';
const DB_USER = 'root';
const DB_PASS = '';
const DEBUG   = true; // ubah ke false kalau sudah dipakai sungguhan

ini_set('display_errors', '0');
error_reporting(E_ALL);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, X-Auth-Token');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function respond($success, $message, $data = null, $code = 200)
{
    http_response_code($code);
    echo json_encode(
        ['success' => (bool)$success, 'message' => $message, 'data' => $data],
        JSON_UNESCAPED_UNICODE
    );
    exit;
}

set_exception_handler(function ($e) {
    $msg = DEBUG ? 'Kesalahan server: ' . $e->getMessage() : 'Terjadi kesalahan pada server.';
    respond(false, $msg, null, 500);
});

function db()
{
    static $pdo = null;
    if ($pdo === null) {
        try {
            $pdo = new PDO(
                'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
                DB_USER,
                DB_PASS,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]
            );
        } catch (PDOException $e) {
            respond(
                false,
                'Gagal terhubung ke database. Pastikan MySQL di XAMPP menyala dan database "warungkuy" sudah diimport.',
                null,
                500
            );
        }
    }
    return $pdo;
}

function input()
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function require_method($method)
{
    if (($_SERVER['REQUEST_METHOD'] ?? '') !== $method) {
        respond(false, 'Metode tidak diizinkan.', null, 405);
    }
}

function token_from_request()
{
    $token = $_SERVER['HTTP_X_AUTH_TOKEN'] ?? '';
    if ($token === '' && function_exists('getallheaders')) {
        foreach (getallheaders() as $key => $value) {
            if (strtolower($key) === 'x-auth-token') {
                $token = $value;
            }
        }
    }
    return trim($token);
}

function current_user()
{
    $token = token_from_request();
    if ($token === '') {
        respond(false, 'Sesi tidak valid. Silakan masuk lagi.', null, 401);
    }
    $st = db()->prepare('SELECT id, name, phone, email FROM users WHERE api_token = ? LIMIT 1');
    $st->execute([$token]);
    $user = $st->fetch();
    if (!$user) {
        respond(false, 'Sesi berakhir. Silakan masuk lagi.', null, 401);
    }
    return $user;
}

function user_json($u)
{
    return [
        'id' => (int)$u['id'],
        'name' => $u['name'],
        'phone' => $u['phone'],
        'email' => $u['email'],
    ];
}

function order_json($pdo, $o)
{
    $st = $pdo->prepare('SELECT name, qty, price, extras FROM order_items WHERE order_id = ? ORDER BY id');
    $st->execute([$o['id']]);
    $items = [];
    foreach ($st->fetchAll() as $r) {
        $items[] = [
            'name' => $r['name'],
            'qty' => (int)$r['qty'],
            'price' => (int)$r['price'],
            'extras' => $r['extras'],
        ];
    }
    return [
        'id' => (int)$o['id'],
        'code' => 'WK-' . str_pad((string)$o['id'], 5, '0', STR_PAD_LEFT),
        'status' => $o['status'],
        'subtotal' => (int)$o['subtotal'],
        'ongkir' => (int)$o['ongkir'],
        'total' => (int)$o['total'],
        'delivery' => (bool)$o['delivery'],
        'payment' => $o['payment'],
        'address' => $o['address'],
        'created_at' => $o['created_at'],
        'items' => $items,
    ];
}
