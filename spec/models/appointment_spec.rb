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
    {
      doctor_id: doctors(:one).id,
      user_id: users(:one).id,
      date_time: DateTime.now - 1.hours,
      amount: 500,
      conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
    }
  end

  describe 'presence validations' do
    it { should validate_presence_of(:doctor) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:date_time) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:conversion_rates) }
  end

  context 'when date_time is in past' do
    it 'should have validation errors' do
      appointment = Appointment.new(**invalid_attributes)

      expect(appointment.valid?).to be_falsey
      expect(appointment.errors.messages.keys).to include(:date_time)
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
      appointment = Appointment.new(**valid_attributes[1])

      expect(appointment.valid?).to be_falsey
      expect(appointment.errors.messages.keys).to include(:date_time)
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
    it 'should return 500 for user_2' do
      expect(Appointment.new(**valid_attributes[2]).amount_in_preferred_currency).to eq 500
    end
  end
end
