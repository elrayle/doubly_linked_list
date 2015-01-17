# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'doubly_linked_list'
  spec.version       = '0.0.1'
  spec.authors       = ["E. Lynette Rayle"]
  spec.email         = ["elr37@cornell.edu"]
  spec.platform      = Gem::Platform::RUBY
  spec.summary       = %q{Ruby implementation of doubly_linked_lists using an array to hold and manipulate items.}
  spec.description   = %q{Ruby implementation of doubly_linked_lists using an array to hold and manipulate items.}
  spec.homepage      = "https://github.com/elrayle/doubly_linked_list"
  spec.license       = "APACHE2"
  spec.required_ruby_version     = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency('pry')
  # spec.add_development_dependency('pry-byebug')    # Works with ruby > 2
  # spec.add_development_dependency('pry-debugger')  # Works with ruby < 2
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('coveralls')

  spec.extra_rdoc_files = [
      "LICENSE.txt",
      "README.md"
  ]
end

