<?php
require __DIR__ . '/config.php';
require_method('POST');

$token = token_from_request();
if ($token !== '') {
    $st = db()->prepare('UPDATE users SET api_token = NULL WHERE api_token = ?');
    $st->execute([$token]);
}
respond(true, 'Berhasil keluar.');
