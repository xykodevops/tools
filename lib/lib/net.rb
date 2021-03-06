require 'singleton'
class ToolsNet
  include Singleton

  def initialize(options = {}); end

  # Test a host.
  #
  # Net::Ping::External.new(host || '0.0.0.1000', timeout = 1).ping?
  #
  # @param            host or ip variable to test
  # @return [Boolean]
  def self.ping?(host)
    Net::Ping::External.new(host || '0.0.0.1000', 1).ping?
  end

  def self.get_current_ip
    ip = `ifconfig | grep -E '10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  | awk '{print $2}'`.split("\n").first
    unless valid_ip? ip
      ip = `ifconfig | grep -E '192\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'  | awk '{print $2}'`.split("\n").first
    end
    ip = ip.split("\n").first if ip.include? "\n"
    return ip if IPAddress.valid?(ip)
  end

  # Resolv a ip to a dns.
  #
  # @param           ip variable ip to resolv
  # @return [String] Dns name resolved
  def self.resolv_ip_name(ip)
    ret = Resolv.new.getname(ip)
    ret.instance_variable_get('@labels').join('.')
  rescue Exception => e
    case e.message
    when 'Dnsruby::NXDomain' then nil
    else
      e.message
    end
  end

  # Resolv a dns to a ip.
  #
  # @param domain variable ip to resolv
  # @return [String] Dns address resolved
  def self.resolv_dns(domain)
    dns = Dnsruby::DNS.new
    dns.getaddress(domain).to_s
  rescue Exception => e
    case e.message
    when 'Dnsruby::NXDomain' then nil
    else
      e.message
    end
  end

  # Do the request, validate and decode response and do the retries if needed
  #
  # - restclient_obj: initialized RestClient object
  # - path: URL path to request
  # - method: symbol for HTTP Method to request
  # - method_opts: options as passed to a RestClient call
  # - validate_opts: options for response validation as used with
  # validate_decode_response()
  # - retry_opts: when_res: [nil, [], {}, 'str'], when_code: [404, 500],
  # conditionals to retry even if no exceptions were catched
  # @param restclient_obj Rest Object
  # @param path           path
  # @param method         method
  # @param method_opts    method opts
  # @param validate_opts  validate opts
  # @param retry_opts     retry opts
  # @param show_progress  default false
  def self.doreq(restclient_obj, path, method, method_opts: {}, validate_opts: {}, retry_opts: {}, show_progress: false)
    res = nil
    code = nil
    data = method_opts.fetch(:data, nil)
    method_opts.delete(:data)

    # Retry loop due to:
    # - 404 from Router API right after applying patch over a target
    # - Intermittent connection reset from Manager API (HTTPS)
    retries = retry_opts.fetch(:attempts, 10)
    1.upto(retries) do |try|
      flag_error = false
      # The request
      begin
        restclient_obj[path].send(method, *data, **method_opts) do |response, request, result|
          res  = validate_decode_response(response, request, result, validate_opts)
          code = result.code.to_i
        end
      rescue Exception => e
        flag_error = true
      end
      # Other conditionals to retry
      unless retry_opts.empty?
        if retry_opts.key?(:when_res)
          flag_error = true if retry_opts[:when_res].include?(res)
        end
        if retry_opts.key?(:when_code)
          flag_error = true if retry_opts[:when_code].include?(code)
        end
      end
      return res unless flag_error # got response, break the loop

      doReqMSG = format '%d/%d', try, retries
      ap doReqMSG if show_progress
      if try >= retries
        ap doreq_code
        return nil
      else
        sleep 1 # wait before next
      end
    end
  end

  # Return a valid decode response.
  #
  # @param   response
  # @param   request
  # @param   result
  # @param   validate_opts
  # @return [Object type] Array or Proc or String or Error
  def self.validate_decode_response(response, request, result, validate_opts)
    if validate_opts.key? :expected
      expected = validate_opts[:expected]
      case expected.class.name
      when 'Array'
        if validate_opts[:expected].include? response
          return true
        else
          return false
        end
      when 'Proc'
        response = expected.call(response, request, result)
        return response
      when 'String'
        return result   if validate_opts[:expected].eql? 'result'
        return request  if validate_opts[:expected].eql? 'request'
        return response if validate_opts[:expected].eql? 'response'
      else
        ap expected.class.name
        return response
      end
    else
      return response
    end
    true
  end

  # Validate.: port number between valid range?.
  #
  # @param            port number to be validate.
  # @return [Boolean]
  def self.valid_port?(port)
    return false if port.to_s.strip.match(/^\d{1,5}(?!\d)$/).nil?
    return false unless port.to_i.between?(1, 65_535)

    true
  end

  # Validate.: ip number or mask are valids?.
  #
  # @param  that number or mask to be validate.
  # @return [Hash] result info ip or ask or error
  def self.validate_ipaddress(that)
    result = {}
    result[:status]  = false
    result[:type]    = ''
    result[:msg]     = ''
    result[:address] = that
    result[:resolv]  = ''
    if IPAddress.valid_ipv4? that
      begin
        ip = IPAddress.valid_ipv4? that
        result[:status] = true
        result[:type]   = 'ip'
        result[:oct1]   = that.split('.')[0]
        result[:oct2]   = that.split('.')[1]
        result[:oct3]   = that.split('.')[2]
        result[:oct4]   = that.split('.')[3]
      rescue Exception => e
        result[:msg]    = e.to_s
        return
      end
    else
      begin
        net = NetAddr::IPv4Net.parse that
        result[:type]   = 'mask'
        result[:status] = true
      rescue Exception => e
        result[:type]   = ''
        result[:status] = false
        # ip = resolv_dns that
        # if IPAddress::valid_ipv4? ip
        #   result[:status] = true
        #   result[:type]   = 'ip'
        #   result[:oct1]   = ip.split('.')[0]
        #   result[:oct2]   = ip.split('.')[1]
        #   result[:oct3]   = ip.split('.')[2]
        #   result[:oct4]   = ip.split('.')[3]
        # else
        #   result[:msg] = e.to_s
        # end
      end
    end
    result
  end

  # Validate.: ip number is a backend?.
  #
  # @param  original_addr number to be validate.
  # @return [Boolean]
  def self.is_backend?(original_addr)
    backend = NetAddr::IPv4Net.parse '10.0.0.0/8'
    backend.contains (NetAddr::IPv4.parse original_addr)
  end

  def self.valid_ip?(original_addr)
    status = false
    begin
      status = IPAddress.valid?(original_addr)
    rescue Exception => e
      e
    end
    status
  end

  # Validate.: ip number is avalid network.
  #
  # @param  original_addr network number to be validate.
  # @return [Boolean]
  def self.valid_network?(original_addr)
    status = false
    begin
      ip = IPAddress original_addr
      status = true if ip.network?
    rescue Exception => e
      e
    end
    status
  end
end
