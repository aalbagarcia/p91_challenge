killall apt apt-get
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get upgrade -y
echo "AQUI"
apt-get install -y openjdk-8-jre
apt-get install -y jenkins
apt-get install -y docker
echo "####################################"
echo "Waiting for jenkins installation password..."
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do sleep 1; done
echo "The jenkins installation password id: "
cat /var/lib/jenkins/secrets/initialAdminPassword
echo Accede a http://`hostname -I |cut -d " " -f 1`:8080 para terminar la instalación de jenkins
echo "\n\n"
echo "####################################"
