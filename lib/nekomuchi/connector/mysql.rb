require 'mysql2-cs-bind'

module NekoMuchi
  module Connector
    module MySQK
      def mysql_connection_active?
#        @connection[:mysql] && !@connection[:mysql].closed?
      end

      def mysql_connection_close
#        @connection[:mysql].close if mysql_connection_active?
      end

      private

      def mysql_client
        if mysql_connection_active?
          @connection[:mysql]
        else
          @connection[:mysql] = hogehoge
        end
      end
    end
  end
end
