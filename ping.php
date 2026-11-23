<?php
// Buka http://localhost/warungkuy_api/ping.php untuk mengetes koneksi database.
require __DIR__ . '/config.php';
db()->query('SELECT 1');
respond(true, 'Koneksi database OK. Backend warungkuy siap dipakai.');
