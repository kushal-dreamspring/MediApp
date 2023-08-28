# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakeServiceJob, type: :job do
  fixtures :appointments

  it 'should broadcast using turbo_stream' do
    expect(Turbo::StreamsChannel).to receive(:broadcast_render_later_to).with(:appointment_created,
                                                                              target: 'new_appointment',
                                                                              partial: 'appointments/appointment_success',
                                                                              locals: { appointment_time: appointments(:one).date_time })
    FakeServiceJob.perform_now(appointments(:one))
  end
end
