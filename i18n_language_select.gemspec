# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i18n_language_select/version'

Gem::Specification.new do |spec|
  spec.name          = "i18n_language_select"
  spec.version       = I18nLanguageSelect::VERSION
  spec.authors       = ["Adam St. John"]
  spec.email         = ["astjohn@gmail.com"]
  spec.homepage      = "https://github.com/Sitata/i18n_language_select"
  spec.summary       = "I18n language select helper"
  spec.description   = "A simple language code select helper that works with I18n translations."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "threach"
end
