require './lib/wrappable/version'

Gem::Specification.new do |s|
  s.name = "wrappable"
  s.version = Wrappable.version
  s.authors = ["Jay Adkisson"]
  s.email = ["jay@goodguide.com"]
  s.summary = "Wrap all of the things"
  s.description = "a generic module that provides an idempotent wrapper."
  s.homepage = "http://github.com/jayferd/wrappable"
  s.rubyforge_project = "wrappable"
  s.files = Dir['Gemfile', 'wrappable.gemspec', 'lib/**/*.rb']

  # no dependencies
end
