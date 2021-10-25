# frozen_string_literal: true

require "kuby"
require "kuby/anycable/rpc_plugin"
require "kuby/anycable/go_plugin"

Kuby.register_plugin(:anycable_rpc, Kuby::AnyCable::RPCPlugin)
Kuby.register_plugin(:anycable_go, Kuby::AnyCable::GoPlugin)
