require "application_system_test_case"

class IntegrationTest < ApplicationSystemTestCase
  test "Say Hello: Inserts message after #hello-button" do
    message = "Hello, from a Turbo Stream"

    visit examples_path(message: message)
    within_section "Say Hello" do
      assert_no_status message

      click_on "Say hello"

      assert_status message
    end
  end

  test "Copy to Clipboard: Announces that the code is copied to the clipboard" do
    message = %(Copied "invitation-code-abc123" to clipboard.)

    visit examples_path(invitation_code: "invitation-code-abc123")

    within_section "Copy to Clipboard" do
      assert_no_status message

      click_on "Copy to clipboard"

      within(:alert) { assert_status message }
    end
  end

  test "Nesting: appends a nested `turbo_stream_button`" do
    message = "Hello, from a Turbo Stream"

    visit examples_path(message: message)
    within_section "Nesting" do
      assert_no_status message

      click_on "Append to flash"

      within(:alert) { assert_status message }

      within(:alert) { click_on "Dismiss" }

      assert_no_status message
    end
  end

  test "Form fields: appends fields" do
    visit examples_path
    within_section "Form fields" do
      within_fieldset "References" do
        assert_no_field

        click_on "Add reference"

        assert_field "Referrer", count: 1
        assert_field "Relationship", count: 1

        click_on "Add reference"

        assert_field "Referrer", count: 2
        assert_field "Relationship", count: 2

        click_on "Add reference"

        assert_field "Referrer", count: 3
        assert_field "Relationship", count: 3
      end
    end
  end

  def assert_status(text, **options, &block)
    assert_selector(%([role="status"]), text: text, **options, &block)
  end

  def assert_no_status(text, **options, &block)
    assert_no_selector(%([role="status"]), text: text, **options, &block)
  end
end
