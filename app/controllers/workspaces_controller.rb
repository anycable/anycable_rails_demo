# frozen_string_literal: true

class WorkspacesController < ApplicationController
  def new
    @workspace = Workspace.new
  end

  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      redirect_to workspace_path(@workspace), notice: "Welcome to your new workspace!"
    else
      flash.now[:alert] = "Failed to create a workspace: #{@workspace.errors.full_messages.join(";")}"
      render :new
    end
  end

  def index
    # TODO: move to frontend
    @recent_workspaces = Workspace.all.limit(4)
  end

  def show
    @workspace = Workspace.find_by!(public_id: params[:id])
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
