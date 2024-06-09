#!/bin/bash

# Variables
mongo_user="user_mydb"
mongo_admin="user_admin"
mongo_db="mydb"
mongo_pwd=${MONGO_PWD}
istoday=$(date +"%d/%b/%Y")

if [ -z "$mongo_pwd" ]; then
  echo "Error: MONGO_PWD is not set..."
  exit 1
fi

sudo apt update

sudo apt install -y gnupg curl

# Repo MongoDB v.7
sudo curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update

sudo apt install -y mongodb-org

sudo systemctl enable mongod

sudo systemctl start mongod

ATTEMPTS_MAX=2
SECS=5
ATTEMPTS=0

while true; do
  logger "Waiting for mongoDB to respond..."
  sleep $SECS
  ((ATTEMPTS++))

  if systemctl is-active --quiet mongod || [ $ATTEMPTS -ge $ATTEMPTS_MAX ]; then
    logger "MongoDB is active"
    break
  fi
done

# Create an administrator user in MongoDB
mongosh <<EOF
use admin
db.createUser(
  {
    user: "$mongo_admin",
    pwd: "$mongo_pwd",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
)
exit
EOF

# Create Database, User and Collection in MongoDB
mongosh --username "$mongo_admin" --password "$mongo_pwd" --authenticationDatabase admin <<EOF
use $mongo_db
db.createCollection("messages")
db.messages.insertOne({ msg: "Hello Oswaldo Solano", date: "$istoday" })
db.createUser({
  user: "$mongo_user",
  pwd: "$mongo_pwd",
  roles: [{ role: "readWrite", db: "$mongo_db" }]
})
exit
EOF

# Allow access to the database from the web server by modifying the MongoDB configuration
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/" /etc/mongod.conf

# Enabling access security by modifying the MongoDB configuration
sudo sed -i 's/#security:/security:\n  authorization: enabled/' /etc/mongod.conf

sudo systemctl restart mongod

sudo shutdown -r now

logger "MongoDB server installation and configuration completed successfully."
