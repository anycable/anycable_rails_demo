# frozen_string_literal: true

require "rails_helper"

describe "Workspaces -> List -> Delete" do
  fixtures :workspaces, :lists

  let(:workspace) { workspaces(:demo) }
  let(:list) { lists(:demo_cables) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  it "I delete a list" do
    within "#list_#{list.id}_header" do
      accept_confirm do
        find(".delete-btn").click
      end
    end

    expect(page).to have_text "#{list.name} has been deleted"

    within "#lists" do
      expect(page).to have_no_text list.name
    end
  end
end
