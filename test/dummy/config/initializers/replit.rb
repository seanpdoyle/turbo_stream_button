Rails.application.configure do
  repl_slug, repl_owner = ENV.values_at("REPL_SLUG", "REPL_OWNER")

  if repl_slug.present? && repl_owner.present?
    config.action_controller.allow_forgery_protection = false
    config.action_controller.default_url_options = { host: "#{repl_slug}.#{repl_owner}.repl.co" }

    config.session_store :cookie_store, same_site: :none, secure: true

    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWFROM replit.com",
      "Access-Control-Allow-Origin" => "repl.co",
    }

    config.hosts << /.*\.repl.co/
  end
end
