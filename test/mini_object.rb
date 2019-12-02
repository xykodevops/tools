class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_object_A_boolean?
    test = true
    assert_equal test.boolean?, true
  end

  def test_object_B_true?
    test = true
    assert_equal test.true?, true
  end

  def test_object_C_false?
    test = false
    assert_equal test.false?, true
end

  def test_object_D_symbol?
    test = :true
    assert_equal test.symbol?, true
end

  def test_object_E_string?
    test = 'string'
    assert_equal test.string?, true
end
end
