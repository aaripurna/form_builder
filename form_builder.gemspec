$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "form_builder/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "form_builder"
  spec.version     = FormBuilder::VERSION
  spec.authors     = ["Nawa"]
  spec.email       = ["nap.aripurna@gmail.com"]
  spec.homepage    = "https://github.com/aaripurna/form_builder"
  spec.summary     = "A handy heplper for building a form"
  spec.description = "Form builder you'd love"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0.0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry-rails"
end
