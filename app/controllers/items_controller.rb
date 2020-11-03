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
    respond_to do |format|
      format.json do
        head :ok
      end

      format.html do
        flash[:notice] = "Item has been updated"
        redirect_to workspace
      end
    end
  end

  def destroy
    item.destroy!

    respond_to do |format|
      format.json do
        head :no_content
      end

      format.html do
        flash[:notice] = "Item has been deleted"
        redirect_to workspace
      end
    end
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

    broadcaster.insert_adjacent_html(
      selector: dom_id(list, :items),
      html: render_partial("items/item", {item})
    )
    cable_ready.broadcast
  end

  def broadcast_changes
    return if item.errors.any?
    if item.destroyed?
      broadcaster.remove(selector: dom_id(item))
    else
      broadcaster.outer_html(
        selector: dom_id(item),
        html: render_partial("items/item", {item})
      )
    end
    cable_ready.broadcast
  end

  def broadcaster
    cable_ready[ListChannel.broadcasting_for(list)]
  end
end
