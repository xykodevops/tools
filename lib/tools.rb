require "tools/version"

# Basic models
require 'lib/utils'
require 'lib/display'
require 'lib/net'
require 'lib/files'
require 'lib/string'
require 'lib/array'
require 'lib/hash'
require 'lib/object'

# Extented models
require 'lib/config'
require 'lib/log'
require 'lib/cache'
require 'lib/prompt'
require 'lib/console'

load __dir__ + '/files/requireds.rb'

module Tools

  class Configuration
    attr_accessor :console_prompt
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

  end


  def self.root
    File.dirname __dir__
  end

  def self.files
    File.join root, 'lib/files'
  end

  def self.host
    Socket.gethostname
  end

  def self.home
    ENV['HOME']
  end

  def self.user
    ENV['USER']
  end

  def self.pwd
    ENV['PWD']
  end

  def self.ldap_pass
    ENV['ldap_pass']
  end

  def self.ldap_user
    ENV['ldap_user']
  end

  def self.gem_path
    ENV['GEM_PATH']
  end

end

Tools.configure do |config|
  config.console_prompt = Tools::VERSION
  I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
  I18n.locale    = 'pt-BR'.to_sym
 #ToolsUtil.instance
end



