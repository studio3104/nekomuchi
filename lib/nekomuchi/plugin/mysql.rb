require 'mysql2-cs-bind'

class NekoMuchi::Plugin::MySQL < NekoMuchi::Plugin::SSH
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
