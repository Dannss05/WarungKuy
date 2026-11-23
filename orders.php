<?php
require __DIR__ . '/config.php';
require_method('GET');

$user = current_user();
$pdo = db();
$st = $pdo->prepare('SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC LIMIT 100');
$st->execute([$user['id']]);

$list = [];
foreach ($st->fetchAll() as $o) {
    $list[] = order_json($pdo, $o);
}
respond(true, 'OK', $list);
