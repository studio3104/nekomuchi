require 'nekomuchi/plugin/base'
require 'nekomuchi/connector/ssh'
require 'nekomuchi/connector/mysql'


class NekoMuchi::Plugin::MySQL < NekoMuchi::Plugin::Base
  include NekoMuchi::Connector::SSH
  include NekoMuchi::Connector::MySQL

  def databases
    client.xquery('SHOW DATABASES')
  end

  def tables(database: nil)
    _databases = case database
                 when Array
                   database
                 when String
                   [database]
                 else
                   databases
                 end

    _databases.each do |db|
      client.xquery('use ?', db)
      client.xquery('SHOW TABLES')
    end
  end

  private

  def client
  end
end
