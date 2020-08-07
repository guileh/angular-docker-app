#!/bin/sh

echo "PROD is ($PROD) ... "
if $PROD; then
    sed -i "s|my-del-url.com.br|my-prod-url.com.br|g" /app/angular-docker-app/*.js
fi

echo "Done!"

echo "Executing supervisord"

/usr/bin/supervisord
