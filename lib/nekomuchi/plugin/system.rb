require 'nekomuchi/plugin/base'
require 'nekomuchi/helper/ssh'
require 'bigdecimal'

class NekoMuchi::Plugin::System < NekoMuchi::Plugin::Base
  include NekoMuchi::Helper::SSH

  def os_version
    ssh('cat /etc/redhat-release').chomp
  end

  def arch
    ssh('uname -m').chomp
  end

  def memory(command_result: nil, unit: 'kB') #command_result for test
    command_result = command_result ? command_result : ssh('cat /proc/meminfo')
    memory = {}

    command_result.each_line do |line|
      line = line.chomp
      key, value = line.split(/\:\s+/)

      value = value.sub(' kB', '').to_f
      value = case unit.upcase
              when 'GB'
                value / 1024.0 / 1024.0
              when 'MB'
                value / 1024.0
              when 'KB'
                value
              else
                raise #!!atode!! 例外クラスとかちゃんと決めてから
              end

      memory[key.to_sym] = sprintf('%.2f', BigDecimal(value.to_s).floor(2)).to_f
    end

    memory
  end

  def cpu
    cpu = []
    cpu_core_number = 0

    ssh('cat /proc/cpuinfo').each_line do |line|
      line = line.strip
      next if line.match(/^$/)

      key, value = line.split(/\s*?\:\s/)
      key = key.gsub(/\s+/, '_')
      value = case value
              when /^\d+$/
                value.to_i
              when /^\d+\.\d+$/
                value.to_f
              when nil
                nil
              else
                value.gsub(/\s+/, "\s").strip
              end

      cpu_core_number = value if key == 'processor'
      cpu[cpu_core_number] ||= {}
      cpu[cpu_core_number][key.to_sym] = value
    end

    cpu
  end
end
