require 'nekomuchi/plugin/redhat'

class NekoMuchi::Plugin::AmazonLinux < NekoMuchi::Plugin::RedHat
  def os_version
    ssh('cat /etc/system-release').chomp
  end
end
