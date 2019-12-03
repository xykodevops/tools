require 'singleton'
class ToolsUtil
  include Singleton

  # def initialize(options = {})
  #   # I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
  #   # I18n.locale    = 'pt-BR'.to_sym
  #   ToolsCache.instance
  #   ToolsConfig.instance
  #   ToolsConsole.instance
  #   ToolsDisplay.instance
  #   ToolsFiles.instance
  #   ToolsLog.instance
  #   ToolsNet.instance
  #   ToolsPrompt.instance
  #   unless File.exists? Tools.home+'/.tools'
  #     FileUtils.mkdir_p(Tools.home+'/.tools')
  #   end
  #   tools_logfile = Tools.home+'/.tools/tools.log'
  #   ToolsLog.create_log_file 'tools', tools_logfile
  # end

  # Synbolize all keys in hash.
  #
  # @param  hash
  # return  hash symbolized
  def self.symbolize_keys(hash)
    {}.tap do |h|
      hash.each { |key, value| h[key.to_sym] = map_value(value) }
    end
    # hash.each_with_object({}) do |(key, value), result|
    #   new_key = case key
    #             when String then key.to_sym
    #             else key
    #             end
    #   new_value = case value
    #               when Hash then symbolize_keys(value)
    #               else value
    #               end
    #   result[new_key] = new_value
    # end
  end

  def self.map_value(thing)
    case thing
    when Hash
      symbolize_keys(thing)
    when Array
      thing.map { |v| map_value(v) }
    else
      thing
    end
  end

  # Test a valid json string.
  #
  # @param  source Json string to be tested
  # @return boolean
  def self.valid_json?(source)
    JSON.parse(source) && true
  rescue JSON::ParserError
    false
  end

  # Test a valid yaml string.
  #
  # @param  source Yaml string to be tested
  # @return boolean
  def self.valid_yaml?(source)
    YAML.parse(source) && true
  rescue Psych::SyntaxError
    false
  end

  # Return a formated DateTime.
  #
  # @param format with a DateTime format default are: 12 Outubro 2018, 08:29
  # @return [String] formated date
  def self.get_date(format = '%e %B %Y, %H:%M')
    I18n.l(DateTime.now, format: format)
  end

  # Modify the class variable.. String => change value, Hash => merge, Array => insert
  #
  # @param variable name variable
  # @param value    value veriable
  # @return []
  def self.set_variable_ext(variable, value)
    return unless instance_variable_defined? "@#{variable}"

    aux = get_variable variable
    case aux.class.to_s
    when 'String'
      set_string_variable variable, value
    when 'Hash'
      set_hash_variable variable, value, aux
    when 'Array'
      set_array_variable variable, value, aux
    end
  end

  def self.set_string_variable(variable, value)
    set_variable variable, value
  end

  def self.set_hash_variable(variable, value, aux)
    aux.merge! value
    set_variable variable, aux
  rescue StandardError
    ToolsDisplay.show "\tToolsDisplay error [set_variable_ext].".light_red
    ToolsDisplay.show "\tAttempt insert #{variable.class} into Hash variable....".light_red
  end

  def self.set_array_variable(variable, value, aux)
    aux.insert(-1, value)
    set_variable variable, aux
  end

  # Set a new class variable.
  #
  # @param variable   variable name to set
  # @param value      value for variable
  # @return []
  def self.set_variable(variable, value)
    instance_variable_set("@#{variable}", value)
  end

  # Get a existent class variable.
  #
  # @param variable   variable name to retrive
  # @return     variable value
  def self.get_variable(variable)
    instance_variable_get("@#{variable}")
  end

  # Get all existent class variablea.
  #
  # @return     variables
  def self.get_variables
    instance_variables
  end

  # Return a plain text for content of String or Hash or Array.
  #
  # @param   value  Content of variable to translate to Plaint text
  # @return  plain text content
  def self.get_plain_text(value)
    case value
    when String then "\t#{value.yellow}"
    when Hash, Array
      # old_stdout = $stdout
      # captured_stdio = StringIO.new('', 'w')
      #   $stdout = captured_stdio
      #   ap value, plain: true
      # $stdout = old_stdout
      # captured_stdio.string
      get_plain_text_if_hash_or_array value
    else
      value
    end
  end

  def self.get_plain_text_if_hash_or_array(value)
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ap value, plain: true
    $stdout = old_stdout
    captured_stdio.string
  end
end
