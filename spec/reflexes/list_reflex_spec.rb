# frozen_string_literal: true

require "rails_helper"

describe ListReflex do
  fixtures :workspaces, :lists, :items

  let(:workspace) { workspaces(:demo) }
  let(:list) { lists(:demo_cables) }
  let(:item) { items(:demo_acli) }

  let(:dataset) { {"item-id" => item.id} }

  let(:reflex) do
    build_reflex(url: "/", session: {}).tap do |reflex|
      dataset.each { reflex.element.dataset[_1] = _2.to_s }
    end
  end

  describe "#toggle_item_completion" do
    subject { reflex.run(:toggle_item_completion) }

    it "toggles item completion" do
      subject
      expect(item.reload).to be_completed
    end

    it "broadcasts a cable ready outerHtml operation" do
      expect { subject }.to have_broadcasted_to(ListChannel.broadcasting_for(list))
        .with(a_hash_including("cableReady": true, "operations": a_hash_including("outerHtml": anything)))
    end

    context "when item is completed" do
      before { item.update!(completed: true) }

      it "toggles item completion" do
        subject
        expect(item.reload).not_to be_completed
      end
    end
  end

  describe "#destroy_item" do
    subject { reflex.run(:destroy_item) }

    it "destroyes the item" do
      expect { subject }.to change(list.items, :count).by(-1)
    end

    it "broadcasts a cable ready remove operation" do
      expect { subject }.to have_broadcasted_to(ListChannel.broadcasting_for(list))
        .with(a_hash_including("cableReady": true, "operations": a_hash_including("remove": anything)))
    end
  end
end
