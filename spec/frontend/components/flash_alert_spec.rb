# frozen_string_literal: true

require "rails_helper"

describe FlashAlert::Component do
  let(:options) { {body: "Test"} }
  let(:component) { FlashAlert::Component.new(**options) }

  subject { rendered_component }

  it "renders" do
    render_inline(component)

    is_expected.to have_text "Test"
    is_expected.to have_css "div.border-teal-500"
  end

  it "renders alert with red border" do
    options[:type] = "alert"

    render_inline(component)

    is_expected.to have_css "div.border-red"
  end

  it "doesn't render if body is empty" do
    options[:body] = ""

    render_inline(component)

    is_expected.to be_empty
  end
end
