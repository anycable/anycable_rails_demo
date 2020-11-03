# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> New list" do
  fixtures :workspaces

  let(:workspace) { workspaces(:empty) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  it "I can create a new list" do
    within dom_id(workspace, :lists) do
      expect(page).to have_no_css(".any-list--panel")
    end

    within dom_id(workspace, :new_list) do
      fill_in "list[name]", with: "AnyCable 2.0"

      click_on "Create"
    end

    expect(page).to have_text "New list has been created!"

    within dom_id(workspace, :lists) do
      expect(page).to have_css(".any-list--panel", count: 1)
      expect(page).to have_text "AnyCable 2.0"
    end
  end

  context "with multiple sessions" do
    before do
      within_session :john do
        login_user "John"

        visit workspace_path(workspace)
        expect(page).to have_text workspace.name
      end
    end

    it "all users see the newly created list" do
      within dom_id(workspace, :new_list) do
        fill_in "list[name]", with: "ManyCable"

        click_on "Create"
      end

      expect(page).to have_text "New list has been created!"

      within_session :john do
        within dom_id(workspace, :lists) do
          expect(page).to have_css(".any-list--panel", count: 1)
          expect(page).to have_text "ManyCable"
        end
      end
    end
  end
end
