# frozen_string_literal: true

module Chat
  class MessagesController < ApplicationController
    before_action :set_workspace

    attr_reader :workspace

    def create
      Turbo::StreamsChannel.broadcast_append_to(
        workspace,
        target: ActionView::RecordIdentifier.dom_id(workspace, :chat_messages),
        partial: "chats/message",
        locals: {message: params[:message], name: current_user.name}
      )

      render partial: "chats/form", locals: {workspace}
    end

    private

    def list_params
      params.require(:list).permit(:name)
    end

    def set_workspace
      @workspace = Workspace.find_by!(public_id: params[:workspace_id])
    end
  end
end
