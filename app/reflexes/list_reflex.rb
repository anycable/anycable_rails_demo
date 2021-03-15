# frozen_string_literal: true

class ListReflex < ApplicationReflex
  def toggle_item_completion
    item = find_item
    item.toggle!(:completed)

    html = render_partial("items/item", {item})
    selector = dom_id(item)

    cable_ready[
      ListChannel.broadcasting_for(item.list)
    ].outer_html(**{selector, html})
    cable_ready.broadcast

    morph_flash :notice, "Item has been updated"
  end

  def destroy_item
    item = find_item
    item.destroy!

    selector = dom_id(item)

    cable_ready[
      ListChannel.broadcasting_for(item.list)
    ].remove(**{selector})
    cable_ready.broadcast

    morph_flash :notice, "Item has been deleted"
  end

  private

  def find_item
    Item.find element.dataset["item-id"]
  end
end
