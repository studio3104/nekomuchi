module NekoMuchi
  class Base
    def initialize(hostname, config)
      @hostname = hostname
      @config = config
      @klass = {}
    end

    def const(plugin_class)
      construct_plugin(plugin_class)
    end

    def gets!
      results = {}
      @klass.each do |klass_name, object|
        object.close
        results[klass_name] = object.flush_and_return_results
      end
      results
    end

    private

    def construct_plugin(plugin_class)
      require "nekomuchi/plugin/#{plugin_class.to_s.downcase}"

      if @klass[plugin_class]
        if @klass[plugin_class].active?
          return @klass[plugin_class]
        else
          @klass[plugin_class].close
        end
      end

      @klass[plugin_class] = NekoMuchi::Plugin.const_get(plugin_class.to_s).new(@hostname, @config)
    end
  end
end
