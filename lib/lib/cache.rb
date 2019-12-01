require 'singleton'
class ToolsCache
  include Singleton

  def initialize(options = {})
  end


  # Create a cache file in work area
  #
  # @param cache_name
  # @param cache_file
  # @param ttl
  # @return
  def self.create_cache_file cache_name, cache_file, ttl=nil
    cache = Persistent::Cache.new(cache_file, ttl)
    ToolsUtil.set_variable "#{cache_name}_cache", cache
  end


  # Add a record in a cache work area
  #
  #  Sample
  #
  # ToolsCache.create_cache_file 'cmdapi', '/home/francisco/.newcmdapi/cmdapi-persistent.cache'
  # cache = ToolsUtil.get_variable 'cmdapi_cache'
  # cache.clear
  # ToolsCache.cmdapi_set :ldap, {:rogerio  => {:name => 'rogerio'}}
  # ToolsCache.cmdapi_set :ldap, {:wagner => {:name => 'wagner'}}
  # ToolsCache.cmdapi_set :cloud, [100,200]
  # ToolsCache.cmdapi_set :cloud, 300
  # ToolsCache.cmdapi_set :cloud, [300,500,'teste']
  # ToolsCache.cmdapi_set :cloud, "teste2"
  # ToolsCache.cmdapi_set :cloud, {:teste => 1}
  # ToolsCache.cmdapi_set :nat, "texto para nat"
  # ToolsCache.cmdapi_set :nat, "texto para nat_ depois da primeira"
  # ToolsCache.cmdapi_unset :nat
  # ToolsCache.cmdapi_set :nat, "texto para nat_ depois da primeira"
  #
  # @param method
  # @param args
  # @param block
  # @return
  def self.method_missing(method, *args, &block)

    cache_name   = method.to_s.split('_').first
    cache_method = method.to_s.split('_').last
    cache        = ToolsUtil.get_variable "#{cache_name}_cache"

    case cache_method

    when 'set'
      key    = args.extract_first
      values = args.extract_first
      unless cache.key?(key)
        cache[key] = values
      else
        aux = cache[key]
        case aux.class.to_s
        when 'Hash'
          begin
            aux.merge! values
            cache[key] = aux
          rescue Exception => e
            ToolsDisplay.show "\tError in ToolsCache:  #{e.exception}", :light_yellow
            exit
          end
        when 'Array'
          aux = cache[key]
          case values.class.to_s
          when 'Array'
            values.each do |value|
              aux.insert(-1,value)
            end
            cache[key] = aux
          else
            aux.insert(-1,values)
            cache[key] = aux
          end
        end

      end

    # when 'set'
    #   key        = args.extract_first
    #   value      = args.extract_first
    #   cache.set(key, value, Time.now)

    # when 'setext'
    #   key        = args.extract_first
    #   values     = args.extract_first
    #   unless cache.key?(key)
    #     ToolsCache.cmdapi_set key, values
    #   else
    #     aux = cache[key]
    #     values.keys.each do |value|
    #       aux[value] = values[value]
    #     end
    #     ToolsCache.cmdapi_set key, aux
    #   end

    # when 'unsetext'
    #   key          = args.extract_first
    #   key_internal = args.extract_first
    #   if cache.key?(key)
    #     aux = cache[key]
    #     if aux.key? key_internal
    #       aux
    #     end
    #   end

    when 'unset'
      key = args.extract_first
      cache[key] = nil

    when 'get'
      key = args.extract_first
      return cache[key]

    when 'list'
      result = {}
      cache.each do |key|
        result[key] = cache[key]
      end
      return result

    when 'clear'
       cache.each do |key|
        cache[key] = nil
      end
    end

  end


end