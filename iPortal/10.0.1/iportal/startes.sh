#!/bin/sh

CUR_DIR_TEMP=$(dirname $(readlink -f "$0"))
if [ ! -n "$ESDATADIR" ]
then
        ESDATADIR=$CUR_DIR_TEMP/../data/elasticsearch/data
fi
if [ ! -n "$ESLOGSDIR" ]
then
        ESLOGSDIR=$CUR_DIR_TEMP/../data/elasticsearch/logs
fi
ESNODENAME="node1"
ESClUSTERNAME="myapplication"
ESHTTPPORT="9210"
ESTCPPORT="9310"
su - supermap <<EOF
export JAVA_HOME=$CUR_DIR_TEMP/../support/jre
export PATH="$JAVA_HOME/bin:$PATH"
$CUR_DIR_TEMP/../database/elasticsearch/bin/elasticsearch -Epath.data="$ESDATADIR" -Epath.logs="$ESLOGSDIR" -Ecluster.name="$ESClUSTERNAME" -Enode.name="$ESNODENAME" -Ehttp.port="$ESHTTPPORT" -Etransport.tcp.port="$ESTCPPORT" -Enetwork.host=127.0.0.1 -p espid -d
EOF
