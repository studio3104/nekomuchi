require 'mysql2-cs-bind'

module NekoMuchi
  class InvalidBindVariableError < StandardError; end
  module Helper
    module MySQL
      def mysql_connection_active?
        @connection[:mysql] && @connection[:mysql].ping
      end

      def mysql_connection_close
        @connection[:mysql].close if mysql_connection_active?
      end

      def validate_sql(*components)
        invalids = components.select { |c| !c.match(/\A[0-9a-zA-Z_-]+\z/) }
        raise NekoMuchi::InvalidBindVariableError, "invalid bind variable - #{invalids}" unless invalids.empty?
        return true
      end
      private

      def mysql(query, *bind_variables)
        if bind_variables.empty?
          mysql_client.xquery(query)
        else
          mysql_client.xquery(query, bind_variables)
        end
      end

      def mysql_config
        @config[:mysql]
      end

      def mysql_client
        if mysql_connection_active?
          @connection[:mysql]
        else
          @connection[:mysql] = Mysql2::Client.new({
            host: @hostname, port: mysql_config[:port],
            username: mysql_config[:username],
            password: mysql_config[:password],
          })
        end
      end
    end
  end
end
