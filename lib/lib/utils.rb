require 'singleton'
class ToolsUtil
  include Singleton

  def initialize(options = {})
    I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
    I18n.locale    = 'pt-BR'.to_sym
    ToolsDisplay.instance
    ToolsFiles.instance
    ToolsConfig.instance
    ToolsLog.instance
    ToolsPrompt.instance
    tools_logfile = Tools.home+'/.tools/tools.log'
    ToolsLog.create_log_file 'tools', tools_logfile
  end


  # Capture string from a prompt.
  #
  # @param  prompt
  # @param  hidden option
  # @return String
  def self.ask_prompt(prompt = '', hidden = true)
    if hidden
      a = ask("#{prompt}") { |q| q.echo = "*"; } #q.case = :downcase }
    else
      a = ask("#{prompt}") #{ |q| q.case = :downcase }
    end
  end

  # Test a valid json string.
  #
  # @param  Json string to be tested
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
  # @param  Yaml string to be tested
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

  # Check a existent class variable.
  #
  # @param   variable   variable name to retrive
  # @return  boolean
  def self.instance_variable? variable
    # ap self.instance_variables.include? variable.to_sym
    # exit
    return self.instance_variable_get(":@#{variable}")
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




##### sem minitest

  def self.purge_files path, select, time #Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60
    to_clean = Dir.glob(File.join(path, select)).select { |a|
      Time.now - File.ctime(a) > time }
    to_clean.each do |file_to_delete|
      File.delete(file_to_delete)
    end
  end

end

module HashRecursiveBlank
  def rblank
    r = {}
    each_pair do |key, val|
      r[key] = val.rblank if val.is_a?(Hash)
    end
    return r.keep_if { |key, val| val.is_a?(Hash) }
  end

  def rblank!
    each_pair do |key, val|
      self[key] = val.rblank! if val.is_a?(Hash)
    end
    return keep_if { |key, val| val.is_a?(Hash) }
  end
end

