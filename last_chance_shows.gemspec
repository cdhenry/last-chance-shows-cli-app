require_relative './lib/last_chance_shows/version'

Gem::Specification.new do |s|
  s.name        = 'last-chance-shows'
  s.version     = LastChanceShows::VERSION
  s.date        = '2018-03-01'
  s.summary     = "Last Chance Shows in NYC"
  s.description = "Helps find theater shows that are closing soon New York City."
  s.authors     = ["Chris Henry"]
  s.email       = 'cdhenry@gmail.com'
  s.files       = `git ls-files -z`.split("\x0").reject do |f|
                    f.match(%r{^(test|spec|features)/})
                  end
  s.homepage    = 'https://github.com/cdhenry/cli-data-gem-assessment-v-000/last_chance_shows.git'
  s.license     = 'MIT'
  s.executables << 'last-chance-shows'

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", ">= 0"
  s.add_development_dependency "nokogiri", ">= 0"
  s.add_development_dependency "pry", ">= 0"
end
