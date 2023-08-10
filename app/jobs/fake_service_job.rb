# frozen_string_literal: true

class FakeServiceJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    Turbo::StreamsChannel.broadcast_render_later_to(
      :appointment_created,
      target: 'new_appointment',
      partial: 'appointments/appointment_success',
      locals: { appointment_time: appointment.date_time }
    )
  end
end
