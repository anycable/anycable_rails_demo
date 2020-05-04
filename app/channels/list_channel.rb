# frozen_string_literal: true

class ListChannel < ApplicationCable::Channel
  attr_reader :workspace, :list

  def subscribed
    @workspace = Workspace.find_by(public_id: params[:workspace])
    return reject unless workspace

    @list = workspace.lists.find_by(id: params[:id])
    return reject unless list

    stream_for list
  end
end
