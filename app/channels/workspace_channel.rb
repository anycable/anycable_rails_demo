# frozen_string_literal: true

class WorkspaceChannel < ApplicationCable::Channel
  attr_reader :workspace

  def subscribed
    @workspace = Workspace.find_by(public_id: params[:id])
    return reject unless workspace

    stream_for workspace
  end
end
