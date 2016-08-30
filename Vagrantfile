Vagrant.configure 2 do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.network 'private_network', ip: '192.168.50.33'

  config.vm.provision 'shell', inline: <<EOF
set -ex

JENKINS_VERSION=1.658

apt-get update

curl -sL \
  -o /tmp/jenkins_${JENKINS_VERSION}_all.deb \
  http://pkg.jenkins-ci.org/debian/binary/jenkins_${JENKINS_VERSION}_all.deb

apt-get install openjdk-7-jre-headless daemon -y
dpkg -i /tmp/jenkins_${JENKINS_VERSION}_all.deb

EOF
end
