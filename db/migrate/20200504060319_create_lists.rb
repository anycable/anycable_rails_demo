# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.belongs_to :workspace, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
