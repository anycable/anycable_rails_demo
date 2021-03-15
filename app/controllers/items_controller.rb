# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_workspace, :set_list
  before_action :set_item, only: [:destroy, :update]

  after_action :broadcast_new_item, only: [:create]
  after_action :broadcast_changes, only: [:update, :destroy]

  attr_reader :workspace, :list, :item

  def create
    @item = Item.new(item_params)
    item.list = list

    if item.save
      flash[:notice] = "New item has been added to #{list.name}!"
    else
      flash[:alert] = "Failed to create an item: #{item.errors.full_messages.join(";")}"
    end

    redirect_to workspace, status: :see_other
  end

  def update
    item.update!(item_params)

    flash.now[:notice] = "Item has been updated"
    render partial: "update", locals: {item}, content_type: "text/vnd.turbo-stream.html"
  end

  def destroy
    item.destroy!

    flash.now[:notice] = "Item has been deleted"
    render partial: "update", locals: {item: nil}, content_type: "text/vnd.turbo-stream.html"
  end

  private

  def item_params
    params.require(:item).permit(:desc, :completed)
  end

  def set_workspace
    @workspace = Workspace.find_by!(public_id: params[:workspace_id])
  end

  def set_list
    @list = @workspace.lists.find(params[:list_id])
  end

  def set_item
    @item = @list.items.find(params[:id])
  end

  def broadcast_new_item
    return if item.errors.any?
    ListChannel.broadcast_to list, type: "created", html: render_to_string(partial: "items/item", layout: false, locals: {item})
  end

  def broadcast_changes
    return if item.errors.any?
    if item.destroyed?
      ListChannel.broadcast_to list, type: "deleted", id: item.id
    else
      ListChannel.broadcast_to list, type: "updated", id: item.id, desc: item.desc, completed: item.completed
    end
  end
end
