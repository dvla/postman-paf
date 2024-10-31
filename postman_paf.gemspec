# frozen_string_literal: true

require_relative 'lib/postman_paf/version'

Gem::Specification.new do |spec|
  spec.name          = 'postman_paf'
  spec.version       = PostmanPAF::VERSION
  spec.authors       = ['Driver and Vehicle Licensing Agency (DVLA)', 'Mark Isaac']
  spec.email         = ['mark.isaac@dvla.gov.uk']

  spec.summary       = 'Converts Royal Mail PAF (Postcode Address File) addresses to a printable format.'
  spec.description   = 'Unofficial gem to apply Royal Mail Rules & Exceptions when formatting PAF addresses.'

  spec.homepage = 'https://github.com/dvla/postman-paf'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency 'simple_symbolize', '~> 4.0'
end
