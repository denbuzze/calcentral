#!/bin/bash
# script to run calcentral

export MAVEN_OPTS="-Xmx512M -XX:MaxPermSize=128M"

if [ -z "$1" ]; then
    echo "Usage: $0 source_root [logfile]"
    exit;
fi

SRC_LOC=$1
cd $SRC_LOC/calcentral
# disable history expansion so password with ! does not cause problems
set +H
mkdir -p logs
mkdir -p properties

INPUT_FILE="$SRC_LOC/.build.cf"
if [ -f $INPUT_FILE ]; then
  POSTGRES_PASSWORD=`awk -F"=" '/^POSTGRES_PASSWORD=/ {print $2}' $INPUT_FILE`
  APPLICATION_HOST=`awk -F"=" '/^APPLICATION_HOST=/ {print $2}' $INPUT_FILE`
else
  POSTGRES_PASSWORD='secret'
  APPLICATION_HOST='http://localhost:8080'
fi

LOG=$2
if [ -z "$2" ]; then
    LOG=$SRC_LOC/calcentral/logs/run.log
fi
LOGIT="tee -a $LOG"

echo "=========================================" | $LOGIT
echo "`date`: CalCentral run started" | $LOGIT

echo | $LOGIT\

echo "`date`: Fetching new sources for CalCentral..." | $LOGIT
git pull >>$LOG 2>&1
echo "Last commit:" | $LOGIT
git log -1 | $LOGIT

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "Updating local configuration files..." | $LOGIT

CONFIG_FILES=`pwd`/properties

# put the config params into customPropsDir properties files
# this overwrites existing files!
echo "runDataSource.password=$POSTGRES_PASSWORD" > $CONFIG_FILES/dataSource.properties
echo "itDataSource.password=$POSTGRES_PASSWORD" >> $CONFIG_FILES/dataSource.properties
echo "casAuthenticationFilter.serverName=$APPLICATION_HOST" > $CONFIG_FILES/server.properties
echo "casValidationFilter.serverName=$APPLICATION_HOST" >> $CONFIG_FILES/server.properties

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "`date`: Stopping CalCentral..." | $LOGIT
mvn -B -e jetty:stop >>$LOG 2>&1 | $LOGIT

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "`date`: Building code..." | $LOGIT
mvn -B -e clean verify >>$LOG 2>&1 | $LOGIT

# initialize the db
echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "Migrating the database..." | $LOGIT
mvn -e flyway:migrate -Dflyway.password=$POSTGRES_PASSWORD | $LOGIT

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "`date`: Starting CalCentral..." | $LOGIT

# actually run the server (in the background)
nohup mvn -e jetty:run -DcustomPropsDir=$CONFIG_FILES >> logs/jetty.log 2>&1 &

# wait 90s for server to get started
sleep 90;

echo | $LOGIT
echo "------------------------------------------" | $LOGIT
echo "`date`: Checking that server is alive..." | $LOGIT
echo "GET $APPLICATION_HOST"
curl -i -stderr /dev/null $APPLICATION_HOST | grep "HTTP/1.1 200 OK" || echo "ERROR: Index page failed to respond 200 OK" | $LOGIT
echo "GET $APPLICATION_HOST/api/user/jane/widgetData"
curl -i -stderr /dev/null $APPLICATION_HOST/api/user/jane/widgetData | grep "HTTP/1.1" || echo "ERROR: widgetData page failed to respond" | $LOGIT

echo | $LOGIT
echo "`date`: Reinstall complete." | $LOGIT