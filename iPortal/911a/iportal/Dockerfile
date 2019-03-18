FROM supermap/iportal_base:911
MAINTAINER wangyangyang@supermap.com

ENV Config_PATH=/opt/iportalOPTs
ENV Log_PATH=$Config_PATH/logs
ENV iPortal_PATH=/opt/SuperMapiPortal
ENV IPORTAL_VERSION 9.1.1
ENV iPortal true

# Install
ADD ./supermap-iportal-9.1.1a-linux64-deploy.tar.gz /opt
RUN ln -s /opt/supermap-iportal-9.1.1a-linux64-deploy $iPortal_PATH && \
	sed -i '1a JAVA_OPTS="$JAVA_OPTS -Diserver.home=$Config_PATH -Djava.security.egd=file:/dev/./urandom"' $iPortal_PATH/bin/catalina.sh
RUN mkdir -p $iPortal_PATH/tmp_config && \
	mv $iPortal_PATH/webapps/iportal/output $iPortal_PATH/tmp_config && \
	mv $iPortal_PATH/webapps/iportal/WEB-INF $iPortal_PATH/tmp_config && \ 
	mv $iPortal_PATH/webapps/iportal/resources $iPortal_PATH/tmp_config && \
	mkdir -p $iPortal_PATH/webapps/iportal/WEB-INF && \
	mv $iPortal_PATH/tmp_config/WEB-INF/lib $iPortal_PATH/webapps/iportal/WEB-INF && \
	mv $iPortal_PATH/tmp_config/WEB-INF/web.xml $iPortal_PATH/webapps/iportal/WEB-INF 

RUN rm -r -f $iPortal_PATH/logs

# deal server.xml
RUN sed 's#</Host>#\t\t<Context docBase="'"$Config_PATH"'/resources" path="/iportal/resources" />\n\t</Host>#g' $iPortal_PATH/conf/server.xml

WORKDIR /opt/iportalOPTs
VOLUME ["/opt/iportalOPTs"]

ADD run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

CMD /opt/run.sh
