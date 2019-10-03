# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tools/version'

Gem::Specification.new do |spec|
  spec.name          = "tools"
  spec.version       = Tools::VERSION
  spec.authors       = ["Xyko"]
  spec.email         = ["xykoglobo@corp.globo.com"]
  spec.summary       = %q{Tools for developers.}
  spec.description   = %q{A set of tools to assist developer.}
  spec.homepage      = Tools::HOMEPAGE
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'byebug'

  spec.add_runtime_dependency 'awesome_print'
  spec.add_runtime_dependency 'colorize'
  spec.add_runtime_dependency 'dnsruby'
  spec.add_runtime_dependency 'encrypt'
  spec.add_runtime_dependency 'gem-man'
  spec.add_runtime_dependency 'highline'
  spec.add_runtime_dependency 'i18n'
  spec.add_runtime_dependency 'ipaddress'
  spec.add_runtime_dependency 'ipcalc'
  spec.add_runtime_dependency 'logger'
  spec.add_runtime_dependency 'net-ssh'
  spec.add_runtime_dependency 'net-ping'
  spec.add_runtime_dependency 'netaddr', '~> 1.5', '>= 1.5.0'
  spec.add_runtime_dependency 'persistent-cache'
  spec.add_runtime_dependency 'progress_bar'
  spec.add_runtime_dependency 'prompt'
  spec.add_runtime_dependency 'public_suffix'
  spec.add_runtime_dependency 'rest-client'
  spec.add_runtime_dependency 'ruby-progressbar'
  spec.add_runtime_dependency 'similar_text'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'tty-editor'
  spec.add_runtime_dependency 'tty-prompt'
  spec.add_runtime_dependency 'xml-simple'

  spec.required_ruby_version = '>= 2.4.0'

end
