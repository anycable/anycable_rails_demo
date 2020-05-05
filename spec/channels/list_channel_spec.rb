# frozen_string_literal: true

require "rails_helper"

describe ListChannel do
  fixtures :workspaces, :lists

  let(:user) { User.generate("aaron") }
  let(:workspace) { workspaces(:demo) }
  let(:list) { lists(:demo_cables) }

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

    it "rejects subscription without workspace id" do
      subscribe

      expect(subscription).to be_rejected
    end

    it "rejects with existent workspace id and unknown list id" do
      subscribe workspace: workspace.public_id, id: -1

      expect(subscription).to be_rejected
    end

    it "subscribes with existent workspace id and list id" do
      subscribe workspace: workspace.public_id, id: list.id

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(list)
    end
  end
end
