# frozen_string_literal: true

class ListChannel < ApplicationCable::Channel
  # Replace with state_attr_accessor if new actions are added
  attr_accessor :workspace, :list

  def subscribed
    self.workspace = Workspace.find_by(public_id: params[:workspace])
    return reject unless workspace

    self.list = workspace.lists.find_by(id: params[:id])
    return reject unless list

    stream_for list
  end
end
