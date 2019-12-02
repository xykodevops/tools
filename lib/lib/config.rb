require 'singleton'
class ToolsConfig
  include Singleton

  def initialize(options = {}); end

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
  # @param config_name
  # @param config_file
  # @param config_type
  # @param data
  # @return
  def self.create_config_file(config_name, config_file, config_type = :json, data = {})
    if File.exist? config_file
      # ToolsLog.tools_warn "The file #{config_file} really exist. leaving operation...."
      return false
    else
      case config_type
      when :json
        config = File.open(config_file, 'w')
        config.write JSON.pretty_generate(data)
        config.close
        # ToolsLog.tools_info "Json config file '#{config_file}' was created!'"
        # return true
      when :yaml
        config = File.open(config_file, 'w')
        config.write data.to_yaml
        config.close
        # ToolsLog.tools_info "Json config file '#{config_file}' was created!'"
        # return true
      end
    end

    ToolsUtil.set_variable "#{config_name}_config_file", config_file
    ToolsUtil.set_variable "#{config_name}_config_type", config_type
  end

  def self.method_missing(method, *_args)
    # expected call format =>    STRING_LOGGER_TYPE + '_' + LOGGER_TYPE
    # Ex.:  tools_info
    config_name   = method.to_s.split('_').first
    config_method = method.to_s.split('_').last
    config_file   = ToolsUtil.get_variable "#{config_name}_config_file"
    config_type   = ToolsUtil.get_variable "#{config_name}_config_type"
  end

  # Test and register a config file in work area
  # @param source
  # @return boolean
  def self.test_config_type(source)
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
  def self.load_config(source)
    test_config_type source
    case ToolsUtil.get_variable 'config_file_type'
    when :json
      file    = open(source)
      json    = file.read
      parsed  = JSON.parse(json)
      ToolsUtil.set_variable 'config_data', parsed
      return parsed
    when :yaml
      file = open(source)
      parsed = YAML.safe_load(file.read)
      ToolsUtil.set_variable 'config_data', parsed
      return parsed
    end
  end

  # Merge data in config file in work area
  # @param source
  # @return content
  def self.insert_in_config(source, command)
    test_config_type source
    file = open(source)
    case ToolsUtil.get_variable 'config_file_type'
    when :json
      json = file.read
      parsed = JSON.parse(json)
      parsed.rmerge!(command)
      file.close
      file = open(source, 'w')
      file.write JSON.pretty_generate(parsed)
      file.close
    when :yaml
      yaml = file.read
      parsed = YAML.safe_load(yaml)
      parsed.rmerge!(command)
      file.close
      file = open(source, 'w')
      file.write parsed.to_yaml
      file.close
    end
  end

  # Change data in config file in work area
  # @param args Sequence keys to locate the value in hash
  def self.change_value_in_config(*args)
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
      file = open(source)
      yaml = file.read
      parsed = YAML.safe_load(yaml)
      parsed.nested_set(args, value)
      file.close
      file = open(source, 'w')
      file.write parsed.to_yaml
      file.close
    end
  end

  def self.validate_config; end

  def self.check_config; end

  def self.purge_backup_config; end

  def self.config_backup; end

  def self.daily_backup_config; end
end
