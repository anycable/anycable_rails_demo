# frozen_string_literal: true

require "system_helper"

describe "Workspaces" do
  fixtures :workspaces

  before do
    visit workspaces_path
    expect(page).to have_text "Choose workspace"
  end

  it "I can open Demo workspace" do
    click_on "Demo"

    expect(page).to have_text "Demo Workspace"
    expect(page).to have_current_path(workspace_path(workspaces(:demo)))
  end

  it "I can open a recent workspace" do
    # first, there is no recent workspaces
    within "#recent" do
      expect(page).to have_text "None"
    end

    # visit a workspace
    visit workspace_path(workspaces(:empty))
    expect(page).to have_text "Just created workspace for fun"
    expect(page).to have_current_path(workspace_path(workspaces(:empty)))

    # visit home page again
    visit workspaces_path

    within "#recent" do
      expect(page).to have_text "Just created workspace for fun"
      click_on "Just created workspace for fun"
    end

    expect(page).to have_text "Just created workspace for fun"
    expect(page).to have_current_path(workspace_path(workspaces(:empty)))
  end

  it "I can create a new workspace" do
    click_on "Create"

    expect(page).to have_text "Create new workspace"
    expect(page).to have_current_path(new_workspace_path)
  end
end
