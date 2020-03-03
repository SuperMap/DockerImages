FROM supermap/iportal_base:10.0.1

ENV Config_PATH=/opt/iportalOPTs
ENV Log_PATH=/opt/iportalOPTs/logs
ENV iPortal_PATH=/etc/icloud/SuperMapiPortal
ENV iPortal=true
ENV iserver_home=$Config_PATH
ENV package_home=$iPortal_PATH
ENV ESDATADIR=$Config_PATH/esdata
ENV ESLOGSDIR=$Config_PATH/eslog
ENV IPORTAL_VERSION 10.0.1

RUN groupadd -r supermap && useradd -g supermap -r --no-log-init supermap
COPY sysctl.conf /etc/sysctl.conf

ADD ./supermap?iportal*.tar.gz /etc/icloud/
RUN ln -s /etc/icloud/supermap?iportal* $iPortal_PATH && \
  sed -i '1a JAVA_OPTS="$JAVA_OPTS -Diserver.home=$Config_PATH -Djava.security.egd=file:/dev/./urandom"' $iPortal_PATH/bin/catalina.sh
COPY startes.sh $iPortal_PATH/bin/startes.sh
RUN mv $iPortal_PATH/webapps/iportal $iPortal_PATH/tmp_config && \
  mkdir -p $iPortal_PATH/webapps/iportal/WEB-INF && \
  mv $iPortal_PATH/tmp_config/WEB-INF/lib \
	$iPortal_PATH/tmp_config/WEB-INF/web.xml \
	$iPortal_PATH/tmp_config/WEB-INF/urlrewrite.xml \
	$iPortal_PATH/webapps/iportal/WEB-INF

RUN sed -i 's#</Host>#\t\t<Context docBase="'"$Config_PATH"'/resources" path="/iportal/resources" />\n\t</Host>#g' $iPortal_PATH/conf/server.xml

WORKDIR /opt/iportalOPTs
VOLUME ["/opt/iportalOPTs"]

ADD run.sh /opt/run.sh
RUN chmod +x /opt/run.sh $iPortal_PATH/bin/startes.sh

CMD /opt/run.sh

