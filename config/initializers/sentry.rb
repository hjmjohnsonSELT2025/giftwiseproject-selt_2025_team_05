# config/initializers/sentry.rb
# Error tracking and performance monitoring with Sentry

if Rails.env.production? && ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']

    # Set the environment
    config.environment = Rails.env

    # Enable breadcrumbs for better debugging context
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Sample rate for performance monitoring (0.0 to 1.0)
    # 0.2 = 20% of transactions are captured
    config.traces_sample_rate = 0.2

    # Capture user information when available
    config.send_default_pii = true

    # Filter sensitive parameters
    config.before_send = lambda do |event, hint|
      # You can modify or filter events here if needed
      event
    end
  end
end
