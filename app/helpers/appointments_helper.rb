# frozen_string_literal: true

module AppointmentsHelper
  APPOINTMENT_DELETE_DEADLINE = 30.minutes

  def print_appointment_date(appointment_date, display_format = 0)
    date_format = case display_format
                  when 1
                    "%A, #{appointment_date.day.ordinalize} %B"
                  when 2
                    (appointment_date.today? ? t('today') : '') +
                    (appointment_date.tomorrow? ? t('tomorrow') : '') + "#{appointment_date.day.ordinalize} %B"
                  when 3
                    '%I:%M %p'
                  when 4
                    (appointment_date.today? ? t('today') : '') +
                    (appointment_date.tomorrow? ? t('tomorrow') : '') + "#{appointment_date.day.ordinalize} %B, %I:%M %p"
                  when 5
                    "%a, #{appointment_date.day.ordinalize} %b %Y"
                  else
                    (appointment_date.today? ? t('today') : '') +
                    (appointment_date.tomorrow? ? t('tomorrow') : '') + "%a, #{appointment_date.day.ordinalize}"
                  end
    appointment_date.strftime(date_format)
  end

  def print_appointment_amount(appointment)
    "#{appointment.user.currency_preference} #{appointment.amount_in_preferred_currency}/-"
  end

  def generate_cancel_button(appointment)
    return unless appointment.date_time - DateTime.now > APPOINTMENT_DELETE_DEADLINE

    button_to(t('appointment_card.button_label.cancel_appointment'), appointment, method: :delete, class: 'w-100 mb-3 fw-bold text-uppercase btn btn-outline-danger')
  end
end
