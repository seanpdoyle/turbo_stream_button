module TurboStreamButton
  module Html # :nodoc:
    def self.deep_merge_attributes(view_context, default, attributes)
      default.deep_merge(attributes) do |key, default_value, attribute|
        if key.to_s.in? %w[controller action]
          view_context.token_list(default_value, attribute)
        else
          attribute
        end
      end
    end
  end
end
