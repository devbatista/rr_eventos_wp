#!/bin/sh
set -eu

if [ ! -f /var/www/html/index.php ]; then
  cp -R /usr/src/wordpress/. /var/www/html/
fi

if [ ! -f /var/www/html/wp-config.php ]; then
  cat > /var/www/html/wp-config.php <<'PHP'
<?php
define('DB_NAME', getenv('MYSQLDATABASE') ?: getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('MYSQLUSER') ?: getenv('WORDPRESS_DB_USER') ?: 'wordpress');
define('DB_PASSWORD', getenv('MYSQLPASSWORD') ?: getenv('WORDPRESS_DB_PASSWORD') ?: 'wordpress_password');
define('DB_HOST', getenv('MYSQLHOST') ?: getenv('WORDPRESS_DB_HOST') ?: 'mysql:3306');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         'put-your-unique-phrase-here');
define('SECURE_AUTH_KEY',  'put-your-unique-phrase-here');
define('LOGGED_IN_KEY',    'put-your-unique-phrase-here');
define('NONCE_KEY',        'put-your-unique-phrase-here');
define('AUTH_SALT',        'put-your-unique-phrase-here');
define('SECURE_AUTH_SALT', 'put-your-unique-phrase-here');
define('LOGGED_IN_SALT',   'put-your-unique-phrase-here');
define('NONCE_SALT',       'put-your-unique-phrase-here');

$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

// Set WordPress URLs to use HTTPS and detect the correct host
if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
  $_SERVER['HTTPS'] = 'on';
}

// Set WordPress URLs to accept multiple domains
$allowed_hosts = [
  'rreventos-production.up.railway.app',
  'admin.rubyrosemaquiagem.com.br'
];

if (!empty($_SERVER['HTTP_HOST'])) {
  $host = $_SERVER['HTTP_HOST'];
  // Use the actual host being accessed
  define('WP_HOME', 'https://' . $host);
  define('WP_SITEURL', 'https://' . $host);
}

define('WP_DEBUG', false);

if (! defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
PHP
fi

chown -R www-data:www-data /var/www/html

exec "$@"
