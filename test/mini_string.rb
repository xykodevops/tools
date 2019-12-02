class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_string_A_fix
    assert_equal 'TESTE'.fix(10, 'xy'), 'xyxyxTESTE'
    assert_equal 'TESTE'.fix(-10, 'xy'), 'TESTExyxyx'
  end

  def test_string_B_encrypt_decrypt
    msg       = 'teste do encrypt'
    passwd    = 'tools999'
    encrypted = msg.encrypt passwd
    assert_equal msg, (encrypted.decrypt passwd)
  end

  def test_string_C_numeric?
    assert_equal true, '100'.numeric?
    assert_equal false, 'xx'.numeric?
  end

  def test_string_D_num?
    assert_equal true, '100'.num?
    assert_equal false, 'xx'.num?
  end

  def test_string_E_alnum?
    assert_equal true, '1x0'.alnum?
    assert_equal true, '1xx'.alnum?
  end

  def test_string_F_alpha?
    assert_equal false, '100'.alpha?
    assert_equal true, 'xx'.alpha?
  end

  def test_string_G_help?
    assert_equal true, '?'.help?
    assert_equal true, '-h'.help?
    assert_equal true, '--help'.help?
    assert_equal true, 'help'.help?
    assert_equal false, 'eelp'.help?
  end
end
