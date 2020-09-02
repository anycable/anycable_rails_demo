# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_workspace
  before_action :set_list, only: [:destroy]

  after_action :broadcast_new_list, only: [:create]
  after_action :broadcast_changes, only: [:destroy]

  attr_reader :workspace, :list

  def create
    @list = List.new(list_params)
    list.workspace = workspace

    if list.save
      flash[:notice] = "New list has been created!"
    else
      flash[:alert] = "Failed to create a list: #{list.errors.full_messages.join(";")}"
    end

    redirect_to workspace
  end

  def destroy
    list.destroy!
    flash[:notice] = "#{list.name} has been deleted!"
    redirect_to workspace
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_workspace
    @workspace = Workspace.find_by!(public_id: params[:workspace_id])
  end

  def set_list
    @list = workspace.lists.find(params[:id])
  end

  def broadcast_new_list
    return if list.errors.any?
    WorkspaceChannel.broadcast_to workspace, type: "newList", html: render_to_string(partial: "lists/list", layout: false, locals: {list})
  end

  def broadcast_changes
    return if list.errors.any?
    if list.destroyed?
      WorkspaceChannel.broadcast_to workspace, type: "deletedList", id: list.id
    end
  end
end
