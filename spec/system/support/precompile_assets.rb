# frozen_string_literal: true

# Precompile assets before running tests to avoid timeouts.
# Do not precompile if webpack-dev-server is running (NOTE: MUST be launched with RAILS_ENV=test)
RSpec.configure do |config|
  # Skip assets precompilcation if we exclude system specs.
  next if config.filter.opposite.rules[:type] == "system" || config.exclude_pattern.match?(%r{spec/system})

  config.before(:suite) do
    if Webpacker.dev_server.running?
      $stdout.puts "\n⚙️  Webpack dev server is running! Skip assets compilation.\n"
      next
    else
      $stdout.puts "\n🐢  Precompiling assets.\n"
      original_stdout = $stdout.clone
      # Use test-prof now 'cause it couldn't be monkey-patched (e.g., by Timecop or similar)
      start = Time.current
      begin
        # Silence Webpacker output
        $stdout.reopen(File.new("/dev/null", "w"))
        # next 3 lines to compile webpacker before running our test suite
        require "rake"
        Rails.application.load_tasks
        Rake::Task["webpacker:compile"].execute
      ensure
        $stdout.reopen(original_stdout)
        $stdout.puts "Finished in #{(Time.current - start).round(2)} seconds"
      end
    end
  end
end
