# frozen_string_literal: true

require "rails_helper"

describe WorkspaceChannel do
  fixtures :workspaces

  let(:user) { User.generate("aaron") }
  let(:workspace) { workspaces(:demo) }

  before do
    stub_connection user: user
  end

  describe "#subscribe" do
    it "rejects subscription without workspace id" do
      subscribe

      expect(subscription).to be_rejected
    end

    it "rejects subscription with non-existent workspace id" do
      subscribe id: "unknown"
      expect(subscription).to be_rejected
    end

    it "subscribes with existent workspace id" do
      subscribe id: workspace.public_id

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(workspace)
    end
  end
end
