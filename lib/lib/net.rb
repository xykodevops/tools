require 'singleton'
class ToolsNet
  include Singleton


  # Resolv a ip to a dns.
  #
  # @param           ip variable ip to resolv
  # @return [String] Dns name resolved
  def self.resolv_ip_name ip
    s = ''
    begin
      ret = Resolv.new.getname(ip)
      return ret.instance_variable_get('@labels').join('.')
    rescue Exception => e
      s = 'edi error: ' + e.message
    end
    return s.strip
  end


  # Resolv a dns to a ip.
  #
  # @param domain variable ip to resolv
  # @return [String] Dns address resolved
  def self.resolv_dns domain
    begin
      dns = Dnsruby::DNS.new()
      ret = dns.getaddress(domain).to_s
    rescue Exception => e
      case e.message
        when "Dnsruby::NXDomain"
          ret = nil
        else
          ret = e.message
      end
    end
    return ret
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
  # @param caller         caller
  # @param method_opts    method opts
  # @param validate_opts  validate opts
  # @param retry_opts     retry opts
  # @param show_progress  default false
  def self.doreq( restclient_obj, path, method, caller, method_opts: {},validate_opts: {}, retry_opts: {}, show_progress: false)
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
      rescue Exception => error
        ap error
        flag_error = true
      end
      # Other conditionals to retry
      unless retry_opts.empty?
        if retry_opts.has_key?(:when_res)
          flag_error = true if retry_opts[:when_res].include?(res)
        end
        if retry_opts.has_key?(:when_code)
          flag_error = true if retry_opts[:when_code].include?(code)
        end
      end
      return res unless flag_error # got response, break the loop
      doReqMSG = sprintf "%d/%d", try, retries
      if show_progress
         ap doReqMSG
      end
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
  def self.validate_decode_response response, request, result, validate_opts
    if validate_opts.has_key? :expected
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
    return true
  end


end