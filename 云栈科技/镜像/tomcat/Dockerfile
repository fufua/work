FROM docker.nicescale.com/microimages/oraclejdk:8u73
RUN mkdir /usr/local/tomcat
ADD  apache-tomcat-8.5.51.tar.gz /usr/local/tomcat/
RUN mv /usr/local/tomcat/apache-tomcat-8.5.51/* /usr/local/tomcat/
RUN rm -rf /usr/local/tomcat/apache-tomcat-8.5.51
CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
