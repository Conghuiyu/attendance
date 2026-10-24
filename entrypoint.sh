#!/bin/bash
# Works on both Render and Deplexo:
#  - Render injects the PORT environment variable, Tomcat defaults
#    to 8080, so patch server.xml when PORT is set to something else.
#  - Deplexo mounts a READ-ONLY container filesystem (only /tmp is
#    writable), but Tomcat needs writable logs/temp/work dirs. So we
#    build a writable CATALINA_BASE under /tmp and point Tomcat at it.

BASE=/tmp/catalina-base
mkdir -p "$BASE/logs" "$BASE/temp" "$BASE/webapps" "$BASE/work"
cp -r /usr/local/tomcat/conf "$BASE/conf"
cp -r /usr/local/tomcat/webapps/. "$BASE/webapps/"

if [ -n "$PORT" ] && [ "$PORT" != "8080" ]; then
  sed -i "s/port=\"8080\"/port=\"$PORT\"/" "$BASE/conf/server.xml"
fi

export CATALINA_BASE="$BASE"
exec /usr/local/tomcat/bin/catalina.sh run
