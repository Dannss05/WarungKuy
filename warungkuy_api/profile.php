<?php
require __DIR__ . '/config.php';
require_method('GET');

$user = current_user();
respond(true, 'OK', user_json($user));
