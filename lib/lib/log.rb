require 'singleton'
class ToolsLog
  include Singleton

  def initialize(options = {})

  end


  # Create a Log file in work area
  #
  #  Sample
  #
  #  ToolsLog.create_log_file 'sample', '/myhome/tools/sample.log'
  #  log = ToolsUtil.get_variable "sample_logger" => Logger Object
  #
  #  ToolsLog.create_log_file 'xyko', '/home/francisco/2018/xykotools/tools/xyko.log'
  #  ToolsLog.xyko_info 'teste do methodo1', :light_yellow
  #  ToolsLog.xyko_warn 'teste do methodo2'
  #  ToolsLog.xyko_error 'teste do methodo3'
  #  ToolsLog.xyko_debug 'teste do methodo4'
  #
  # @param logname
  # @param logfile
  # @return
  def self.create_log_file log_name, log_file
    if File.exists? log_file
      unless File.ctime(log_file).to_date == Time.now.to_date
        File.delete(log_file)
      end
    end
    ToolsUtil.set_variable "#{log_name}_log_file", log_file
    ToolsUtil.set_variable "#{log_name}_logger", Logger.new(log_file, 'daily')
    (ToolsUtil.get_variable "#{log_name}_logger").formatter = proc do |severity, datetime, progname, msg|
      "#{severity.chars.first} #{datetime.strftime "%H:%M:%S"}: #{msg}\n"
    end
    #ToolsUtil.purge_files Tools.home+'/.tools/backup', '*', 14*24*60*60
  end

  def self.method_missing(method, *args, &block)
    #expected call format =>    STRING_LOGGER_TYPE + '_' + LOGGER_TYPE
    # Ex.:  tools_info
    logger_name   = method.to_s.split('_').first
    logger_method = method.to_s.split('_').last
    logger        = ToolsUtil.get_variable "#{logger_name}_logger"
    color         = args.extract_color
    if color.eql? :default
      case logger_method
        when 'info'
          color = :cyan
        when 'warn'
          color = :yellow
        when 'debug'
          color = :green
        when 'error'
          color = :light_red
        when 'exit'
          log_file =  ToolsUtil.get_variable "#{logger_name}_log_file"
          ToolsDisplay.show "\tError in ToolsUtil. See details in '#{log_file}'", :light_yellow
          exit
      end
    end
    logger.method(logger_method).call args.first.colorize(color)
  end

end