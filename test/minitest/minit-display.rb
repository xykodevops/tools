#!/usr/bin/env ruby
# coding: utf-8
require 'rubygems'
require 'tools'
require 'minitest/autorun'

class ToolsModuleTest < Minitest::Test

  def test_cmdapi_dislay
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show "TEXTO VERDE", :green
    $stdout = old_stdout
    assert_equal "\e[0;32;49mTEXTO VERDE\n\e[0m", captured_stdio.string
  end

  def test_cmdapi_dislay_sameline
    ToolsDisplay.instance
    old_stdout = $stdout
    captured_stdio = StringIO.new('', 'w')
    $stdout = captured_stdio
    ToolsDisplay.show "TEXTO SAMELINE", :sameline
    $stdout = old_stdout
    assert_equal "\e[0;39;49mTEXTO SAMELINE\e[0m", captured_stdio.string
  end

end