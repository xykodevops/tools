class Array
  # Self pop first element.
  # @return   first element
  def extract_first
    first = self[0]
    delete_at(0)
    first
  end

  # Self extract symbol.
  # @param    symbol to retrive
  # @return   boolean
  def extract_symbol(symbol)
    status = false
    if include? symbol
      status = true
      delete(symbol)
    end
    status
  end

  # Self extract color.
  # @return   boolean
  def extract_color
    colors = String.colors
    color  = :default
    each do |argument|
      if argument.symbol?
        if colors.include? argument
          color = argument
          delete(argument)
          return color
        end
      else
        if argument.string?
          if argument.start_with? ':'
            color_candidate = argument.gsub(':', '').to_sym
            color = color_candidate if colors.include? color_candidate
            delete(argument)
            return color
          end
        end
      end
    end
    color
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
  def extract_option(option, single = true)
    if single
      result = false
      if include? option
        index = self.index(option)
        delete_at(index)
        result = true
      end
    else
      result = 0
      each do |argument|
        next unless argument.to_s.start_with? option

        # puts "'#{option}' '#{argument}' #{argument.start_with? option} \n"
        search_char = option.sub('-', '')
        aux_string  = argument.to_s.sub('-', '')
        count       = argument.to_s.count(search_char)
        if count == aux_string.size
          result += count
          # self.delete(argument)
        end
      end
    end
    result
  end

  def extract_option_value(option, args = {})
    args[:multiple] = false if args[:multiple].nil?

    args[:separator] = '=' if args[:separator].nil?

    result = false
    if args[:multiple]
      multiple_value = []
      while include? option
        index = self.index(option)
        delete_at(index)
        result = true
        value = at(index)
        multiple_value << at(index).split(args[:separator]).first
        multiple_value << at(index).split(args[:separator]).last
        delete_at(index)
      end
      return [result, multiple_value]
    else
      value = nil
      while include? option
        index = self.index(option)
        delete_at(index)
        result = true
        value = at(index)
        delete_at(index)
      end
      return [result, value]
    end
  end
end
