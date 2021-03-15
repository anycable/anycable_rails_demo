# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  rescue_from StandardError do
    morph_flash :alert, "Something went wrong :("
  end

  private

  def morph_flash(type, message)
    morph "#flash", render_partial("shared/alerts", {flash: {type => message}})
  end

  def render_partial(partial, locals = {})
    ApplicationController.render(
      formats: [:html],
      layout: false,
      **{partial, locals}
    )
  end
end
