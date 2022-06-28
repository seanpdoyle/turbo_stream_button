source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in turbo_stream_button.gemspec.
gemspec

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

rails_version = ENV.fetch("RAILS_VERSION", "7.0")

rails_constraint = if rails_version == "main"
  {github: "rails/rails"}
else
  "~> #{rails_version}.0"
end

if ENV["NICE_PARTIALS"].to_i.positive?
  gem "nice_partials"
end

gem "rails", rails_constraint
gem "sprockets-rails"

gem "puma"
gem "rexml"
gem "standard"

group :test do
  gem "action_dispatch-testing-integration-capybara",
    github: "thoughtbot/action_dispatch-testing-integration-capybara", tag: "v0.1.0",
    require: "action_dispatch/testing/integration/capybara/minitest"
  gem "capybara"
  gem "capybara_accessible_selectors", github: "citizensadvice/capybara_accessible_selectors", branch: "main"
  gem "selenium-webdriver"
  gem "webdrivers"
end
