# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppointmentsHelper do
  fixtures :appointments, :doctors, :users

  let(:valid_attributes) do
    [
      {
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 20.minutes,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 },
        user_attributes: {
          name: 'Test User',
          email: 'test@123.com'
        }
      },
      {
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 },
        user_attributes: {
          name: users(:one).name,
          email: users(:one).email,
        }
      }
    ]
  end

  describe 'print_appointment_date' do
    it 'should return date according to format' do
      appointment_date = appointments(:one).date_time

      expect(print_appointment_date(appointment_date, 0)).to eq 'Sat, 1st'
      expect(print_appointment_date(appointment_date, 1)).to eq 'Saturday, 1st January'
      expect(print_appointment_date(appointment_date, 2)).to eq '1st January'
      expect(print_appointment_date(appointment_date, 3)).to eq '02:30 PM'
      expect(print_appointment_date(appointment_date, 4)).to eq '1st January, 02:30 PM'
    end
  end

  describe 'print_appointment_amount' do
    it 'should return currency and amount in selected currency' do
      expect(print_appointment_amount(appointments(:one))).to eq 'USD 6.01/-'
    end
  end

  describe 'generate_cancel_button' do
    context 'when appointment is not cancellable' do
      it 'should return nil' do
        expect(generate_cancel_button(appointments(:one))).to be_nil
      end
    end

    context 'when appointment is cancellable' do
      it 'should return a button' do
        expect(generate_cancel_button(Appointment.new(**valid_attributes[1]))).not_to be_nil
      end
    end
  end
end
