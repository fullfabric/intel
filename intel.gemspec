$:.push File.expand_path("../lib", __FILE__)

require "intel/version"

Gem::Specification.new do |s|
  s.name        = "intel"
  s.version     = Intel::VERSION
  s.authors     = ["Luis Corrêa d'Almeida"]
  s.email       = ["luis.ca@gmail.com"]

  s.summary     = "Intel"

  s.add_dependency "mongo"
  s.add_dependency "bson"
  s.add_dependency "bson_ext"
  s.add_dependency "mongo_mapper"
  s.add_dependency "mongo_ext"

  s.add_development_dependency "rspec"
  s.add_development_dependency "faker"

  s.files = Dir["{app,config,lib}/**/*"]
  # s.require_path = 'lib'

end