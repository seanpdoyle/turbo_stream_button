require "bundler/setup"

require "bundler/gem_tasks"

require "rails/test_unit/runner"
require "standard/rake"

namespace :test do
  task :prepare do
    system("yarn install")
  end

  desc "Runs all tests, including system tests"
  task all: %w[test test:system]

  desc "Run system tests only"
  task system: %w[test:prepare] do
    Rails::TestUnit::Runner.rake_run(["test/system"])
  end
end
