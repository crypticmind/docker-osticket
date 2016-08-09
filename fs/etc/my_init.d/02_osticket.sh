#!/bin/bash

if [ ! -r /config/ost-config.php ]; then
    echo "ERROR: Could not read /config/ost-config.php."
    exit 1
fi

ln -sf /config/ost-config.php /var/www/html/include/ost-config.php

if [ "$OSTICKET_SETUP" = "yes" -o "$OSTICKET_SETUP" = "true" ]; then
    echo "Running in SETUP mode."
    if [ ! -w /var/www/html/include/ost-config.php ]; then
        echo "ERROR: ost-config.php is not writable."
        exit 2
    fi
else
    echo "Running in PRODUCTION mode."
    rm -rf /var/www/html/setup
fi

crontab <<EOF
*/5 * * * * /usr/bin/php /var/www/html/api/cron.php
EOF
