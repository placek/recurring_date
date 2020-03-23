lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recurring_date/version'

Gem::Specification.new do |spec|
  spec.name        = 'recurring_date'
  spec.version     = RecurringDate::VERSION
  spec.authors     = ['Paweł Placzyński']
  spec.email       = ['placzynski.pawel@gmail.com']

  spec.summary     = %q{Dates enumerator with conditions}
  spec.description = %q{Iterate over a set of dates, giving an iteration conditions.}
  spec.homepage    = 'https://rubygems.org/gems/recurring_date'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri']    = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/placek/recurring_date'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake',    '~> 12.3'
  spec.add_development_dependency 'rspec',   '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80'
end
