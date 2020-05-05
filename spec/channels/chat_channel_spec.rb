# frozen_string_literal: true

require "rails_helper"

describe ChatChannel do
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

  describe "#speak" do
    before { subscribe id: workspace.public_id }

    it "broadcasts a message" do
      expect { perform :speak, message: "hello!" }.to have_broadcasted_to(workspace)
        .with(a_hash_including(action: "newMessage", author_id: user.id))
    end
  end
end
