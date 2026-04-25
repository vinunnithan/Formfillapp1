FROM tomcat:9

# Remove default apps (optional but cleaner)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR as ROOT app
COPY webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war
