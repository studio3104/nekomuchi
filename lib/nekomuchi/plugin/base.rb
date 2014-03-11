module NekoMuchi
  module Plugin
    class Base
      def initialize(hostname, config)
        @hostname = hostname
        @config = config
        @results = {}
        @connection = {}
      end

      def close
        @connection.each do |type, connection|
          send("#{type}_connection_close")
        end
      end

      def get(method_name, *options)
        @results[method_name] = call_plugin_method(method_name, *options)
        @results[method_name] ? true : false #!!atode!! 再考。プラグインメソッドが何を返すかによる。
      end

      def get!(method_name, *options)
        result = call_plugin_method(method_name, *options)
        close
        result
      end

      def flush_and_return_results
        results = @results.clone
        @results.clear
        results
      end

      private

      def call_plugin_method(method_name, *options)
        if options.empty?
          send(method_name.to_s)
        else
          send(method_name.to_s, *options)
        end
      end
    end
  end
end
