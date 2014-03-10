require 'mysql2-cs-bind'

module NekoMuchi
  module Helper
    module MySQL
      def mysql_connection_active?
        @connection[:mysql] && @connection[:mysql].ping
      end

      def mysql_connection_close
        @connection[:mysql].close if mysql_connection_active?
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
