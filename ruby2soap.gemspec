Gem::Specification.new do |s|
  s.name        = 'ruby2soap'
  s.version     = '0.0.1'
  s.date        = '2014-04-10'
  s.summary     = "Communication between ruby and soap services"
  s.description = "enable communication between ruby and soap services"
  s.authors     = ["Eric Feldman"]
  s.email       = 'ericfeldman93@gmail.com'
  s.files       = Dir.glob("{lib,test}/**/*")
  s.require_path = "lib"
  s.homepage    = 'https://github.com/ericman93/ruby2soap'
  s.platform = Gem::Platform::RUBY
  s.add_dependency("xml-simple")
  s.add_dependency("httpi")
end