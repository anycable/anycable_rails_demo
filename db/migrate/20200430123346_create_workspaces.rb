# frozen_string_literal: true

class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces do |t|
      t.string :name, null: false
      t.string :public_id, null: false, index: true

      t.timestamps
    end
  end
end
