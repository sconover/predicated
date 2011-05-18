# -*- encoding: utf-8 -*-
require File.expand_path('../lib/predicated/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name      = "predicated"
  s.version   = Predicated::VERSION
  s.authors   = ["Steve Conover", "Alex Chaffee"]
  s.email     = "sconover@gmail.com"
  s.homepage  = "http://github.com/sconover/predicated"
  s.summary   = "Predicated is a simple predicate model for Ruby"
  s.description  = <<-EOS.strip
Predicated is a simple predicate model for Ruby.
  EOS
  s.rubyforge_project = "predicated"

  s.files      = Dir['lib/**/*']
  s.test_files = Dir['test/**/*.rb']

  s.extra_rdoc_files = %w[README.markdown]
end
