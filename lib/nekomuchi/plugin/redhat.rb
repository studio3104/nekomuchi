require 'nekomuchi/plugin/system'

class NekoMuchi::Plugin::RedHat < NekoMuchi::Plugin::System
  def os_version
    ssh('cat /etc/redhat-release').chomp
  end
end
