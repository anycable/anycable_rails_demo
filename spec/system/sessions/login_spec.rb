# frozen_string_literal: true

require "rails_helper"

describe "Log in", auth: false do
  fixtures :workspaces

  let(:workspace) { workspaces(:empty) }

  it "I can login before visiting the workspace" do
    visit root_path

    expect(page).to have_link "Just created workspace for fun"
    click_on "Just created workspace for fun"

    expect(page).to have_text "Please, name yourself"
    expect(page).to have_current_path(login_path)

    fill_in :name, with: "Matroskin the Cat"
    click_on "Log in"

    expect(page).to have_text "Just created workspace for fun"
    expect(page).to have_current_path(workspace_path(workspace))
  end
end
