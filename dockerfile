# Use Maven image to build the application
FROM maven:3.8.1-openjdk-11 as builder

# Copy the project files to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Package the application
RUN mvn clean package -DskipTests

# Use the official Tomcat image as the base image
FROM tomcat:9-jdk11-openjdk

# Remove the default web applications from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the Maven build
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Copy entrypoint script into the image
COPY --from=builder /app/entrypoint.sh /entrypoint.sh

# Expose the port the app runs on
EXPOSE 8080

RUN chmod +x /entrypoint.sh

# Install MySQL client
RUN apt-get update && \
    apt-get install -y default-mysql-client && \
    rm -rf /var/lib/apt/lists/*


# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
