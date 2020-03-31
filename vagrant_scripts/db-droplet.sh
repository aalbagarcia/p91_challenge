killall apt apt-get
DEBIAN_FRONTEND=noninteractive
apt update
apt upgrade -y

curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
apt-get update

apt-get install -y postgresql-12

