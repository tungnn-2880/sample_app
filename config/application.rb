require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :vi
    config.time_zone = "Hanoi"
    config.action_mailer.raise_delivery_errors = false
    # Action mailer settings
    host = "localhost:3000"
    config.action_mailer.default_url_options = {host: host, protocol: :http}
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      user_name: Settings.gmail.username,
      password: Settings.gmail.password,
      authentication: "plain",
      enable_starttls_auto: true
    }
  end
end
