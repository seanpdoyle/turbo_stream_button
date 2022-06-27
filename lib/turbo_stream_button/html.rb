module TurboStreamButton
  module Html
    def self.merge_token_lists(default, override)
      token_list = Set[*override.to_s.split]

      token_list.add(*default.to_s.split)

      token_list.to_a.join(" ")
    end

    def self.deep_merge_attributes(default, **attributes)
      default.deep_merge(attributes) do |key, default, attribute|
        if key.to_s.in? %w[controller action]
          merge_token_lists(default, attribute)
        else
          attribute
        end
      end
    end
  end
end
