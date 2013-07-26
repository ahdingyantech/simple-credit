require './lib/simple-credit/version'

Gem::Specification.new do |s|
  s.name        = "simple-credit"
  s.version     = SimpleCredit::VERSION
  s.summary     = "Simple user credit library."
  s.description = "A Simple user credit library for ActiveRecord."
  s.authors     = ["Kaid Wong"]
  s.email       = "kaid@kaid.me"
  s.files       = Dir.glob("lib/**/*[^(~|#)]") + %w(simple-credit.gemspec)
  s.homepage    = "http://github.com/kaid/simple-credit"

  s.required_ruby_version = ">= 1.9.2"
  s.add_dependency("activerecord", "3.2.12")

  s.add_development_dependency("sqlite3", "~> 1.3.7")
  s.add_development_dependency("factory_girl", "~> 4.2.0")
  s.add_development_dependency("database_cleaner", "~> 0.9.1")
  s.add_development_dependency("rspec", "~> 2.13.0")
end
