class ToolsModuleTest < Minitest::Test

  def self.test_order
    :sorted
  end

  def test_cache_A_all_operators
    ToolsFiles.remove_file '/home/francisco/2018/xykotools/tools/teste-persistent.cache'
    ToolsCache.create_cache_file 'tools',  (File.dirname __dir__) + '/teste-persistent.cache', 60
    assert_equal ToolsCache.tools_list, {}
    ToolsCache.tools_set :k1, 100
    assert_equal ToolsCache.tools_list, {:k1 => 100}
    ToolsCache.tools_unset :k1
    assert_equal ToolsCache.tools_list, {}
    ToolsCache.tools_set :k2, {:i => 100, :j => 200}
    ToolsCache.tools_set :k2, {:l => 100, :m => 200}
    ToolsCache.tools_set :k3, []
    ToolsCache.tools_set :k3, [1,2,3]
    ToolsCache.tools_set :k3, [4, ['a','b']]
    assert_equal (ToolsCache.tools_get :k3), [1,2,3,4,['a','b']]
    assert_equal (ToolsCache.tools_get :k2), {:i => 100, :j => 200,:l => 100, :m => 200}
    ToolsCache.tools_clear
    assert_equal ToolsCache.tools_list, {}
    ToolsFiles.remove_file '/home/francisco/2018/xykotools/tools/teste-persistent.cache'
  end


end