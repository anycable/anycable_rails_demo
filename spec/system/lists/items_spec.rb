# frozen_string_literal: true

require "system_helper"

describe "Workspaces -> List -> Items" do
  fixtures :workspaces, :lists, :items

  let(:workspace) { workspaces(:demo) }
  let(:empty_list) { lists(:demo_empty) }
  let(:full_list) { lists(:demo_cables) }

  before do
    visit workspace_path(workspace)
    expect(page).to have_text workspace.name
  end

  context "with empty list" do
    it "I can add an item" do
      within dom_id(empty_list, :new_item) do
        within "form" do
          fill_in "item[desc]", with: "Pass the tests"
          current_scope.send_keys :enter
        end
      end

      within dom_id(empty_list, :items) do
        expect(page).to have_text "Pass the tests"
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

      it "all users see the newly created item" do
        within dom_id(empty_list, :new_item) do
          within "form" do
            fill_in "item[desc]", with: "Multi test"
            current_scope.send_keys :enter
          end
        end

        within_session :john do
          within dom_id(empty_list, :items) do
            expect(page).to have_text "Multi test"
          end
        end
      end
    end
  end

  context "with full list" do
    let(:item) { items(:demo_acli) }

    it "I can delete an item" do
      within dom_id(full_list, :items) do
        expect(page).to have_text item.desc
      end

      within dom_id(item) do
        find(".delete-btn").click
      end

      within dom_id(full_list, :items) do
        expect(page).to have_no_text item.desc
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

      it "item is deleted for all users" do
        within dom_id(item) do
          find(".delete-btn").click
        end

        within dom_id(full_list, :items) do
          expect(page).to have_no_text item.desc
        end

        within_session :john do
          within dom_id(full_list, :items) do
            expect(page).to have_no_text item.desc
          end
        end
      end

      it "item is completed for all users" do
        within dom_id(item) do
          find(".any-check").click
        end

        expect(page).to have_css "#{dom_id(item)}.checked"

        within_session :john do
          expect(page).to have_css "#{dom_id(item)}.checked"
        end
      end
    end
  end
end
