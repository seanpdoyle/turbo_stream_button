source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in turbo_stream_button.gemspec.
gemspec

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

rails_version = ENV.fetch("RAILS_VERSION", "7.0")

if rails_version == "main"
  rails_constraint = { github: "rails/rails" }
else
  rails_constraint = "~> #{rails_version}.0"
end

gem "rails", rails_constraint
gem "sprockets-rails"

gem "puma"
gem "rexml"

group :test do
  gem "capybara"
  gem "capybara_accessible_selectors", github: "citizensadvice/capybara_accessible_selectors", branch: "main"
  gem "selenium-webdriver"
  gem "webdrivers"
end
