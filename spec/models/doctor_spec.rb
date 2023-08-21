require 'rails_helper'
require 'timecop'

RSpec.describe Doctor, type: :model do
  fixtures :doctors, :users

  let(:invalid_attributes) do
    [
      {
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        address: 'Wayne Mansion, Gotham',
        start_time: '2000-01-01 09:00:00',
        end_time: '2000-01-01 17:00:00',
        lunch_time: '2000-01-01 13:00:00'
      },
      {
        name: 'Batman',
        address: 'Wayne Mansion, Gotham',
        start_time: '2000-01-01 09:00:00',
        end_time: '2000-01-01 17:00:00',
        lunch_time: '2000-01-01 13:00:00'
      },
      {
        name: 'Batman',
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        start_time: '2000-01-01 09:00:00',
        end_time: '2000-01-01 17:00:00',
        lunch_time: '2000-01-01 13:00:00'
      },
      {
        name: 'Batman',
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        address: 'Wayne Mansion, Gotham',
        end_time: '2000-01-01 17:00:00',
        lunch_time: '2000-01-01 13:00:00'
      },
      {
        name: 'Batman',
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        address: 'Wayne Mansion, Gotham',
        start_time: '2000-01-01 09:00:00',
        lunch_time: '2000-01-01 13:00:00'
      },
      {
        name: 'Batman',
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        address: 'Wayne Mansion, Gotham',
        start_time: '2000-01-01 09:00:00',
        end_time: '2000-01-01 17:00:00',
      },
      {
        name: 'Batman123',
        image: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse3.mm.bing.net%2Fth%3Fid%3DOIP.iD-DLh5NRStUnPKSUq1IIQHaFf%26pid%3DApi&f=1&ipt=ee801bcb736c46dc3abe22650ad3841b2462ed1bee08832a8e861b7da5fe46b9&ipo=images',
        address: 'Wayne Mansion, Gotham',
        start_time: '2000-01-01 09:00:00',
        end_time: '2000-01-01 17:00:00',
        lunch_time: '2000-01-01 13:00:00'
      }
    ]
  end

  describe 'validations' do
    context 'when attributes are missing' do
      it 'should have validation errors' do
        invalid_attributes[0..5].each do |doctor|
          expect(Doctor.new(**doctor).valid?).to be_falsey
        end
      end
    end

    context 'when name is not valid' do
      it 'should have validation errors' do
        expect(Doctor.new(**invalid_attributes[6]).valid?).to be_falsey
      end
    end
  end

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
        Timecop.freeze(Date.today) do
          expect(doctors(:one).next_available_appointment).to eq(doctors(:one).send(:combine_date_and_time,
                                                                                    Date.today,
                                                                                    doctors(:one).start_time)
                                                              )
        end
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
