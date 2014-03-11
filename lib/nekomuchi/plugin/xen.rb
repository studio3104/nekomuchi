require 'nekomuchi/plugin/system'

class NekoMuchi::Plugin::Xen < NekoMuchi::Plugin::System
  def xm_info(command_result: nil) #command_result for test
    command_result = command_result ? command_result : ssh('xm info')
    result = {}
    command_result.each_line do |line|
      line = line.strip
      key, value = line.split(/\s*\:\s/)
      result[key.to_sym] = value
    end
    result
  end
end
