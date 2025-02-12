#!/bin/bash

# Update OS with the latest patches
sudo yum update -y

# Set Repository and install dependencies
sudo amazon-linux-extras enable java-openjdk11
sudo yum install java-11-openjdk java-11-openjdk-devel git maven wget -y

# Download and extract Tomcat package
cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz

# Add Tomcat user and set up Tomcat home directory
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
sudo mkdir -p /usr/local/tomcat
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
sudo chown -R tomcat:tomcat /usr/local/tomcat

# Create systemd service for Tomcat
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOL
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd files and start Tomcat
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

# *Important note* 
### Allows access to Tomcat on port 8080 on The AWS Security Group ###

# Download source code and build project
cd /home/ec2-user
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# Update application.properties with backend server details (this can be modified based on your configuration)
# Replace 'vim' with 'sed' if automatic changes are needed in future
vim src/main/resources/application.properties

# Build the project
mvn install

# Deploy the WAR file to Tomcat
sudo systemctl stop tomcat
sudo rm -rf /usr/local/tomcat/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo systemctl start tomcat
sudo chown -R tomcat:tomcat /usr/local/tomcat/webapps
sudo systemctl restart tomcat
echo "Tomcat setup completed."

#-------------------------------MariaDB_Setup--------------------------------------#
#!/bin/bash

# Update OS with the latest patches
sudo yum update -y

# Install git and MariaDB from the repository
sudo yum install -y git mariadb mariadb-server

# Start and enable mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation manually
sudo mysql -u root <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('admin123');
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

# Set up the database and users
sudo mysql -u root -padmin123 <<MYSQL_SCRIPT
CREATE DATABASE accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Clone the vProfile project and initialize the database
cd /home/ec2-user
[ -d vprofile-project ] && rm -rf vprofile-project
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Restart mariadb-server
sudo systemctl restart mariadb

echo "MariaDB setup completed and database initialized."
