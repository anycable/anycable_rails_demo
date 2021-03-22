# frozen_string_literal: true

require "rails_helper"

describe Banner::Component do
  let(:options) { {id: "test"} }
  let(:component) { Banner::Component.new(**options) }

  subject { rendered_component }

  it "renders" do
    render_inline(component) { "Some body" }

    is_expected.to have_text "Some body"
  end

  it "doesn't render without the content" do
    render_inline(component)

    is_expected.to be_empty
  end
end
