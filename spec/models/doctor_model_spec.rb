require 'rails_helper'

RSpec.describe Doctor, type: :model do
  fixtures :doctors, :users

  describe 'available_appointments' do
    context 'when no appointment is booked' do
      it "should return array of length #{Doctor::MAX_NUMBER_OF_AVAILABLE_DAYS}" do
        expect(doctors(:one).available_appointments.size).to eq(Doctor::MAX_NUMBER_OF_AVAILABLE_DAYS)
      end
    end

    context 'when all appointments of day 1 are booked' do
      before do
        doctors(:one).available_appointments.first[1].each do |appointment_time|
          Appointment.create!(
            doctor_id: doctors(:one).id,
            user_id: users(:one).id,
            date_time: appointment_time,
            amount: 500,
            conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
          )
        end
      end

      it "should return array of length #{Doctor::MAX_NUMBER_OF_AVAILABLE_DAYS - 1}" do
        expect(doctors(:one).available_appointments.size).to eq(Doctor::MAX_NUMBER_OF_AVAILABLE_DAYS - 1)
      end
    end

    context 'when all appointments are booked' do
      before do
        doctors(:one).available_appointments.each do |_, appointments|
          appointments.each do |appointment_time|
            Appointment.create!(
              doctor_id: doctors(:one).id,
              user_id: users(:one).id,
              date_time: appointment_time,
              amount: 500,
              conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
            )
          end
        end
      end

      it 'should return array of length 0' do
        expect(doctors(:one).available_appointments.size).to eq(0)
      end
    end
  end

  describe 'next_available_appointment' do
    context 'when no appointment is booked' do
      it 'should return the start_time of doctor' do
        expect(doctors(:one).next_available_appointment).to eq(doctors(:one).send(:combine_date_and_time,
                                                                                  Date.today,
                                                                                  doctors(:one).start_time)
                                                            )
      end
    end

    context 'when all appointments are booked' do
      before do
        doctors(:one).available_appointments.each do |_, appointments|
          appointments.each do |appointment_time|
            Appointment.create!(
              doctor_id: doctors(:one).id,
              user_id: users(:one).id,
              date_time: appointment_time,
              amount: 500,
              conversion_rates: { "EUR": 0.011076, "INR": 1, "USD": 0.012029 }
            )
          end
        end
      end

      it 'should return nil' do
        expect(doctors(:one).next_available_appointment).to be_nil
      end
    end
  end
end
