#!/bin/bash
UNIQUE_ID=$1
CLUSTER_NAME="Training Cluster ${UNIQUE_ID}"
EXTERNAL_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address);
INTERNAL_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address);

echo "Adding Internal IP (${INTERNAL_IP}) to discovery service for cluster '${CLUSTER_NAME}'"
curl -s -X POST -H "Content-Type: application/json" -d '{"ip":"'${INTERNAL_IP}'"}' http://www.newtech.academy/cassandra/register/${UNIQUE_ID}
sleep 2
SEED_LIST=$(curl -s http://www.newtech.academy/cassandra/register/${UNIQUE_ID});

echo "setting up swap"
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon -s
echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab

echo "installing Java 8"
add-apt-repository ppa:webupd8team/java -y
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get update
apt-get install -y oracle-java8-installer

echo "Downloading Cassandra"
mkdir -p /opt
cd /opt
wget -q http://www-us.apache.org/dist/cassandra/3.0.14/apache-cassandra-3.0.14-bin.tar.gz
echo "Extracting Cassandra"
tar -xzf apache-cassandra-3.0.14-bin.tar.gz
cd apache-cassandra-3.0.14

echo "initial setup"
groupadd cassandra
useradd -d /opt/cassandra -s /bin/bash -g cassandra cassandra
mkdir -p /var/log/cassandra
chown -R cassandra /var/log/cassandra
mkdir -p /var/lib/cassandra
chown -R cassandra /var/lib/cassandra
chown -R cassandra /opt/apache-cassandra-3.0.14
cat /vagrant/conf/cassandra.yaml | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/" | sed "s/SEED_LIST/${SEED_LIST}/" > /opt/apache-cassandra-3.0.14/conf/cassandra.yaml
su - cassandra -c '/opt/apache-cassandra-3.0.14/bin/cassandra'
