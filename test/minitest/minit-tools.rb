#!/usr/bin/env ruby
# coding: utf-8
require 'rubygems'
require 'tools'
require 'minitest/autorun'

class ToolsModuleTest < Minitest::Test

  def test_tool_base
    assert_equal  1, 1
  end

  def test_tools_get_date
    now = DateTime.now
    (ToolsUtil.get_date '%Y %m %d %H %M').split(' ').each do |d|
      assert_equal (now.to_s.include? d), true
    end
  end

  def test_tools_set_get_variable
    ToolsUtil.set_variable 'teste', 'A'
    assert_equal (ToolsUtil.get_variable 'teste'), 'A'
  end

  def test_tools_set_get_variable_ext
    ToolsUtil.set_variable 'teste_string', ""
    ToolsUtil.set_variable 'teste_array', []
    ToolsUtil.set_variable 'teste_hash', {}
    ToolsUtil.set_variable_ext 'teste_string', "A"
    ToolsUtil.set_variable_ext 'teste_array', "1"
    ToolsUtil.set_variable_ext 'teste_hash', {:teste => 'teste'}
    assert_equal (ToolsUtil.get_variable 'teste_string'), 'A'
    assert_equal (ToolsUtil.get_variable 'teste_array'), ['1']
    assert_equal (ToolsUtil.get_variable 'teste_hash'), {:teste => 'teste'}
  end

  def test_tools_string_encrypt
    encrypt = "teste do encrypt".encrypt 'tools000'
    assert_equal (encrypt.decrypt 'tools000'), "teste do encrypt"
  end

  def test_tools_string_fix
    assert_equal  " ".fix(10), "          "
  end

  def test_tools_string_nil_true
    teste = nil
    assert_equal  teste.nil? , true
  end

  def test_tools_string_nil_false
    teste = String.new
    assert_nil  teste.nil?
  end

  def test_tools_boolean_true
    teste = true
    assert_equal  teste.boolean?, true
  end

  def test_tools_boolean_true
    teste = ""
    assert_equal  teste.boolean?, false
  end


end