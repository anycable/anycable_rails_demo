# frozen_string_literal: true

require "rails_helper"

describe GraphqlController do
  fixtures :workspaces, :lists, :items

  let(:workspace) { workspaces(:demo) }

  describe "POST #execute" do
    let(:query) do
      <<~GRAPHQL
        query getWorkspace($id: ID!) {
          workspace(id: $id) {
            name
            lists {
              name
              items {
                description
              }
            }
          }
        }
      GRAPHQL
    end

    subject { post :execute, params: {query: query, variables: {id: workspace.public_id}} }

    it "returns the workspace data" do
      data = JSON.parse(subject.body)

      expect(data.dig("errors")).to be_blank
      expect(data.dig("data", "workspace", "name")).to eq workspace.name
    end
  end
end
