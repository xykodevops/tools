require 'singleton'
class ToolsConfig
  include Singleton

  def initialize(options = {})
  end



  # Create a Config file in work area
  #
  #  Sample
  #
  #  ToolsConfig.create_config_file 'sample', '/myhome/tools/sample.log'
  #  log = ToolsUtil.get_variable "sample_config" => Logger Object
  #
  #  ToolsConfig.create_log_file 'xyko', '/home/francisco/2018/xykotools/tools/xyko.config'
  #  config = ToolsConfig.xyko_load
  #  ToolsConfig.xyko_add {}
  #
  # @param logname
  # @param logfile
  # @return
  def self.create_config_file config_name, config_file, config_type = :json, data = {}
    unless File.exists? config_file
      case config_type
      when :json
        config = File.open(config_file, 'w')
        #data = {}
        ap data
        config.write JSON.pretty_generate(data)
        config.close
        ToolsLog.tools_info "Json config file '#{config_file}' was created!'"
        return true
      when :yaml
      end
    else
      ToolsLog.tools_warn "The file #{config_file} really exist. leaving operation...."
    end
    ToolsUtil.set_variable "#{config_name}_config_file", config_file
    ToolsUtil.set_variable "#{config_name}_config_type", config_type
  end


  def self.method_missing(method, *args, &block)
    #expected call format =>    STRING_LOGGER_TYPE + '_' + LOGGER_TYPE
    # Ex.:  tools_info
    config_name   = method.to_s.split('_').first
    config_method = method.to_s.split('_').last
    config_file   = ToolsUtil.get_variable "#{config_name}_config_file"
    config_type   = ToolsUtil.get_variable "#{config_name}_config_type"


  end




  # Create a config file in work area
  #
  # @param arguments
  # @return
  def self.create_config_file_old *arguments
    directory = arguments.extract_first
    file_name = arguments.extract_first

    if arguments.extract_symbol :json
      config_type = :json
    else
      if arguments.extract_symbol :yaml
        config_type = :yaml
      else
        config_type = :default
      end
    end
    config_type = :json if config_type.eql? :default
    ToolsLog.tools_info "Setting config_type to '#{config_type}!'"
    ToolsUtil.set_variable 'config_file_type', config_type

    unless File.exists? directory
     ToolsLog.tools_error "Invalid directory in new config file in '#{directory}'.", :light_red
     ToolsLog.tools_exit
    end
    unless directory.end_with? '/'
      directory += '/'
    end
    config_file_location = directory + file_name
    ToolsUtil.set_variable 'config_file_location', config_file_location
    ToolsLog.tools_info "Setting config_file_location to '#{config_file_location}!'"

    unless File.exists? config_file_location
      case config_type
      when :json
        config_file = File.open(config_file_location, 'w')
        config = {}
        config_file.write JSON.pretty_generate(config)
        config_file.close
        ToolsLog.tools_info "Json config file created!'"
        return true
      when :yaml
      end
    else
      ToolsLog.tools_warn "The file #{config_file_location} really exist. leaving operation...."
    end

  end

  # Test and register a config file in work area
  # @param source
  # @return boolean
  def self.test_config_type source
    file        = open(source)
    content     = file.read
    if ToolsUtil.valid_json? content
      config_type = :json
    else
      if ToolsUtil.valid_yaml? content
        config_type = :yaml
      else
        config_type = :invalid
        ToolsLog.tools_error "Invalid format in config file in '#{source}'.", :light_red
        ToolsLog.tools_exit
      end
    end
    ToolsUtil.set_variable 'config_file_type', config_type
  end


  # Load a content from a config file in work area
  # @param source
  # @return content
  def self.load_config source
    test_config_type source
    case ToolsUtil.get_variable 'config_file_type'
    when :json
      file    = open(source)
      json    = file.read
      parsed  = JSON.parse(json)
      ToolsUtil.set_variable 'config_data', parsed
      return parsed
    when :yaml
    end
  end

  # Merge data in config file in work area
  # @param source
  # @return content
  def self.insert_in_config source, command
    test_config_type source
    case ToolsUtil.get_variable 'config_file_type'
    when :json
      file = open(source)
      json = file.read
      parsed = JSON.parse(json)
      parsed.rmerge!(command)
      file.close
      file = open(source, 'w')
      file.write JSON.pretty_generate(parsed)
      file.close
    when :yaml
    end
  end

  # Change data in config file in work area
  # @param source
  # @param value
  # @param args. Sequence keys to locate the value in hash
  def self.change_value_in_config *args
    source = args.extract_first
    value  = args.extract_first
    test_config_type source
    case ToolsUtil.get_variable 'config_file_type'
    when :json
      file = open(source)
      json = file.read
      parsed = JSON.parse(json)
      parsed.nested_set(args, value)
      file.close
      file = open(source, 'w')
      file.write JSON.pretty_generate(parsed)
      file.close
    when :yaml
    end
  end


  def self.validate_config
