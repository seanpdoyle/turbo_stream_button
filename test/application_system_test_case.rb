require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, using: :chrome, screen_size: [1400, 1400]

  def self.debug!
    driven_by :cuprite, using: :chrome, screen_size: [1400, 1400], options: {headless: false}
  end
end

Capybara.server = :puma, {Silent: true}
