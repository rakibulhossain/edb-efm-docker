#!/bin/bash

set -ex

# Install dependencies
apt-get update && \
apt-get install -y sudo debian-keyring debian-archive-keyring lsb-release curl gpg acl gnupg2 apt-transport-https vim openjdk-17-jre-headless ssh locales &&\
rm -rf /var/lib/apt/lists/*

#apt-get update && apt-get install -y tini

apt-get update && apt-get install -y iproute2 net-tools ethtool dnsutils iputils-ping traceroute nmap tcpdump socat bridge-utils wireless-tools iw curl wget

EDB_SUBSCRIPTION_TOKEN=8JTvXwdq9wXhE8hKxc5fgIA9FG3nGoDg
EDB_REPO=enterprise

#keyring_location=/usr/share/keyrings/enterprisedb-enterprise-archive-keyring.gpg
#curl -1sSLf "https://downloads.enterprisedb.com/8JTvXwdq9wXhE8hKxc5fgIA9FG3nGoDg/$EDB_REPO/gpg.E71EB0829F1EF813.key" |  gpg --dearmor > ${keyring_location}
#curl -1sSLf "https://downloads.enterprisedb.com/8JTvXwdq9wXhE8hKxc5fgIA9FG3nGoDg/$EDB_REPO/config.deb.txt?distro=debian&codename=" > /etc/apt/sources.list.d/enterprisedb-enterprise.list

curl -1sSLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/$EDB_REPO/setup.deb.sh" | sudo -E bash


sudo groupadd --gid 999 postgres
sudo useradd --uid 999 --gid 999 --shell /bin/bash postgres

sudo echo "LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8" >> /etc/default/locale
sudo echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

sudo dpkg-reconfigure locales -f noninteractive
sudo locale-gen


# Import the repository signing key:
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

# Create the repository configuration file:
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

# Update the package lists:
sudo apt update

# Install the latest version of PostgreSQL:
# If you want a specific version, use 'postgresql-17' or similar instead of 'postgresql'
sudo apt -y install postgresql-16 postgresql-client-16 postgresql-server-dev-16

rm -rf /var/lib/postgresql
rm -rf /var/run/postgresql

apt-get update
apt-cache search enterprisedb
apt-get install -y edb-efm50
