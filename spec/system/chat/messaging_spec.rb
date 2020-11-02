# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> Chat" do
  fixtures :workspaces

  before do
    visit workspace_path(workspaces(:demo))
    expect(page).to have_text "Demo Workspace"
  end

  it "I can send a message" do
    within ".chat" do
      fill_in :message, with: "Hi there"

      click_on "Send"

      within ".chat .messages" do
        expect(page).to have_text "Hi there"
        expect(page).to have_text "Any"
      end
    end
  end

  context "with multiple sessions" do
    before do
      within_session :john do
        login_user "John"

        visit workspace_path(workspaces(:demo))
        expect(page).to have_text "Demo Workspace"
      end
    end

    it "multiples users can chat with each other" do
      fill_in :message, with: "Hi John"

      click_on "Send"

      within ".chat .messages" do
        expect(page).to have_text "Hi John"
        expect(page).to have_text "Any"
      end

      within_session :john do
        within ".chat .messages" do
          expect(page).to have_text "Hi John"
          expect(page).to have_text "Any"
        end

        fill_in :message, with: "What's up, Any?"

        click_on "Send"
      end

      within ".chat .messages" do
        expect(page).to have_text "What's up, Any?"
      end
    end
  end
end
