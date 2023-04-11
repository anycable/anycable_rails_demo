Rails.application.config.session_store(
  :redis_session_store,
  key: "_session_#{Rails.env}",
  serializer: :json,
  domain: :all,
  redis: {
    expire_after: 1.year,
    # ttl: 1.year,
    key_prefix: "anycable_rails_demo:session:",
    url: ENV["ANYCABLE_REDIS_URL"]
  }
)
