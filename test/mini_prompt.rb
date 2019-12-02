class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_prompt_A_yes?
    mock = MiniTest::Mock.new
    def mock.yes?(*_args)
      true
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.yes? 'Continue'), true
    end
  end

  def test_prompt_B_no?
    mock = MiniTest::Mock.new
    def mock.no?(*_args)
      true
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.no? 'Continue'), true
    end
  end

  def test_prompt_C_ask
    mock = MiniTest::Mock.new
    def mock.ask(*_args)
      'teste'
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.ask 'Name'), 'teste'
    end
  end

  def test_prompt_D_mask
    mock = MiniTest::Mock.new
    def mock.mask(*_args)
      'teste'
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.mask 'Name'), 'teste'
    end
  end

  def test_prompt_E_expand
    mock = MiniTest::Mock.new
    def mock.expand(*_args)
      :yes
    end
    TTY::Prompt.stub :new, mock do
      choices = [{
        key: 'Y',
        name: 'Overwrite',
        value: :yes
      }, {
        key: 'n',
        name: 'Skip',
        value: :no
      }]
      assert_equal (ToolsPrompt.expand 'Overwirte Gemfile?', choices), :yes
    end
  end

  def test_prompt_F_select
    mock = MiniTest::Mock.new
    def mock.select(*_args)
      'vodka'
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.select 'Select drinks?', 'vodka', 'beer'), 'vodka'
    end
  end

  def test_prompt_G_multi_select
    mock = MiniTest::Mock.new
    def mock.multi_select(*_args)
      'vodka'
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.multi_select 'Select drinks?', 'vodka', 'beer'), 'vodka'
    end
  end

  def test_prompt_G_enum_select
    mock = MiniTest::Mock.new
    def mock.enum_select(*_args)
      'vodka'
    end
    TTY::Prompt.stub :new, mock do
      assert_equal (ToolsPrompt.enum_select 'Select drinks?', 'vodka', 'beer'), 'vodka'
    end
  end
end
