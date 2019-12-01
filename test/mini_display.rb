class ToolsModuleTest < Minitest::Test

  def self.test_order
    :sorted
  end

  def test_dislay_A
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show "TEXTO VERDE", :green
    $stdout = old_stdout
    assert_equal "\e[0;32;49mTEXTO VERDE\n\e[0m", captured_stdio.string
  end

  def test_dislay_B_sameline
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show "TEXTO SAMELINE", :sameline
    $stdout = old_stdout
    assert_equal "\e[0;39;49mTEXTO SAMELINE\e[0m", captured_stdio.string
  end

  def test_dislay_C_show_colorize
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show_colorize "red".red+ " " + "white".white
    $stdout = old_stdout
    assert_equal "\e[0;31;49mred\e[0m \e[0;37;49mwhite\e[0m\n", captured_stdio.string
  end

  def test_dislay_D_colorized
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show "red".red+ " " + "white".white, :colorized
    $stdout = old_stdout
    assert_equal "\e[0;31;49mred\e[0m \e[0;37;49mwhite\e[0m\n", captured_stdio.string
  end

  def test_dislay_E_error
    result = ToolsDisplay.show []
    assert_equal "Array", result
  end


end