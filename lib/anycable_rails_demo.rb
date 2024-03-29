ENV["RAILS_ENV"] ||= "production"
ENV["PATH"] = ""

$LOADED_FEATURES << $LOAD_PATH.resolve_feature_path("anycable/rpc")[1]
$LOADED_FEATURES << $LOAD_PATH.resolve_feature_path("drb/unix")[1]

ENV["ACTIVE_RECORD_ADAPTER"] ||= "nulldb"
ENV["SECRET_KEY_BASE"] = "secret"

require_relative "rails-wasm-shim/rails-wasm-shim"
require_relative "../config/environment"
