conf.vm.define :demo do |node|
  machine_fullstack_vm node, host: 'demo'
  
  conf.vm.synced_folder BASE_DIR + '/etc/conf.d/demo.etc', REMOTE_BASE + '/etc', type: 'rsync'
  
  node.vm.provision :shell, run: 'always' do |conf|
    conf.name = 'copy files'
    conf.inline = "
      rsync -a #{REMOTE_BASE}/etc/www/ /var/www/
      chown -R apache:apache /var/www/
      
      test -f #{REMOTE_BASE}/etc/n98-magerun.yaml && cp #{REMOTE_BASE}/etc/n98-magerun.yaml ~/.n98-magerun.yaml
    "
  end
  
  install_magento2 node, host: 'demo', database: 'magento2_ce', path: 'v2/base'
  install_magento2 node, host: 'demo', database: 'magento2_ee', path: 'v2/enterprise', enterprise: true
  
  install_magento1 node, host: 'demo', database: 'magento1_ce', path: 'v1/base', version_name: 'magento-mirror-1.9.2.2'
  install_magento1 node, host: 'demo', database: 'magento1_ee', path: 'v1/enterprise', version_name: 'enterprise-1.14.2.2'
end
