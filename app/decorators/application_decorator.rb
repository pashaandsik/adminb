# frozen_string_literal: true
class ApplicationDecorator < Draper::Decorator
  delegate_all

  def host
    Rails.application.config.action_mailer.default_url_options[:host]
  end

  def human_amount(amount, precision = true, format = :html_currency_format)
    h.number_to_currency(
      amount.to_f / 100,
      format:     send(format),
      separator:  ".",
      delimiter:  "",
      precision: precision ? 2 : 0,
    )
  end
end
