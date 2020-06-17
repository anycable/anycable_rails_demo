# frozen_string_literal: true

require "system_helper"

describe "Log in" do
  it "I can logout" do
    visit root_path

    within "nav" do
      expect(page).to have_text "Welcome, Any!"

      expect(page).to have_text "Sign out"
      click_on "Sign out"

      expect(page).to have_link "Sign in"
    end
  end
end
