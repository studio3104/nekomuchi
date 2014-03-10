module NekoMuchi
  module Plugin
    class Base
      def initialize(hostname, config)
        @hostname = hostname
        @config = config
        @results = {}
      end

      def get(method_name, *options)
        @results[method_name] = if options.empty?
                                  send(method_name.to_s)
                                else
                                  send(method_name.to_s, options.first)
                                end

        @results[method_name] ? true : false #!!atode!! 再考。プラグインメソッドが何を返すかによる。
      end

      def get!(method_name, *options)
        result = if options.empty?
                   { method_name => send(method_name.to_s) }
                 else
                   { method_name => send(method_name.to_s, options.first) }
                 end

        close
        result
      end

      def flush_and_return_results
        results = @results.clone
        @results.clear
        results
      end

      def method_missing
        #!!atode!! undefined method なんとかみたいな例外にする
      end
    end
  end
end
