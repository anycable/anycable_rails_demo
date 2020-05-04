# frozen_string_literal: true

require "rails_helper"

describe "Workspaces -> New list" do
  fixtures :workspaces

  let(:workspace) { workspaces(:empty) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  it "I can create a new list" do
    within "#lists" do
      expect(page).to have_no_css(".any-list--panel")
    end

    within "#new_list" do
      fill_in "list[name]", with: "AnyCable 2.0"

      click_on "Create"
    end

    expect(page).to have_text "New list has been created!"

    within "#lists" do
      expect(page).to have_css(".any-list--panel", count: 1)
      expect(page).to have_text "AnyCable 2.0"
    end
  end
end
