module TurboStreamButton
  class Button < Builder
    def initialize(view_context)
      super(view_context, "button", data: {
        controller: "turbo-stream-button",
        action: "click->turbo-stream-button#evaluate"
      })
    end

    def template
      Builder.new(@view_context, "template", data: {
        turbo_stream_button_target: "turboStreams"
      })
    end

    def template_tag(...)
      template.tag(...)
    end

    def turbo_streams(&block)
      if block
        @turbo_streams = @view_context.capture(&block)
        nil
      else
        @turbo_streams
      end
    end
  end
end
