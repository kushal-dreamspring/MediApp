# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FakeServiceJob, type: :job do
  describe '#perform_later' do

    it 'uploads a backup' do
      ActiveJob::Base.queue_adapter = :test
      expect { FakeServiceJob.perform_later }.to have_enqueued_job
    end
  end
end
