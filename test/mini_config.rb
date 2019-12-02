class ToolsModuleTest < Minitest::Test
  def self.test_order
    :sorted
  end

  def test_config_A_before
    ToolsFiles.remove_file (File.dirname __dir__) + '/tools_yaml.config'
    ToolsFiles.remove_file (File.dirname __dir__) + '/tools_json.config'
  end

  def test_config_B_create
    ToolsConfig.create_config_file 'tools_yaml', (File.dirname __dir__) + '/tools_yaml.config', :yaml, first_time: true
    ToolsConfig.create_config_file 'tools_json', (File.dirname __dir__) + '/tools_json.config', :json, first_time: true
    ToolsConfig.create_config_file 'tools_json', (File.dirname __dir__) + '/tools_json.config', :json, first_time: true
  end

  def test_config_C_load
    ToolsConfig.load_config (File.dirname __dir__) + '/tools_yaml.config'
    ToolsConfig.load_config (File.dirname __dir__) + '/tools_json.config'
  end

  def test_config_D_insert
    ToolsConfig.insert_in_config (File.dirname __dir__) + '/tools_yaml.config', first_time: false
    ToolsConfig.insert_in_config (File.dirname __dir__) + '/tools_json.config', first_time: false
  end

  def test_config_E_change
    ToolsConfig.change_value_in_config (File.dirname __dir__) + '/tools_yaml.config', true, :first_time
    ToolsConfig.change_value_in_config (File.dirname __dir__) + '/tools_json.config', true, :first_time
  end

  def test_config_F_after
    ToolsFiles.remove_file (File.dirname __dir__) + '/tools_yaml.config'
    ToolsFiles.remove_file (File.dirname __dir__) + '/tools_json.config'
  end

end
