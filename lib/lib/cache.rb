require 'singleton'
class ToolsCache
  include Singleton

  def initialize(options = {})
  end


  # Create a cache file in work area
  #
  # @param arguments
  # @return
  def self.create_cache_file cache_name, cache_dir

    unless File.exists? cache_dir
     ToolsLog.tools_error "Invalid directory in new config file in '#{cache_dir}'.", :light_red
     ToolsLog.tools_exit
    end
    unless cache_dir.end_with? '/'
      cache_dir += '/'
    end

    cache_file = cache_dir +  cache_name + '.cache'
    if File.exists? cache_file
     ToolsLog.tools_error "The cache file in '#{cache_file}' already exists. Leaving operation...", :light_yellow
    else
      ToolsFiles.create_file cache_dir, cache_name, "cache_#{cache_name}"
    end

  end

  def self.method_missing(method, *args, &block)
    #expected call format =>    STRING_LOGGER_TYPE + '_' + LOGGER_TYPE
    # Ex.:  tools_info
    cache_name   = method.to_s.split('_').first
    cache_method = method.to_s.split('_').last
    cache_file   = ToolsUtil.get_variable "cache_#{cache_name}"

    ap cache_name
    ap cache_method
    ap cache_file
    ap args
    ap block

  end


end