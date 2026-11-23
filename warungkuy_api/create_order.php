<?php
require __DIR__ . '/config.php';
require_method('POST');

$user = current_user();
$in = input();

$items = $in['items'] ?? [];
$delivery = !empty($in['delivery']);
$payment = (string)($in['payment'] ?? '');
$address = trim((string)($in['address'] ?? ''));

if (!is_array($items) || count($items) === 0) {
    respond(false, 'Keranjang masih kosong.', null, 422);
}
if (!in_array($payment, ['COD', 'Transfer Bank', 'E-Wallet'], true)) {
    respond(false, 'Metode pembayaran tidak valid.', null, 422);
}
if ($delivery && $address === '') {
    respond(false, 'Alamat pengiriman wajib diisi.', null, 422);
}

$clean = [];
$subtotal = 0;
foreach ($items as $it) {
    $name = trim((string)($it['name'] ?? ''));
    $qty = (int)($it['qty'] ?? 0);
    $price = (int)($it['price'] ?? -1);
    $extras = trim((string)($it['extras'] ?? ''));
    if ($name === '' || $qty < 1 || $qty > 99 || $price < 0) {
        respond(false, 'Data item pesanan tidak valid.', null, 422);
    }
    $clean[] = ['name' => $name, 'qty' => $qty, 'price' => $price, 'extras' => $extras];
    $subtotal += $price * $qty;
}

$ongkir = $delivery ? 5000 : 0;
$total = $subtotal + $ongkir;
$address = $delivery ? $address : 'Makan di tempat';

$pdo = db();
$pdo->beginTransaction();
try {
    $st = $pdo->prepare(
        'INSERT INTO orders (user_id, subtotal, ongkir, total, delivery, payment, address, status)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
    );
    $st->execute([$user['id'], $subtotal, $ongkir, $total, $delivery ? 1 : 0, $payment, $address, 'Diterima']);
    $orderId = (int)$pdo->lastInsertId();

    $si = $pdo->prepare('INSERT INTO order_items (order_id, name, qty, price, extras) VALUES (?, ?, ?, ?, ?)');
    foreach ($clean as $c) {
        $si->execute([$orderId, $c['name'], $c['qty'], $c['price'], $c['extras']]);
    }
    $pdo->commit();
} catch (Exception $e) {
    $pdo->rollBack();
    throw $e;
}

$st = $pdo->prepare('SELECT * FROM orders WHERE id = ? LIMIT 1');
$st->execute([$orderId]);
respond(true, 'Pesanan berhasil dibuat.', order_json($pdo, $st->fetch()), 201);
