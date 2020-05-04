# frozen_string_literal: true

ActiveRecord::Base.transaction do
  # create demo workspace
  _demo = Workspaces::CreateDemo.call(id: "demo")
end
