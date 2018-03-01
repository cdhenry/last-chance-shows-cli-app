
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "last_chance_shows/version"

Gem::Specification.new do |spec|
  spec.name          = "last_chance_shows"
  spec.version       = LastChanceShows::VERSION
  spec.authors       = ["'Chris Henry'"]
  spec.email         = ["'cdhenry@gmail.com'"]

  spec.summary       = %q{This gem will help you find theater shows that are closing soon New York City.}
  spec.description   = %q{This gem will help you find theater shows that are closing soon New York City.  It will scrape Playbill.com for shows that are closing soon, allow you to select a show you're interested in, and deliver back more information on the show.  (ie. synopsis, days and times, runtime, etc...)}
  spec.homepage      = "https://github.com/cdhenry/cli-data-gem-assessment-v-000.git"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  spec.add_dependency "nokogiri"
end
