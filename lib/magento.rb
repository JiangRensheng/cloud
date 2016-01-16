##
 # Copyright © 2015 by David Alger. All rights reserved
 # 
 # Licensed under the Open Software License 3.0 (OSL-3.0)
 # See included LICENSE file for full text of OSL-3.0
 # 
 # http://davidalger.com/contact/
 ##

def install_magento2 node, host: nil, path: nil, database: nil, enterprise: false, sampledata: true
  host = host + '.' + CLOUD_DOMAIN
  flag_ee = enterprise ? ' -e ' : nil
  flag_sd = sampledata ? ' -d ' : nil
  
  node.vm.provision :shell do |conf|
    conf.name = "install_magento2"
    conf.inline = "
      set -e
      
      export DB_HOST=localhost
      export DB_NAME=#{database}
      export INSTALL_DIR=/var/www/magento2/#{path}
      
      m2setup.sh #{flag_sd} #{flag_ee} --hostname=#{host} --urlpath=#{path}
      
      ln -s $INSTALL_DIR/pub /var/www/html/#{path}
      ln -s $INSTALL_DIR/pub /var/www/html/#{path}/pub     # todo: remove temp fix when GH Issue #2711 is resolved
      
      find $INSTALL_DIR -type d -exec chmod 770 {} +
      find $INSTALL_DIR -type f -exec chmod 660 {} +
      
      chmod -R g+s $INSTALL_DIR
      chown -R apache:apache $INSTALL_DIR
      
      chmod +x $INSTALL_DIR/bin/magento
    "
  end
end

def install_magento1 node, host: nil, path: nil, database: nil, enterprise: false, sampledata: true
  host = host + '.' + CLOUD_DOMAIN
  flag_ee = enterprise ? ' -e ' : nil
  flag_sd = sampledata ? ' -d ' : nil
  
  return # todo: remove after implimenting m1setup.sh script
  
  node.vm.provision :shell do |conf|
    conf.name = "install_magento1"
    conf.inline = "
      set -e
      
      export DB_HOST=localhost
      export DB_NAME=#{database}
      export INSTALL_DIR=/var/www/html/#{path}
      
      m1setup.sh #{flag_sd} #{flag_ee} --hostname=#{host} --urlpath=#{path}
      
      find $INSTALL_DIR -type d -exec chmod 770 {} +
      find $INSTALL_DIR -type f -exec chmod 660 {} +
      
      chmod -R g+s $INSTALL_DIR
      chown -R apache:apache $INSTALL_DIR
      
      chmod +x $INSTALL_DIR/cron.sh
    "
  end
end
