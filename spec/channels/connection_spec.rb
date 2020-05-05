# frozen_string_literal: true

require "rails_helper"

describe ApplicationCable::Connection do
  let(:user) { User.generate("david") }

  it "successfully connects via cookies" do
    cookies[:uid] = "#{user.name}/#{user.id}"

    connect "/cable"
    expect(connection.user.id).to eq user.id
  end

  it "successfully connects via session" do
    connect "/cable", session: {name: user.name, id: user.id}

    expect(connection.user.id).to eq user.id
  end

  it "rejects when not creds" do
    expect { connect "/cable" }.to have_rejected_connection
  end
end
