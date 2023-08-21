# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DoctorsHelper do
  context 'when appointment time is not present' do
    it "returns #{I18n.t('not_available')}" do
      expect(display_next_appointment(nil)).to eq I18n.t('not_available')
    end
  end

  context 'when appointment time is today' do
    it 'returns only time' do
      expect(display_next_appointment(Date.today)).to eq '12:00 AM'
    end
  end

  context 'when appointment time is not today' do
    it 'returns time with date' do
      expect(display_next_appointment(Date.new(2023, 8, 22))).to eq 'Aug 22, 12:00 AM'
    end
  end
end
