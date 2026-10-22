# Use the official Tomcat 9 image with Java 11
FROM tomcat:9.0-jdk11-corretto

# Remove the default Tomcat welcome applications (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT \
           /usr/local/tomcat/webapps/docs \
           /usr/local/tomcat/webapps/examples \
           /usr/local/tomcat/webapps/host-manager \
           /usr/local/tomcat/webapps/manager

# Copy the war file into Tomcat's webapps folder
COPY attendance.war /usr/local/tomcat/webapps/attendance.war

# Also deploy as ROOT so the service answers at https://<name>.onrender.com/
# (the lab sheet is inconsistent: the Dockerfile puts the app under
#  /attendance, but Question 1 expects the root URL to work)
COPY attendance.war /usr/local/tomcat/webapps/ROOT.war

# Keep the JVM small so the app also fits low-memory free tiers (256MB/128MB)
ENV JAVA_OPTS="-Xms32m -Xmx96m -XX:MaxMetaspaceSize=64m -Xss256k -XX:+UseSerialGC"

# Use an entry point that adapts the port to Render's PORT variable
COPY entrypoint.sh /usr/local/tomcat/bin/entrypoint.sh
RUN chmod +x /usr/local/tomcat/bin/entrypoint.sh

EXPOSE 8080
CMD ["/usr/local/tomcat/bin/entrypoint.sh"]
