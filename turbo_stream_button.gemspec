require_relative "lib/turbo_stream_button/version"

Gem::Specification.new do |spec|
  spec.name = "turbo_stream_button"
  spec.version = TurboStreamButton::VERSION
  spec.authors = ["Sean Doyle"]
  spec.email = ["sean.p.doyle24@gmail.com"]
  spec.homepage = "https://github.com/seanpdoyle/turbo_stream_button"
  spec.summary = "Drive client-side interactions with Turbo Streams"
  spec.description = "Combine built-in Button elements and Turbo Streams to drive client-side interactions through declarative HTML"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/seanpdoyle/turbo_stream_button"
  spec.metadata["changelog_uri"] = "https://github.com/seanpdoyle/turbo_stream_button/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "zeitwerk"
end
