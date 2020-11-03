# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> List -> Delete" do
  fixtures :workspaces, :lists

  let(:workspace) { workspaces(:demo) }
  let(:list) { lists(:demo_cables) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  it "I delete a list" do
    within dom_id(list, :header) do
      accept_confirm do
        find(".delete-btn").click
      end
    end

    expect(page).to have_text "#{list.name} has been deleted"

    within dom_id(workspace, :lists) do
      expect(page).to have_no_text list.name
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

    it "list is deleted for all users" do
      within_session :john do
        within dom_id(workspace, :lists) do
          expect(page).to have_text list.name
        end
      end

      within dom_id(list, :header) do
        accept_confirm do
          find(".delete-btn").click
        end
      end

      expect(page).to have_text "#{list.name} has been deleted"

      within_session :john do
        within dom_id(workspace, :lists) do
          expect(page).to have_no_text list.name
        end
      end
    end
  end
end
