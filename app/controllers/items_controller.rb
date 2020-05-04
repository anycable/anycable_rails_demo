# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_workspace, :set_list
  attr_reader :workspace, :list

  def create
    item = list.items.build(item_params)

    if item.save
      flash.now[:notice] = "New item has been added to #{list.name}!"
    else
      flash.now[:alert] = "Failed to create an item: #{item.errors.full_messages.join(";")}"
    end

    render template: "workspaces/show", locals: {workspace: workspace}
  end

  private

  def item_params
    params.require(:item).permit(:desc)
  end

  def set_workspace
    @workspace = Workspace.find_by!(public_id: params[:workspace_id])
  end

  def set_list
    @list = @workspace.lists.find(params[:list_id])
  end
end
