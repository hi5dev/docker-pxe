# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_CONFIG ||= {
  cableconnected1: 'on',
  cpus: 1,
  memory: 512,
  natdnshostresolver1: 'on',
  natdnsproxy1: 'on',
  natnet1: '192.168.56/24',
  nattftpfile1: 'pxelinux.0',
  nattftpserver1: '192.168.56.2',
  boot1: 'net'
}.freeze

# https://docs.vagrantup.com
Vagrant.configure('2') do |config|
  config.vm.box = 'clink15/pxe'
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.provider 'virtualbox' do |vb|
    VM_CONFIG.each { |arg, val| vb.customize ['modifyvm', :id, "--#{arg}", val] }
    vb.gui = true
  end
end