#    ToolsLog.info "\t\tValidanting config file in #{Tools.home+'/.tools/config'}."
    # ToolsConfig.daily_backup_config
    # ToolsConfig.purge_backup_config
    # file   = open(Cmdapi.home+'/.tools/config')
    # config = file.read
    # begin
    #   JSON.parse(config)
    #   return true
    # rescue Exception => e
    #   CMDAPIUtil.show_info "\tInvalid JSON config file in #{Cmdapi.home+'/.tools/config'}."
    #   CMDAPIUtil.show_info "\t Follow the instructions below to fix the problem."
    #   CMDAPIUtil.show_info "\t  1. Rename the config file #{Cmdapi.home+'/.tools/config'}."
    #   CMDAPIUtil.show_info "\t  2. Cmdapi run again. The cmdapi will create a new configuration file."
    #   CMDAPIUtil.show_info "\t  3. Copy the keys from the previous file to the new file."
    #   CMDAPIUtil.show_info "\t  4. Run cmdapi again.."
    #   CMDAPIUtil.show_info "\t Aborting operation...."
    #   exit
    # end
  end

  def self.check_config
#    ToolsLog.info "\t\tChecking config file: #{Tools.home+'/.tools/config'}."
    # file = open(Tools.home+'/.tools/config')
    # json = file.read
    # parsed = JSON.parse(json)
    # file.close
  end

  def self.purge_backup_config   # execupa o purge de todos os backup com mais de 14 dias
#    ToolsLog.info "\t\tPurge backup config file: #{Tools.home+'/.tools/config'}."
    #  to_clean = Dir.glob(File.join(Tools.home+'/.tools/backup', '*')).select { |a|
    #   Time.now - File.ctime(a) > 14*24*60*60 }
    #  to_clean.each do |file_to_delete|
    #   File.delete(file_to_delete)
    # end
  end

  def self.config_backup
#    ToolsLog.info "\t\tBackuping config file in #{Tools.home+'/.tools/backup'}."
  #   FileUtils.cp Tools.home+'/.tools/config',
  #                Tolls.home+'/.tools/backup/config_' +
  #                (ToolsUtil.get_date '%Y%m%d-%H%M') + '.backup'
  end

  def self.daily_backup_config
#     #captura o backup mais recente
#     least = Dir.glob(File.join(Cmdapi.home+'/.cmdapi3/backup', 'config*.backup')).max { |a,b| File.ctime(a) <=> File.ctime(b) }
#     unless least.nil?
#       #se não houver sido feito hoje
#       unless File.ctime(least).to_date == Time.now.to_date
# #        ToolsLog.info "\t\tStarting config backup."
#         ToolsConfig.config_backup
#       end
#     else
# #      ToolsLog.info "\t\tStarting config backup."
#       ToolsConfig.config_backup
#     end
#     return true
  end


end