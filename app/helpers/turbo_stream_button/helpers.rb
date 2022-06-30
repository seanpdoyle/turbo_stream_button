module TurboStreamButton
  module Helpers
    def turbo_stream_button_tag(**attributes, &block)
      render("turbo_stream_button", **attributes, &block)
    end
  end
end
