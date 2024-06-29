#!/bin/bash

# Use environment variables to set the db and mailer configuration
DB_DRIVER_NAME=${DB_DRIVER_NAME:-com.mysql.cj.jdbc.Driver}
DB_CONNECTION_STRING=${DB_CONNECTION_STRING:-jdbc:mysql://localhost:3306/shopping-cart}
DB_USERNAME=${DB_USERNAME:-root}
DB_PASSWORD=${DB_PASSWORD:-testuser}
MAILER_EMAIL=${MAILER_EMAIL:-aws.course.subhodeep@gmail.com}
MAILER_PASSWORD=${MAILER_PASSWORD:-boymkajnunzbslue}

# Replace the values in the properties file with the environment variable values
sed -i "s|db.driverName = .*|db.driverName = $DB_DRIVER_NAME|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sed -i "s|db.connectionString = .*|db.connectionString = $DB_CONNECTION_STRING|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sed -i "s|db.username = .*|db.username = $DB_USERNAME|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sed -i "s|db.password = .*|db.password = $DB_PASSWORD|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sed -i "s|mailer.email=.*|mailer.email=$MAILER_EMAIL|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties
sed -i "s|mailer.password=.*|mailer.password=$MAILER_PASSWORD|g" /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties

# Start Tomcat
exec catalina.sh run
