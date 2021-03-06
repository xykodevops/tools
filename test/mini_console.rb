class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_console_A_run_console
    mock = MiniTest::Mock.new
    def mock.start(*_args)
      true
    end
    Prompt::Console.stub :start, mock do
      assert_equal ToolsConsole.create_console.class, Array
      assert_equal (ToolsConsole.exec_console ['test']), true
      assert_equal (ToolsConsole.exec_console ['tes']), false
      ToolsConsole.run_console
    end
  end
end
