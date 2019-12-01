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
    hash.inject({}){|result, (key, value)|
      new_key = case key
                when String then key.to_sym
                else key
                end
      new_value = case value
                  when Hash then symbolize_keys(value)
                  else value
                  end
      result[new_key] = new_value
      result
    }
  end



  # Test a valid json string.
  #
  # @param  source Json string to be tested
  # @return boolean
  def self.valid_json? source
    begin
      !!JSON.parse(source)
    rescue JSON::ParserError
      false
    end
  end

  # Test a valid yaml string.
  #
  # @param  source Yaml string to be tested
  # @return boolean
  def self.valid_yaml? source
    begin
      !!YAML.parse(source)
    rescue Psych::SyntaxError
      false
    end
  end

  # Return a formated DateTime.
  #
  # @param format with a DateTime format default are: 12 Outubro 2018, 08:29
  # @return [String] formated date
  def self.get_date format='%e %B %Y, %H:%M'
    return I18n.l(DateTime.now, :format => format)
  end


  # Modify the class variable.. String => change value, Hash => merge, Array => insert
  #
  # @param variable name variable
  # @param value    value veriable
  # @return []
  def self.set_variable_ext variable, value
    if self.instance_variable_defined? ("@#{variable}")
      aux = self.get_variable variable
      case aux.class.to_s
      when 'String'
         self.set_variable variable, value
      when 'Hash'
         begin
          aux.merge! value
          self.set_variable variable, aux
        rescue
          ToolsDisplay.show "\tToolsDisplay error [set_variable_ext]. Attempt insert #{variable.class} into Hash variable....".light_red
        end
      when 'Array'
        aux.insert(-1,value)
        self.set_variable variable, aux
      end
    end
  end

  # Set a new class variable.
  #
  # @param variable   variable name to set
  # @param value      value for variable
  # @return []
  def self.set_variable variable, value
    self.instance_variable_set("@#{variable}", value)
  end

  # Get a existent class variable.
  #
  # @param variable   variable name to retrive
  # @return     variable value
  def self.get_variable variable
    return self.instance_variable_get("@#{variable}")
  end

  # Get all existent class variablea.
  #
  # @return     variables
  def self.get_variables
    return self.instance_variables
  end

  # Return a plain text for content of String or Hash or Array.
  #
  # @param   value  Content of variable to translate to Plaint text
  # @return  plain text content
  def self.get_plain_text value
   case value.class.to_s
      when 'String'
        return  "\t#{value.yellow}"
      when 'Hash','Array'
        old_stdout = $stdout
        captured_stdio = StringIO.new('', 'w')
        $stdout = captured_stdio
        ap value, {:plain => true}
        $stdout = old_stdout
        value = captured_stdio.string
        return value
      else
        return value
      end
  end

end