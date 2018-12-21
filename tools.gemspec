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

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.10", '>= 5.10.2'

  spec.add_runtime_dependency 'gem-man', '~> 0.3', '>= 0.3.0'
  spec.add_runtime_dependency 'awesome_print'
  spec.add_runtime_dependency 'colorize', '~> 0.7.7'
  spec.add_runtime_dependency 'prompt', '~> 1.2', '>= 1.2.2'
  spec.add_runtime_dependency 'i18n', '~> 0.7', '>= 0.7.0'
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rest-client', '~> 1.8', '>= 1.8.0'
  spec.add_runtime_dependency 'net-ssh'
  spec.add_runtime_dependency 'ipcalc', '~> 1.0', '>= 1.0.0'
  spec.add_runtime_dependency 'ipaddress', '~> 0.8', '>= 0.8.0'
  spec.add_runtime_dependency 'netaddr', '~> 1.5', '>= 1.5.0'
  spec.add_runtime_dependency 'xml-simple', '~> 1.1', '>= 1.1.5'
  spec.add_runtime_dependency 'dnsruby'
  spec.add_runtime_dependency 'public_suffix'
  spec.add_runtime_dependency 'highline'
  spec.add_runtime_dependency 'ruby-progressbar'
  spec.add_runtime_dependency 'tty-prompt', '~> 0.7', '>= 0.7.1'
  spec.add_runtime_dependency 'encrypt', '~> 0.1', '>= 0.1.0'
  spec.required_ruby_version = '>= 2.2.0'
  
end
