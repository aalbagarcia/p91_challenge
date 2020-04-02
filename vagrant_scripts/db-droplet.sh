export DEBIAN_FRONTEND=noninteractive

while [ `pidof -s apt apt-get dpkg` ]
do
  echo "Waiting for apt to finish..."
  sleep 1
done

apt update
apt upgrade -y

curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
apt-get update

apt-get install -y postgresql-12

cp /vagrant/postgresql/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf
cp /vagrant/postgresql/conf.d/* /etc/postgresql/12/main/conf.d

systemctl restart postgresql
