# frozen_string_literal: true

IRB.conf[:HISTORY_FILE] = ENV["IRB_HISTFILE"] if ENV["IRB_HISTFILE"]

require "ruby-next/irb"