module HashRecursiveMerge
  def rmerge(other_hash, concat_if_array = false)
    r = {}
    return merge(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        r[key] = oldval.rmerge(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        r[key] = concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end

  def rmerge!(other_hash, concat_if_array = false)
    return merge!(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        oldval.rmerge!(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end
end

class Hash
  include HashRecursiveMerge
  include HashRecursiveBlank

  def diff(other)
      (self.keys + other.keys).uniq.inject({}) do |memo, key|
        unless self[key] == other[key]
          if self[key].kind_of?(Hash) &&  other[key].kind_of?(Hash)
            memo[key] = self[key].diff(other[key])
          else
            memo[key] = [self[key], other[key]]
          end
        end
        memo
      end
    end
end


class Hash

    # ensures nested hash from keys, and sets final key to value
    # keys: Array of Symbol|String
    # value: any
    def nested_set(keys, value)
      raise "DEBUG: nested_set keys must be an Array" unless keys.is_a?(Array)

      final_key = keys.pop
      return unless valid_key?(final_key)
      position = self
      for key in keys
        return unless valid_key?(key)
        position[key] = {} unless position[key].is_a?(Hash)
        position = position[key]
      end
      position[final_key] = value
    end

    private

      # returns true if key is valid
      def valid_key?(key)
        return true if key.is_a?(Symbol) || key.is_a?(String)
        raise "DEBUG: nested_set invalid key: #{key} (#{key.class})"
      end

end


class String

  # Self test nil String class.
  #
  # @return   boolean
  def nil?
    return '' if self == nil
  end


  # Justity relative left or right position filled with a espefific char in String.
  #
  # sample:
  #
  #  "TESTE".fix(10,'xy') # => xxxxxTESTE
  #  "TESTE".fix(-10,'xy') # => TESTExxxxx
  #
  # @param    size to justify.
  # @param    pattern pattern do justify
  # @return   formated string
  def fix(size, pattern=' ')
    if size >= 0
      self[0...size].rjust(size, pattern)
    else
      diff = size.abs - self.size
      self + ''.fix(diff,pattern)
    end
  end

  # Encrypt a string using a key.
  # sample
  # msg       = "teste do encrypt".light_blue
  # passwd    = 'tools999'
  # encrypted = msg.encrypt passwd
  # puts (encrypted.decrypt passwd)
  # @return   encrypt string
  def encrypt(key)
    Encrypt.dump self, key
  end

  # Decrypt a string using a key.
  # sample
  # msg       = "teste do encrypt".light_blue
  # passwd    = 'tools999'
  # encrypted = msg.encrypt passwd
  # puts (encrypted.decrypt passwd)
  # @return   decrypt string
  def decrypt(key)
    Encrypt.load self, key
  end

  # Self test numeric String class.
  #
  # @return   boolean
  def numeric?
    Float(aux) != nil rescue false
  end

  # Self test digits String class.
  #
  # @return   boolean
  def num?
    !!match(/^[[:digit:]]+$/)
  end

  # Self test alphanum String class.
  #
  # @return   boolean
  def alnum?
    !!match(/^[[:alnum:]]+$/)
  end

  # Self test alpha String class.
  #
  # @return   boolean
  def alpha?
    !!match(/^[[:alpha:]]+$/)
  end

end


class Object
  # Self test Boolean class.
  #
  # @return   boolean
  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass)
  end

  # Self test Trueclass.
  #
  # @return   boolean
  def true?
    self.is_a?(TrueClass)
  end
  # Self test Falseclass.
  #
  # @return   boolean
  def false?
    self.is_a?(FalseClass)
  end

  # Self test Symbol class.
  #
  # @return   boolean
  def symbol?
    self.is_a?(Symbol)
  end
  # Self test String class.
  #
  # @return   boolean
  def string?
    self.is_a?(String)
  end
end

class Array

  # Self pop first element.
  # @return   first element
  def extract_first
    first = self[0]
    self.delete_at(0)
    return first
  end

  # Self extract symbol.
  # @param    symbol to retrive
  # @return   boolean
  def extract_symbol symbol
    status = false
    if self.include? symbol
      status = true
      self.delete(symbol)
    end
    return status
  end

  # Self extract color.
  # @return   boolean
  def extract_color
    colors = String.colors
    color  = :default
    self.each do |argument|
      if argument.symbol?
        if colors.include? argument
          color = argument
          self.delete(argument)
          return color
        end
      else
        if argument.string?
          if argument.start_with? ':'
            color_candidate = argument.gsub(':','').to_sym
            color = color_candidate if colors.include? color_candidate
            self.delete(argument)
            return color
          end
        end
      end
    end
    return color
  end




  # Self extract option.
  # @param    option to extract.
  # @param    single boolean to repeat
  # @return   variable boolean, arguments - extract_option
  #
  # Sample
  # args = [xxx -x -vvv -c -vcv -v2 -vvvvv -s :json :yellow :red]
  # args.extract_option '-x'           => true
  # args.extract_option '-f'           => false
  # args.extract_option '-v', false    => 8
  # args.extract_symbol :json          => true
  # args.extract_symbol :yaml          => false
  # args.extract_color                 => :yellow
  # args.extract_color                 => red
  # args                               => [-c -vcv -v2 -s ]
  #
  def extract_option option, single = true
    if single
      result = false
      if self.include? option
        index = self.index(option)
        self.delete_at(index)
        result = true
      end
    else
      result = 0
      self.each do |argument|
        if argument.start_with? option
         #puts "'#{option}' '#{argument}' #{argument.start_with? option} \n"
         search_char = option.sub('-','')
         aux_string  = argument.sub('-','')
         count       = argument.count(search_char)
         if (count == aux_string.size)
           result = result + count
           #self.delete(argument)
         end
        end

      end
    end
    return result
  end

  def extract_option_value option
    result = false
    value  = nil
    while self.include? option
      index = self.index(option)
      self.delete_at(index)
      result = true
      value = self.at(index)
      self.delete_at(index)
    end
    return [result, value]
  end

end