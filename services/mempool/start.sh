#!/bin/ash
set -e

mysqld_safe --datadir='/var/lib/mysql' &

until mysqladmin ping --silent; do
  sleep 1
done

nginx

node <<EOF
const fs = require('fs');

const env = process.env;
const config = {};

for (const [key, value] of Object.entries(env)) {
  if (/^[0-9]+$/.test(value)) {
    config[key] = Number(value);
  } else if (value === 'true') {
    config[key] = true;
  } else if (value === 'false') {
    config[key] = false;
  } else {
    config[key] = value;
  }
}

fs.writeFileSync('/mempool.space/backend/mempool-config.json', JSON.stringify(config, null, 2));
EOF

cd backend
exec node dist/index.js
