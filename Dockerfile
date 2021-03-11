# Pull base image 
FROM tomcat:8-jre8

#Copy webapp.war to container
COPY ./webapp.war /usr/local/tomcat/webapps

RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps