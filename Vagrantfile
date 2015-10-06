Vagrant.configure 2 do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.50.33"

  config.vm.provision "shell", inline: <<-SCRIPT
apt-get update
apt-get upgrade -y

apt-get install openjdk-7-jdk -y

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install jenkins -y
  SCRIPT
end
