# frozen_string_literal: true

ActiveRecord::Base.transaction do
  # create demo workspace
  _demo = Workspace.create!(name: "Demo Workspace", public_id: "demo")
end
