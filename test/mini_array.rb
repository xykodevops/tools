class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_hash_A_extract_first
    assert_equal %w[a b c].extract_first, 'a'
  end

  def test_hash_B_extract_first
    assert_equal (['a', :color, 'c'].extract_symbol :color), true
  end

  def test_hash_C_extract_color
    args   = ['xxx', '-x', '-vvv', :yellow, '-c', '-vcv', '-v2', '-vvvvv', '-s', :json, :red, :json]
    yellow = args.extract_color
    color  = args.extract_color
    assert_equal yellow, :yellow
    assert_equal color, :red
  end

  def test_hash_D_extract_option
    args   = ['xxx', '-x', '-vvv', :yellow, ':red', '-c', '-vcv', '-v2', '-vvvvv', '-s', :json, :red, :json]
    yellow = args.extract_color
    red1    = args.extract_color
    red2    = args.extract_color
    red3    = args.extract_color
    x = args.extract_option '-x'
    f = args.extract_option '-f'
    v = args.extract_option '-v', false
    assert_equal x, true
    assert_equal f, false
    assert_equal v, 8
    assert_equal red1, :red
    assert_equal red2, :red
    assert_equal red3, :default
  end

  def test_hash_D_extract_option_value
    args = ['-o', 'um', '-o', 'dois', '--desc', 'description', '-v', '-v', '-o', 'tres', '-s', :json, :red, :json]
    desc_status, desc = args.extract_option_value '--desc'
    status, origin    = args.extract_option_value '-o', multiple: true
    assert_equal desc_status, true
    assert_equal desc, 'description'
    assert_equal status, true
    assert_equal origin, %w[um um dois dois tres tres]
  end
end
