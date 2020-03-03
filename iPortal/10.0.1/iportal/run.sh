#!/bin/bash

mkdir -p $Config_PATH $Log_PATH $ESDATADIR $ESLOGSDIR && cp $iPortal_PATH/tmp_config/* $Config_PATH -r -n
#deal logs
rm -r -f $iPortal_PATH/logs && \
   mkdir -p $Log_PATH && \
   ln -s $Log_PATH $iPortal_PATH/logs

/opt/init.sh

chown -R supermap:supermap $Config_PATH /etc/icloud
cd /etc/icloud/SuperMapiPortal/bin
./catalina.sh run
