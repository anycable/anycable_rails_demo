# frozen_string_literal: true

class WorkspacesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def new
    workspace = Workspace.new
    render locals: {workspace: workspace}
  end

  def create
    workspace = Workspace.new(workspace_params)
    if workspace.save
      redirect_to workspace_path(workspace), notice: "Welcome to your new workspace!"
    else
      flash.now[:alert] = "Failed to create a workspace: #{workspace.errors.full_messages.join(";")}"
      render :new, locals: {workspace: workspace}
    end
  end

  def index
  end

  def show
    workspace = Workspace.find_by!(public_id: params[:id])
    render locals: {workspace: workspace}
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end
