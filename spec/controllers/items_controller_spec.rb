# frozen_string_literal: true

require "rails_helper"

describe ItemsController do
  fixtures :workspaces, :lists, :items

  let(:user) { User.generate("abby") }
  let(:workspace) { workspaces(:demo) }
  let(:list) { lists(:demo_cables) }

  before { login user }

  describe "POST #create" do
    let(:form_params) { {desc: "Add tests"} }

    subject { post :create, params: {workspace_id: workspace.to_param, list_id: list.id, item: form_params} }

    it "creates an item" do
      expect { subject }.to change(list.items, :count).by(1)
    end

    it "broadcasts a created message" do
      expect { subject }.to have_broadcasted_to(ListChannel.broadcasting_for(list))
        .with(a_hash_including(type: "created"))
    end
  end

  describe "DELETE #destroy" do
    let!(:item) { items(:demo_anycable) }

    subject { delete :destroy, params: {workspace_id: workspace.to_param, list_id: list.id, id: item.id} }

    it "destroyes the item" do
      expect { subject }.to change(list.items, :count).by(-1)
    end

    it "broadcasts a deleted message" do
      expect { subject }.to have_broadcasted_to(ListChannel.broadcasting_for(list))
        .with(type: "deleted", id: item.id)
    end
  end

  describe "PATCH #update" do
    let(:item) { items(:demo_acli) }

    let(:form_params) { {completed: true} }

    subject { patch :update, params: {workspace_id: workspace.to_param, list_id: list.id, id: item.id, item: form_params} }

    it "broadcasts an updated message" do
      expect { subject }.to have_broadcasted_to(ListChannel.broadcasting_for(list))
        .with(type: "updated", id: item.id, completed: true, desc: item.desc)
    end
  end
end
