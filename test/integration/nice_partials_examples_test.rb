require "test_helper"

class NicePartialsExamplesTest < ActionDispatch::IntegrationTest
  def self.test(*arguments, **options, &block)
    if ENV["NICE_PARTIALS"].to_i.zero?
      super(*arguments, **options) { skip }
    else
      super(*arguments, **options, &block)
    end
  end

  test "renders button content and default attributes" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button" do |button| %>
        <%= button.content_for :content do %>
          <span>Button text</span>
        <% end %>
        <%= button.content_for :turbo_streams do %>
          <turbo-stream action="remove" target="an_element"></turbo-stream>
        <% end %>
      <% end %>
    ERB

    within(:button, type: "button") do
      assert_css "span", text: "Button text"
      assert_css(%(template[data-turbo-stream-button-target~="turboStreams"]), visible: :all)
    end
  end
end
