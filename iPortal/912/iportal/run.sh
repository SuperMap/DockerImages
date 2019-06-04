#!/bin/bash -e

/opt/init.sh

mkdir -p $Config_PATH && cp $iPortal_PATH/tmp_config/* $Config_PATH -r -n

#deal logs
rm -r -f $iPortal_PATH/logs && \
   mkdir -p $Log_PATH && \
   ln -s $Log_PATH $iPortal_PATH/logs

cd $iPortal_PATH/bin
./catalina.sh run
