require 'singleton'
class ToolsPrompt
  include Singleton

  def initialize(options = {})
  end

  def self.yes? *args
    prompt = TTY::Prompt.new
    prompt.yes? *args
  end

  def self.no? *args
    prompt = TTY::Prompt.new
    prompt.no? *args
  end

  def self.ask *args
    prompt = TTY::Prompt.new
    result = prompt.ask *args
    return result
  end

  def self.mask *args
    prompt = TTY::Prompt.new
    result = prompt.mask *args
    return result
  end

  def self.select *args
    prompt = TTY::Prompt.new
    result = prompt.select *args
    return result
  end

  def self.multi_select *args
    prompt = TTY::Prompt.new
    result = prompt.multi_select *args
    return result
  end

  def self.enum_select *args
    prompt = TTY::Prompt.new
    result = prompt.enum_select *args
    return result
  end

  def self.expand *args
    prompt = TTY::Prompt.new
    result = prompt.expand *args
    return result
  end

end