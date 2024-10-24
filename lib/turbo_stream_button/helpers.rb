module TurboStreamButton
  module Helpers
    def turbo_stream_button
      TurboStreamButton::Button.new(self)
    end

    def turbo_stream_button_tag(**attributes, &)
      render("application/turbo_stream_button", **attributes, &)
    end
  end
end
