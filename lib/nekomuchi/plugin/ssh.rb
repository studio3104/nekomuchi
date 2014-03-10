require 'nekomuchi/plugin/base'
require 'net/ssh'

class NekoMuchi::Plugin::SSH < NekoMuchi::Plugin::Base
  def connection_active?
    @ssh_client && !@ssh_client.closed?
  end

  def close
    @ssh_client.close if connection_active?
  end

  private

  def ssh_exec(command)
    result = ''

    ssh_client.exec(command) do |channel, stream, data|
      result = stream == :stdout ? data : ''
    end
    ssh_client.loop

    result
  end

  def config
    @config[:ssh]
  end

  def start_ssh_client
    Net::SSH.start(@hostname, config[:username], config[:options])
  end

  def ssh_client
    if connection_active?
      @ssh_client
    else
      @ssh_client = start_ssh_client
    end
  end
end
