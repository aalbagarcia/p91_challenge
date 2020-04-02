# TODO: Create an ansible playlist for this shell script

export DEBIAN_FRONTEND=noninteractive

while [ `pidof -d ',' apt apt-get dpkg` ]
do
  echo "Waiting for apt to finish..."
  sleep 1
done

apt update
apt upgrade -y


# Add Jenkins repositories
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update

# Add docker repositories
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable" > /etc/apt/sources.list.d/docker-ce.list
apt-get update


echo "Installing jenkins..."
apt install -y openjdk-8-jre
apt install -y jenkins

echo "Installing docker..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
apt-get install -y docker-ce docker-ce-cli containerd.io
cp /vagrant/docker.service /usr/lib/systemd/system/docker.service
cp /vagrant/jenkins.daemon.json /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker
usermod -a -G docker jenkins

echo "Installing docker compose..."
sudo curl -s -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "####################################"
echo "Waiting for jenkins installation password..."
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do sleep 1; done
echo "The jenkins installation password id: "
cat /var/lib/jenkins/secrets/initialAdminPassword
echo Go to http://`hostname -I |cut -d " " -f 1`:8080 to finish the instalacion of jenkins
echo "####################################"
