# Load core classes and deps patches
$LOAD_PATH.unshift File.expand_path("stubs", __dir__)

# Misc patches
# Make gem no-op
define_singleton_method(:gem) { |*| nil }

class Thread
  def self.new(...)
    f = Fiber.new(...)
    def f.value = resume
    f
  end
end

