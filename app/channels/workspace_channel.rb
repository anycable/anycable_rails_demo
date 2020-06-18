# frozen_string_literal: true

class WorkspaceChannel < ApplicationCable::Channel
  # Replace with state_attr_accessor if new actions are added
  attr_accessor :workspace

  def subscribed
    self.workspace = Workspace.find_by(public_id: params[:id])
    return reject unless workspace

    stream_for workspace
  end
end
