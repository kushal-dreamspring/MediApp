# frozen_string_literal: true

module DoctorsHelper
  def display_next_appointment(appointment_time)
    if appointment_time.present?
      appointment_time.strftime(appointment_time.today? ? '%I:%M %p' : '%b %d, %I:%M %p')
    else
      I18n.t('not_available')
    end
  end
end
