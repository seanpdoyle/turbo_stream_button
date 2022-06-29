module TurboStreamButton
  class Engine < ::Rails::Engine
    initializer "turbo_stream_button.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[
          turbo_stream_button.js
        ]
      end
    end

    initializer "turbo_stream_button.action_view" do |app|
      ActiveSupport.on_load :action_view do
        include TurboStreamButton::Helpers
      end
    end
  end
end
