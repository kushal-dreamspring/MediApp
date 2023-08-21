# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakeServiceJob, type: :job do
  fixtures :appointments

  it 'should broadcast using turbo_stream' do
    expect(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
    FakeServiceJob.perform_now(appointments(:one))
  end
end
