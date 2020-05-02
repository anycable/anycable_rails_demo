# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  attr_reader :workspace

  def subscribed
    @workspace = Workspace.find_by(public_id: params[:id])
    return reject unless workspace

    stream_for workspace
  end

  def speak(data)
    message = data.fetch("message")

    broadcast_to(
      workspace,
      action: "newMessage",
      html: html("chat/message", message: message, name: user.name),
      author_id: user.id
    )
  end
end
