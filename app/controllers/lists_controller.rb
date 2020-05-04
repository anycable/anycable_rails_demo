# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_workspace

  attr_reader :workspace

  def create
    list = List.new(list_params)
    list.workspace = workspace

    if list.save
      flash[:notice] = "New list has been created!"
    else
      flash[:alert] = "Failed to create a list: #{list.errors.full_messages.join(";")}"
    end

    redirect_to workspace
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_workspace
    @workspace = Workspace.find_by!(public_id: params[:workspace_id])
  end
end
