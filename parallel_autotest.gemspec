$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "parallel_autotest"
  s.version     = "0.0.1"
  s.authors     = ["mobilityView (James Roscoe)"]
  s.email       = ["james.roscoe@mobilityview.com"]
  s.homepage    = "http://github.com/mobilityView/parallel_autotest"
  s.summary     = "Usage: rake autotest"
  s.description = "Run tests when files saved in editor using multiple processes"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  # s.test_files = Dir["test/**/*"]
end
