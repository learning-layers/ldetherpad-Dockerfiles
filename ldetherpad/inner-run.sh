#!/bin/bash

cd /opt/etherpad-lite

#replace APIKEY.txt content with config fields
sed -i "s#LDETH_API_KEY#${LDETH_API_KEY}#g" /opt/etherpad-lite/APIKEY.txt

#replace settings.json config fields
sed -i "s#LDETH_ADMIN_PASSWORD#${LDETH_ADMIN_PASSWORD}#g" /opt/etherpad-lite/settings.json
sed -i "s#LDETH_MYSQL_DB_NAME#${LDETH_MYSQL_DB_NAME}#g" /opt/etherpad-lite/settings.json
sed -i "s#\"LDETH_PORT\"#${LDETH_PORT}#g" /opt/etherpad-lite/settings.json
# configure db connection
sed -i "s#MYSQL_ENV_MYSQL_USER#${MYSQL_ENV_MYSQL_USER}#g" /opt/etherpad-lite/settings.json
sed -i "s#MYSQL_PORT_3306_TCP_ADDR#${MYSQL_PORT_3306_TCP_ADDR}#g" /opt/etherpad-lite/settings.json
sed -i "s#MYSQL_ENV_MYSQL_PASS#${MYSQL_ENV_MYSQL_PASS}#g" /opt/etherpad-lite/settings.json

#overwrite templates
sudo echo "BEGIN Replacing templates"
file="/tmp/templates/index.html"
if [ -f "$file" ]
then
  sudo rm -r /opt/etherpad-lite/node_modules/ep_etherpad-lite/templates/*
	mv /tmp/templates/* /opt/etherpad-lite/node_modules/ep_etherpad-lite/templates
fi
sudo echo "END Replacing templates"

#overwrite LDS_SERVER placeholders in the updatetime module
sudo echo "BEGIN Changing placeholders in ep_ldocs_updatetime/ep_ldocs_updatetime.js"
sed -i "s#LDS_SERVER_PROTOCOL#${LDS_API_PROTOCOL}#g" /opt/etherpad-lite/node_modules/ep_ldocs_updatetime/ep_ldocs_updatetime.js
sed -i "s#LDS_SERVER_URL#${LDS_API_ENDPOINT}#g" /opt/etherpad-lite/node_modules/ep_ldocs_updatetime/ep_ldocs_updatetime.js
sed -i "s#LDS_SERVER_PORT#${LDS_API_PORT}#g" /opt/etherpad-lite/node_modules/ep_ldocs_updatetime/ep_ldocs_updatetime.js
sudo echo "END Changing placeholders in ep_ldocs_updatetime/ep_ldocs_updatetime.js"

#create the database if not already present
sudo echo "BEGIN Setting up the database"
sudo mysql --host=$MYSQL_PORT_3306_TCP_ADDR --port=$MYSQL_PORT_3306_TCP_PORT -u $MYSQL_ENV_MYSQL_USER -p$MYSQL_ENV_MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS etherpad CHARACTER SET utf8 COLLATE utf8_bin;"
sudo echo "END Setting up the database"

#start etherpad
sudo echo "Starting the server..."
#while [ true ]
#do
#    sleep 10
#done

sudo bin/run.sh --root