module NekoMuchi
  class Base
    def initialize(hostname, config)
      @hostname = hostname
      @config = config
      @klass = {}
    end

    def const(plugin_class)
      require "nekomuchi/plugin/#{plugin_class.to_s.downcase}"
      @klass[plugin_class] ||= NekoMuchi::Plugin.const_get(plugin_class.to_s).new(@hostname, @config)
    end

    def gets!
      results = {}
      @klass.each do |klass_name, object|
        object.close
        result = object.flush_and_return_results
        results[klass_name] = result unless result.empty?
      end
      results
    end
  end
end
