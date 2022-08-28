require "bundler/setup"

require "bundler/gem_tasks"

require "rails/test_unit/runner"
require "standard/rake"

namespace :test do
  task :prepare do
    system("yarn install")
  end

  desc "Runs all tests, including system tests"
  task all: %w[test:unit test:system]

  desc "Run unit tests only"
  task :unit do
    $: << "test"

    Rails::TestUnit::Runner.rake_run(["test"])
  end

  desc "Run system tests only"
  task system: %w[test:prepare] do
    $: << "test"

    Rails::TestUnit::Runner.rake_run(["test/system"])
  end
end
