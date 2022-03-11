# -*- encoding: utf-8 -*-
# stub: zurb-foundation 4.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "zurb-foundation".freeze
  s.version = "4.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["ZURB".freeze]
  s.date = "2013-09-23"
  s.description = "ZURB Foundation on Sass/Compass".freeze
  s.email = ["foundation@zurb.com".freeze]
  s.homepage = "http://foundation.zurb.com".freeze
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "ZURB Foundation on Sass/Compass".freeze

  s.installed_by_version = "3.0.3.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sass>.freeze, [">= 3.2.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<jasmine>.freeze, [">= 0"])
    else
      s.add_dependency(%q<sass>.freeze, [">= 3.2.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<jasmine>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<sass>.freeze, [">= 3.2.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<jasmine>.freeze, [">= 0"])
  end
end
