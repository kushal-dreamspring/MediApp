# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Appointment do
  fixtures :doctors, :users
  let(:valid_attributes) do
    [
      {
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 },
        user_id: users(:one).id
      },
      {
        doctor_id: doctors(:two).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 },
        user_id: users(:one).id
      },
      {
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 },
        user_id: users(:two).id
      }
    ]
  end

  let(:invalid_attributes) do
    [
      {
        user_id: users(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
      },
      {
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
      },
      {
        doctor_id: doctors(:one).id,
        user_id: users(:one).id,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
      },
      {
        doctor_id: doctors(:one).id,
        user_id: users(:one).id,
        date_time: DateTime.now + 1.hours,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
      },
      {
        doctor_id: doctors(:one).id,
        user_id: users(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500
      },
      {
        doctor_id: doctors(:one).id,
        user_id: users(:one).id,
        date_time: DateTime.now - 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
      }
    ]
  end

  context 'when attributes are missing' do
    it 'should have validation errors' do
      invalid_attributes[0..4].each do |appointment|
        expect(Appointment.new(**appointment).valid?).to be_falsey
      end
    end
  end

  context 'when date_time is in past' do
    it 'should have validation errors' do
      expect(Appointment.new(**invalid_attributes[5]).valid?).to be_falsey
    end
  end

  context 'when user already has an appointment at the same time' do
    around :each do |example|
      Timecop.freeze(Date.tomorrow) do
        example.run
      end
    end

    before :each do
      Appointment.create!(**valid_attributes[0])
    end

    it 'should have validation errors' do
      expect(Appointment.new(**valid_attributes[1]).valid?).to be_falsey
    end
  end

  context 'when doctor already has an appointment at the same time' do
    around :each do |example|
      Timecop.freeze(Date.tomorrow) do
        example.run
      end
    end

    before :each do
      Appointment.create!(**valid_attributes[0])
    end

    it 'should have validation errors' do
      expect(Appointment.new(**valid_attributes[2]).valid?).to be_falsey
    end
  end

  describe 'amount_in_preferred_currency' do
    it 'should return 500 for user_2"' do
      expect(Appointment.new(**valid_attributes[2]).amount_in_preferred_currency).to eq 500
    end
  end
end
