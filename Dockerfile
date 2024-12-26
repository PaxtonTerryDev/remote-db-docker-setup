FROM container-registry.oracle.com/database/enterprise:19.3.0.0

# Switch to root user to install dependencies
USER root

# Install dependencies (add curl for yq installation)
RUN yum install -y curl && \
    curl -L https://github.com/mikefarah/yq/releases/download/v4.27.5/yq_linux_amd64 -o /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    yum clean all

# Copy the YAML configuration file into the image
COPY database_config.yaml /config/database_config.yaml

# Read the YAML file and set environment variables
RUN export DB_USER=$(yq eval '.db.user' /config/database_config.yaml) && \
    export DB_PASSWORD=$(yq eval '.db.password' /config/database_config.yaml) && \
    export DB_NAME=$(yq eval '.db.name' /config/database_config.yaml) && \
    export DB_PORT=$(yq eval '.db.port' /config/database_config.yaml) && \
    echo -e "DB_USER=$DB_USER\nDB_PASSWORD=$DB_PASSWORD\nDB_NAME=$DB_NAME\nDB_PORT=$DB_PORT" >> /etc/environment

# Switch back to the default Oracle user
USER oracle

# Expose necessary ports
EXPOSE 1521 5500

# Add a startup command (if additional configuration is required)
CMD ["/bin/bash", "-c", "/opt/oracle/runOracle.sh"]
