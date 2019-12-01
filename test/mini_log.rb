class ToolsModuleTest < Minitest::Test

  def self.test_order
    :sorted
  end

  def test_log_A
    ToolsFiles.remove_file (File.dirname __dir__) + '/teste.log'
    ToolsLog.create_log_file 'test', (File.dirname __dir__) + '/teste.log'
    ToolsLog.create_log_file 'test', (File.dirname __dir__) + '/teste.log'
    FileUtils.touch (File.dirname __dir__) + '/teste.log', :mtime => (Time.now - 86400)
    ToolsLog.test_info  'Minitest.: test_log'
    ToolsLog.test_warn  'Minitest.: test_log'
    ToolsLog.test_error 'Minitest.: test_log'
    ToolsLog.test_debug 'Minitest.: test_log'
    ToolsLog.test_ucolor 'Minitest.: test_log'
    ToolsLog.test_ucolorx 'Minitest.: test_log'
    ToolsFiles.remove_file (File.dirname __dir__) + '/teste.log'
  end

end