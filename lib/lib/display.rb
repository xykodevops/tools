require 'singleton'
class ToolsDisplay
  include Singleton

  def initialize(options = {}); end

  # Tools to awesome prints
  #
  # ToolsDisplay.show "teste"
  # ToolsDisplay.show "TEXT SAMELINE sem cor ", :sameline
  # ToolsDisplay.show "TEXT GREEN", :green
  # ToolsDisplay.show "TEXT YELLOW", :yellow
  #
  # @param arguments
  # @return [String] printed
  def self.show(*arguments)
    post = arguments[0]
    return post.class.to_s unless post.is_a? String

    color      = arguments.extract_color
    sameline   = arguments.extract_symbol :sameline
    colorized  = arguments.extract_symbol :colorized
    post += "\n" unless sameline
    colorized ? printf(post.to_s) : printf(post.to_s.colorize(color))
    # if colorized
    #   printf post.to_s
    # else
    #   printf post.to_s.colorize(color)
    # end
  end

  def self.show_colorize(*arguments)
    puts arguments.first
  end
end
