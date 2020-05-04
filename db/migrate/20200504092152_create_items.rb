# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.belongs_to :list, null: false, foreign_key: true, index: true
      t.text :desc, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
