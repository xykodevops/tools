class ToolsModuleTest < Minitest::Test

  def self.test_order
    :sorted
  end

  def test_net_A_ping?
    assert_equal (ToolsNet.ping? '127.0.0.1'), true
  end

  def test_net_B_work_with_ips
    ip = ToolsNet.get_current_ip
    assert_equal (ToolsNet.valid_ip? ip), true
    assert_equal (ToolsNet.validate_ipaddress ip)[:status], true
    assert_equal (ToolsNet.validate_ipaddress ip)[:type], 'ip'
    assert_equal (ToolsNet.validate_ipaddress '100.0.0.0/28')[:status], true
    assert_equal (ToolsNet.validate_ipaddress '100.0.0.0/28')[:type], 'mask'
    assert_equal (ToolsNet.validate_ipaddress ip+'x')[:status], false
    assert_equal (ToolsNet.validate_ipaddress '100.0.0.0/28x')[:status], false
    assert_equal (ToolsNet.is_backend? '10.1.2.3'), true
    assert_equal (ToolsNet.is_backend? '201.0.0.1'), false
    assert_equal (ToolsNet.valid_network? ip), false
    assert_equal (ToolsNet.valid_network? '110.0.0.0/28'), true
    assert_equal (ToolsNet.resolv_dns 'www.wikipedia.org'), "208.80.154.224"
    assert_nil   (ToolsNet.resolv_dns 'www.wikipedia.orgx')
    assert_equal (ToolsNet.resolv_ip_name "208.80.154.224"), "text-lb.eqiad.wikimedia.org"
    assert_equal (ToolsNet.resolv_ip_name "208.80.154.224x"), "cannot interpret as address: 208.80.154.224x"
  end

  def test_net_C_valid_port
    assert_equal (ToolsNet.valid_port? 8888), true
    assert_equal (ToolsNet.valid_port? -1), false
    assert_equal (ToolsNet.valid_port? 0), false
    assert_equal (ToolsNet.valid_port? 100000), false
  end


  def test_net_D_doreq
    resource = RestClient::Resource.new('www.google.com')
    validate_opts = {quit_on_error: false}
    method_opts   = {}
    params={:method => :get}
    uri = ''
    if params.has_key? :expected
      validate_opts[:expected] = params[:expected]
    end
    if params.has_key? :data
      method_opts = {:data => params[:data].to_json}
    end
    result =  ToolsNet.doreq resource,
                                uri,
                                params[:method],
                                show_progress: true,
                                method_opts: method_opts,
                                validate_opts: validate_opts,
                                retry_opts: {
                                  attempts: 1,
                                  when_res: [nil, [], {}, ''],
                                  when_code: []}
    assert_equal result.code, 200
  end


end




  # # Resolv a ip to a dns.
  # #
  # # @param           ip variable ip to resolv
  # # @return [String] Dns name resolved
  # def self.resolv_ip_name ip
  #   s = ''
  #   begin
  #     ret = Resolv.new.getname(ip)
  #     return ret.instance_variable_get('@labels').join('.')
  #   rescue Exception => e
  #     case e.message
  #       when "Dnsruby::NXDomain"
  #         return nil
  #       else
  #         return e.message
  #     end
  #   end
  #   return s.strip
  # end


  # # Resolv a dns to a ip.
  # #
  # # @param domain variable ip to resolv
  # # @return [String] Dns address resolved
  # def self.resolv_dns domain
  #   begin
  #     dns = Dnsruby::DNS.new()
  #     ret = dns.getaddress(domain).to_s
  #   rescue Exception => e
  #     case e.message
  #       when "Dnsruby::NXDomain"
  #         return nil
  #       else
  #         return e.message
  #     end
  #   end
  #   return ret
  # end


  # # Do the request, validate and decode response and do the retries if needed
  # #
  # # - restclient_obj: initialized RestClient object
  # # - path: URL path to request
  # # - method: symbol for HTTP Method to request
  # # - method_opts: options as passed to a RestClient call
  # # - validate_opts: options for response validation as used with
  # # validate_decode_response()
  # # - retry_opts: when_res: [nil, [], {}, 'str'], when_code: [404, 500],
  # # conditionals to retry even if no exceptions were catched
  # # @param restclient_obj Rest Object
  # # @param path           path
  # # @param method         method
  # # @param method_opts    method opts
  # # @param validate_opts  validate opts
  # # @param retry_opts     retry opts
  # # @param show_progress  default false
  # def self.doreq( restclient_obj, path, method, method_opts: {},validate_opts: {}, retry_opts: {}, show_progress: false)
  #   res = nil
  #   code = nil
  #   data = method_opts.fetch(:data, nil)
  #   method_opts.delete(:data)

  #   # Retry loop due to:
  #   # - 404 from Router API right after applying patch over a target
  #   # - Intermittent connection reset from Manager API (HTTPS)
  #   retries = retry_opts.fetch(:attempts, 10)
  #   1.upto(retries) do |try|
  #     flag_error = false
  #     # The request
  #     begin
  #       restclient_obj[path].send(method, *data, **method_opts) do |response, request, result|
  #         res  = validate_decode_response(response, request, result, validate_opts)
  #         code = result.code.to_i
  #       end
  #     rescue Exception => error
  #       flag_error = true
  #     end
  #     # Other conditionals to retry
  #     unless retry_opts.empty?
  #       if retry_opts.has_key?(:when_res)
  #         flag_error = true if retry_opts[:when_res].include?(res)
  #       end
  #       if retry_opts.has_key?(:when_code)
  #         flag_error = true if retry_opts[:when_code].include?(code)
  #       end
  #     end
  #     return res unless flag_error # got response, break the loop
  #     doReqMSG = sprintf "%d/%d", try, retries
  #     if show_progress
  #        ap doReqMSG
  #     end
  #     if try >= retries
  #       ap doreq_code
  #       return nil
  #     else
  #       sleep 1 # wait before next
  #     end
  #   end
  # end

  # # Return a valid decode response.
  # #
  # # @param   response
  # # @param   request
  # # @param   result
  # # @param   validate_opts
  # # @return [Object type] Array or Proc or String or Error
  # def self.validate_decode_response response, request, result, validate_opts
  #   if validate_opts.has_key? :expected
  #     expected = validate_opts[:expected]
  #     case expected.class.name
  #     when 'Array'
  #       if validate_opts[:expected].include? response
  #         return true
  #       else
  #         return false
  #       end
  #     when 'Proc'
  #       response = expected.call(response, request, result)
  #       return response
  #     when 'String'
  #       return result   if validate_opts[:expected].eql? 'result'
  #       return request  if validate_opts[:expected].eql? 'request'
  #       return response if validate_opts[:expected].eql? 'response'
  #     else
  #       ap expected.class.name
  #       return response
  #     end
  #   else
  #     return response
  #   end
  #   return true
  # end


  # # Validate.: port number between valid range?.
  # #
  # # @param            port number to be validate.
  # # @return [Boolean]
  # def self.valid_port? port
  #   if port.to_s.strip.match(/^\d{1,5}(?!\d)$/).nil?
  #     return false
  #   end
  #   unless port.to_i.between?(1, 65535)
  #     return false
  #   end
  #   return true
  # end





