UNIQUE_ID = [*('A'..'Z')].sample(8).join
VAGRANT_TOKEN = ""
NODES = 3

Vagrant.configure(2) do |config|
  (1..NODES).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}.example.com"
      node.vm.provision "shell", path: "scripts/provision_cassandra.sh", args: "#{UNIQUE_ID}"
    
      node.vm.provider :digital_ocean do |provider, override|
        override.ssh.private_key_path = 'id_rsa'
        override.vm.box = 'digital_ocean'
        override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
        provider.token = "#{VAGRANT_TOKEN}"
        provider.private_networking = true
        provider.image = "ubuntu-14-04-x64"
        provider.region = "nyc2"
        provider.size = "1gb"
      end
    end
  end
end
