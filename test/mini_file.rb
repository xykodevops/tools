class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_file_A_purge
    mock = MiniTest::Mock.new
    def mock.delete(*_args)
      Array
    end
    File.stub :delete, mock do
      assert_equal (ToolsFiles.purge_files (File.dirname __dir__) + '/pkg', '*.gem', 1).class, Array
    end
  end

  def test_file_B_create_dir
    mock = MiniTest::Mock.new
    def mock.mkdir(*_args)
      String
    end
    Dir.stub :mkdir, mock do
      assert_equal (ToolsFiles.create_dir (File.dirname __dir__) + '/pkg', 'minitest').class, String
      assert_equal (ToolsFiles.create_dir (File.dirname __dir__) + '/pkg2', 'minitest').class, String
    end
  end

  def test_file_C_create_delete_file
    ToolsFiles.create_file (File.dirname __dir__), '/create_file', 'teste'
    ToolsFiles.remove_file (File.dirname __dir__) + '/create_file'
  end

  def test_file_D_load_file
    file = (File.dirname __dir__) + '/TODO.txt'
    result = ToolsFiles.load_file file
    assert_equal result.class, File
  end

  def test_file_F_load_file
    mock = MiniTest::Mock.new
    mock.expect :exists?, true
    mock.expect :open, true
    file = (File.dirname __dir__) + '/TODO'
    assert_nil (ToolsFiles.load_file file), nil
  end

  def test_file_G_open_file

    mock = MiniTest::Mock.new
    def mock.open(*_args)
      true
    end
    TTY::Editor.stub :open, mock do
      file = (File.dirname __dir__) + '/TODO.txt'
      ToolsFiles.open_file file, :vi
      ToolsFiles.open_file file
    end
  end


end
