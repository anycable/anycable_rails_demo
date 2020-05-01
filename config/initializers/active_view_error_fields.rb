# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_tag.html_safe # rubocop:disable Rails/OutputSafety
end
