# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> Show" do
  fixtures :workspaces

  let(:workspace) { workspaces(:empty) }

  it "I can open an existing workspace" do
    visit workspace_path(workspace)

    expect(page).to have_text "Just created workspace for fun"
    expect(page).to have_current_path(workspace_path(workspace))
  end

  it "returns not found if workspace is unknown" do
    visit workspace_path(id: "uknown-workspace")

    expect(page).to have_text "This page could not be found"
  end
end
