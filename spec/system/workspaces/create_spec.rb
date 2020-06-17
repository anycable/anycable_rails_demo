# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> New" do
  it "I can create a new workspace" do
    visit new_workspace_path

    fill_in "workspace[name]", with: "My Workspacer"
    click_on "Create"

    expect(page).to have_text "Welcome to your new workspace!"
    expect(page).to have_text "My Workspacer"
  end
end
