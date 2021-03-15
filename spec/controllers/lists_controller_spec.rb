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

    it "broadcasts a newList message" do
      expect { subject }.to have_broadcasted_turbo_stream_to(
        workspace, action: :append, target: ActionView::RecordIdentifier.dom_id(workspace, :lists)
      )
    end
  end

  describe "DELETE #destroy" do
    let!(:list) { lists(:demo_empty) }

    subject { delete :destroy, params: {workspace_id: workspace.to_param, id: list.id} }

    it "destroyes the list" do
      expect { subject }.to change(workspace.lists, :count).by(-1)
    end

    it "broadcasts a remove message" do
      expect { subject }.to have_broadcasted_turbo_stream_to(
        workspace, action: :remove, target: list
      )
    end
  end
end
