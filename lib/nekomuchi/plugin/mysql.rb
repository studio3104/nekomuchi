require 'nekomuchi/plugin/base'
require 'nekomuchi/helper/ssh'
require 'nekomuchi/helper/mysql'

class NekoMuchi::Plugin::MySQL < NekoMuchi::Plugin::Base
  include NekoMuchi::Helper::SSH
  include NekoMuchi::Helper::MySQL

  def databases
    mysql('SHOW DATABASES').map { |r| r.values }.flatten
  end

  def tables(database: nil)
    databases = case database
                 when Array
                   database
                 when String
                   [database]
                 else
                   databases()
                 end

    result = {}
    databases.each do |db|
      mysql("use #{db}")
      result[db.to_sym] = mysql('SHOW TABLES').map { |r| r.values }.flatten
    end
    result
  end

  def variables(like: nil, global: false)
    query = global ? 'SHOW GLOBAL VARIABLES' : 'SHOW VARIABLES'
    query = if like
              validate_sql(like)
              "#{query} LIKE '#{like}'"
            else
              query
            end

    result = {}
    mysql(query).each do |row|
      result[row['Variable_name']] = row['Value']
    end
    result
  end
end
