module TurboStreamButton
  class Button
    def initialize(view_context)
      @view_context = view_context
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
