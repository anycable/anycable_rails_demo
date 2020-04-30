# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # Exclude certain gems from backtrace
  unless ENV["FULLTRACE"]
    config.filter_gems_from_backtrace "factory_bot"
    config.filter_gems_from_backtrace "test-prof"
  end

  # Always include the spec itself to the backtrace.
  # That also helps to avoid a full stack printing when
  # everything have been filtered out.
  config.backtrace_inclusion_patterns << %r{/spec/}

  config.order = :random
  Kernel.srand config.seed
end
