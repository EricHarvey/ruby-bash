Gem::Specification.new do |s|
  s.name        = 'infrmd'
  s.version     = '0.0.1'
  s.executables << 'infrmd'
  s.date        = '2019-11-26'
  s.summary     = 'Why is there a summary and descriptions'
  s.description = 'Utils for stuff'
  s.authors     = ['Eric Harvey']
  s.email       = 'eric.harvey@driveinformed.com'
  s.files       = ['lib/infrmd.rb']
  s.license = 'MIT'
  s.add_dependency 'colorize', '0.8.1'
  s.add_dependency 'pry-byebug', '3.7.0'
  s.add_dependency 'redis', '4.1.1'
end
