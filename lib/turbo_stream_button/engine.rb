module TurboStreamButton
  class Engine < ::Rails::Engine
    initializer "turbo_stream_button.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[
          turbo_stream_button.js
        ]
      end
    end
  end
end
