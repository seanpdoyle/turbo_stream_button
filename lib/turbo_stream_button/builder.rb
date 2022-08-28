module TurboStreamButton
  class Builder
    def initialize(view_context, tag_name, **attributes)
      @view_context = view_context
      @tag_name = tag_name
      @attributes = attributes
    end

    def tag(*arguments, **overrides, &block)
      @view_context.content_tag(@tag_name, *arguments, **Html.deep_merge_attributes(overrides, **@attributes), &block)
    end

    def merge(overrides)
      Builder.new(@view_context, @tag_name, Html.deep_merge_attributes(overrides, **@attributes))
    end

    def deep_merge(overrides)
      merge(overrides)
    end

    def to_h
      @attributes.to_h
    end

    def to_hash
      @attributes.to_hash
    end
  end
end
