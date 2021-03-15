# frozen_string_literal: true

require "rails_helper"

describe ListsController do
  fixtures :workspaces, :lists

  let(:user) { User.generate("abby") }
  let(:workspace) { workspaces(:demo) }

  before { login user }

  describe "POST #create" do
    let(:form_params) { {name: "My TODO list"} }

    subject { post :create, params: {workspace_id: workspace.to_param, list: form_params} }

    it "creates a list" do
      expect { subject }.to change(workspace.lists, :count).by(1)
    end

    it "broadcasts a cable ready insertAdjacentHtml operation" do
      expect { subject }.to have_broadcasted_to(WorkspaceChannel.broadcasting_for(workspace))
        .with(a_hash_including("cableReady": true, "operations": a_hash_including("insertAdjacentHtml": anything)))
    end
  end

  describe "DELETE #destroy" do
    let!(:list) { lists(:demo_empty) }

    subject { delete :destroy, params: {workspace_id: workspace.to_param, id: list.id} }

    it "destroyes the list" do
      expect { subject }.to change(workspace.lists, :count).by(-1)
    end

    it "broadcasts a cable ready remove operation" do
      expect { subject }.to have_broadcasted_to(WorkspaceChannel.broadcasting_for(workspace))
        .with(a_hash_including("cableReady": true, "operations": a_hash_including("remove": anything)))
    end
  end
end
