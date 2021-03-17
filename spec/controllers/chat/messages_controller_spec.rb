# frozen_string_literal: true

require "rails_helper"

describe Chat::MessagesController do
  fixtures :workspaces

  let(:user) { User.generate("abby") }
  let(:workspace) { workspaces(:demo) }

  before { login user }

  describe "POST #create" do
    let(:form_params) { {message: "Hello!"} }

    subject { post :create, params: {workspace_id: workspace.to_param}.merge(form_params) }

    it "broadcasts a message" do
      expect { subject }.to have_broadcasted_turbo_stream_to(
        workspace, action: :append, target: ActionView::RecordIdentifier.dom_id(workspace, :chat_messages)
      )
    end
  end
end
