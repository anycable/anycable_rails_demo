# frozen_string_literal: true

require "rails_helper"

describe "Workspaces -> List -> Items" do
  fixtures :workspaces, :lists, :items

  let(:workspace) { workspaces(:demo) }
  let(:empty_list) { lists(:demo_empty) }
  let(:full_list) { lists(:demo_cables) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  context "with empty list" do
    it "I can add an item" do
      within("#list_#{empty_list.id}") do
        within "form" do
          fill_in "item[desc]", with: "Pass the tests"
          current_scope.send_keys :enter
        end

        within "#list_#{empty_list.id}_items" do
          expect(page).to have_text "Pass the tests"
        end
      end
    end
  end
end
