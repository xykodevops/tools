class ToolsModuleTest < Minitest::Test

  def self.test_order
    :sorted
  end

  def test_utils_A_symbolize_keys
    hash = {'key' => 1, :key1 => 'A', :key3 => {:k1 => 1}}
    hash = ToolsUtil.symbolize_keys(hash)
    assert_equal hash, {:key => 1, :key1 => 'A', :key3 => {:k1 => 1}}
  end

  def test_utils_C_valid_json_true?
    data = {:k1 => "v1", :k2 => "v2"}.to_json
    assert_equal true, (ToolsUtil.valid_json? data)
  end

  def test_utils_D_valid_json_error?
    data = {:k1 => "v1", :k2 => "v2"}.to_json + "error"
    assert_equal false, (ToolsUtil.valid_json? data)
  end

  def test_utils_E_valid_yaml_true?
    data = {:k1 => "v1", :k2 => "v2"}.to_yaml
    assert_equal true, (ToolsUtil.valid_yaml? data)
  end

  def test_utils_F_valid_yaml_error?
    data = {:k1 => "v1", :k2 => "v2"}.to_yaml + "error"
    assert_equal false, (ToolsUtil.valid_yaml? data)
  end

  def test_utils_G_get_date
    now = DateTime.now
    (ToolsUtil.get_date '%Y %m %d %H %M').split(' ').each do |d|
      assert_equal (now.to_s.include? d), true
    end
  end

  def test_utils_H_set_get_variable
    ToolsUtil.set_variable 'teste', 'A'
    assert_equal (ToolsUtil.get_variable 'teste'), 'A'
  end

  def test_utils_I_set_get_variable_ext
    ToolsUtil.set_variable 'teste_string', ""
    ToolsUtil.set_variable 'teste_array', []
    ToolsUtil.set_variable 'teste_hash', {}
    ToolsUtil.set_variable_ext 'teste_string', "A"
    ToolsUtil.set_variable_ext 'teste_array', "1"
    ToolsUtil.set_variable_ext 'teste_hash', {:teste => 'teste'}
    ToolsUtil.set_variable_ext 'teste_hash_error', []
    assert_equal (ToolsUtil.get_variable 'teste_string'), 'A'
    assert_equal (ToolsUtil.get_variable 'teste_array'), ['1']
    assert_equal (ToolsUtil.get_variable 'teste_hash'), {:teste => 'teste'}
    assert_nil (ToolsUtil.get_variable 'teste_hash_error')
  end

  def test_utils_K_get_variables
    ToolsUtil.set_variable 'teste', 'A'
    assert_equal ToolsUtil.get_variables.class, Array
  end

  def test_utils_L_get_plain_text
    data = {
      'k1' => 100,
      'k2' => 'v2'
    }
    assert_equal (ToolsUtil.get_plain_text data), "{\n    \"k1\" => 100,\n    \"k2\" => \"v2\"\n}\n"
    assert_equal (ToolsUtil.get_plain_text "TEST"), "\t\e[0;33;49mTEST\e[0m"
    assert_equal (ToolsUtil.get_plain_text true), true
    assert_nil (ToolsUtil.get_plain_text nil)
  end

  def test_utils_M_get_tools_variables
    assert_equal Tools.root, (File.dirname __dir__)
    assert_equal Tools.files, (File.join (File.dirname __dir__), 'lib/files')
    assert_equal Tools.host, Socket.gethostname
    assert_equal Tools.home, ENV['HOME']
    assert_equal Tools.user, ENV['USER']
    assert_equal Tools.pwd, ENV['PWD']
    assert_equal Tools.ldap_pass, ENV['ldap_pass']
    assert_equal Tools.ldap_user, ENV['ldap_user']
    assert_equal Tools.gem_path, ENV['GEM_PATH']
  end


  # def test_utils_N_instance
  #   mock = MiniTest::Mock.new
  #   def mock.initialize  *args; true; end
  #   ToolsUtil.stub :initialize, mock do
  #     assert_equal (ToolsUtil.new), true
  #   end
  # end

end