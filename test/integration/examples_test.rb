require "test_helper"

class ExamplesTest < ActionDispatch::IntegrationTest
  test "renders button content and default attributes" do
    post examples_path, params: {template: <<~ERB}
      <%= render("turbo_stream_button") { "Button contents" } %>
    ERB

    assert_button("Button contents", type: "button")
  end

  test "renders button with type: override" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button", type: "submit" %>
    ERB

    assert_button(type: "submit")
  end

  test "renders turbo streams" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button" %>
    ERB

    within(:button) do
      assert_css(%(template[data-turbo-stream-button-target~="turboStreams"]), visible: :all)
    end
  end

  test "does not duplicate turbo_streams contents when captured within <%= %>" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button" do |button| %>
        <%= button.turbo_streams do %>
          Only once
        <% end %>
      <% end %>
    ERB

    assert_equal ["Only once"], response.body.scan(/Only once/)
  end

  test "merges [data-controller] attribute" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button", data: { controller: "my-controller" } %>
    ERB

    assert_button(type: "button") do |button|
      assert_equal "turbo-stream-button my-controller", button["data-controller"]
    end
  end

  test "merges [data-action] attribute" do
    post examples_path, params: {template: <<~ERB}
      <%= render "turbo_stream_button", data: { action: "click->my-controller#action" } %>
    ERB

    assert_button(type: "button") do |button|
      assert_equal "click->turbo-stream-button#evaluate click->my-controller#action", button["data-action"]
    end
  end
end
