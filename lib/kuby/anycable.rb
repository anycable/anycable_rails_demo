# frozen_string_literal: true

require "kuby"
require "kuby/anycable/rpc_plugin"
require "kuby/anycable/go_plugin"
require "kuby/anycable/packages"

Kuby.register_plugin(:anycable_rpc, Kuby::AnyCable::RPCPlugin)
Kuby.register_plugin(:anycable_go, Kuby::AnyCable::GoPlugin)

Kuby.register_package("anycable-build", Kuby::AnyCable::Packages)
