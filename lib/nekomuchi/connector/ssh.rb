require 'net/ssh'

module NekoMuchi
  module Connector
    module SSH
      def ssh_connection_active?
        @connection[:ssh] && !@connection[:ssh].closed?
      end

      def ssh_connection_close
        @connection[:ssh].close if ssh_connection_active?
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

      def ssh_config
        @config[:ssh]
      end

      def start_ssh_client
        Net::SSH.start(@hostname, ssh_config[:username], ssh_config[:options])
      end

      def ssh_client
        if ssh_connection_active?
          @connection[:ssh]
        else
          @connection[:ssh] = start_ssh_client
        end
      end
    end
  end
end
