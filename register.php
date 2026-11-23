<?php
require __DIR__ . '/config.php';
require_method('POST');

$in = input();
$name = trim((string)($in['name'] ?? ''));
$phone = trim((string)($in['phone'] ?? ''));
$email = strtolower(trim((string)($in['email'] ?? '')));
$pass = (string)($in['password'] ?? '');

if ($name === '' || $phone === '' || $email === '' || $pass === '') {
    respond(false, 'Semua kolom wajib diisi.', null, 422);
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    respond(false, 'Format email tidak valid.', null, 422);
}
if (strlen($pass) < 6) {
    respond(false, 'Kata sandi minimal 6 karakter.', null, 422);
}

$pdo = db();
$st = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
$st->execute([$email]);
if ($st->fetch()) {
    respond(false, 'Email sudah terdaftar. Silakan masuk.', null, 409);
}

$token = bin2hex(random_bytes(32));
$st = $pdo->prepare(
    'INSERT INTO users (name, phone, email, password_hash, api_token) VALUES (?, ?, ?, ?, ?)'
);
$st->execute([$name, $phone, $email, password_hash($pass, PASSWORD_DEFAULT), $token]);
$id = (int)$pdo->lastInsertId();

respond(true, 'Akun berhasil dibuat.', [
    'token' => $token,
    'user' => ['id' => $id, 'name' => $name, 'phone' => $phone, 'email' => $email],
], 201);
