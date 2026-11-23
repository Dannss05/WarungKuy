<?php
require __DIR__ . '/config.php';
require_method('POST');

$in = input();
$email = strtolower(trim((string)($in['email'] ?? '')));
$pass = (string)($in['password'] ?? '');

if ($email === '' || $pass === '') {
    respond(false, 'Email dan kata sandi wajib diisi.', null, 422);
}

$pdo = db();
$st = $pdo->prepare('SELECT id, name, phone, email, password_hash FROM users WHERE email = ? LIMIT 1');
$st->execute([$email]);
$user = $st->fetch();

if (!$user || !password_verify($pass, $user['password_hash'])) {
    respond(false, 'Email atau kata sandi salah.', null, 401);
}

$token = bin2hex(random_bytes(32));
$up = $pdo->prepare('UPDATE users SET api_token = ? WHERE id = ?');
$up->execute([$token, $user['id']]);

respond(true, 'Berhasil masuk.', ['token' => $token, 'user' => user_json($user)]);
