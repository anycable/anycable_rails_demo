# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_workspace

  attr_reader :workspace

  def create
    list = workspace.lists.build(list_params)

    if list.save
      flash.now[:notice] = "New list has been created!"
    else
      flash.now[:alert] = "Failed to create a list: #{@list.errors.full_messages.join(";")}"
    end

    render template: "workspaces/show", locals: {workspace: workspace}
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def set_workspace
    @workspace = Workspace.find_by!(public_id: params[:workspace_id])
  end
end
