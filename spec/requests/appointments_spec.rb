require 'rails_helper'

RSpec.describe '/appointments', type: :request do
  fixtures :appointments, :doctors, :users

  let(:valid_attributes) do
    [
      {
        name: 'Test User',
        email: 'test@123.com',
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 20.minutes,
        amount: 500,
        currency: 'INR'
      },
      {
        name: users(:zero).name,
        email: users(:zero).email,
        doctor_id: doctors(:one).id,
        date_time: DateTime.now + 1.hours,
        amount: 500,
        currency: 'INR'
      }
    ]
  end

  let(:invalid_attributes) do
    {
      id: 0,
      name: users(:zero).name,
      email: users(:zero).email,
      doctor_id: doctors(:one).id,
      date_time: DateTime.now - 1.hours,
      amount: 500,
      currency: 'INR'
    }
  end

  describe 'GET /index' do
    context 'when user is not logged in' do
      it 'should redirect to login url' do
        get appointments_url
        expect(response).to redirect_to(login_url)
      end
    end

    context 'when user is logged in' do
      before do
        allow_any_instance_of(AppointmentsController).to receive(:session) {
          { current_user_id: appointments[0][:user_id] }
        }
      end

      it 'should set @appointment' do
        get appointments_url
        expect(assigns(:appointments).size).to eq appointments.size
      end

      it 'should render the index page' do
        get appointments_url
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET /new' do
    it 'should set @times' do
      get new_appointment_url, params: { doctor_id: doctors(:one).id }
      expect(assigns(:times)).to_not be_empty
    end

    it 'should render the new page' do
      get new_appointment_url, params: { doctor_id: doctors(:one).id }
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'should set @user to a new user if user does not already exists' do
        post appointments_url, params: { appointment: { **valid_attributes[0] } }, as: :turbo_stream
        expect(assigns(:user).email).to eq valid_attributes[0][:email]
      end

      it 'should set @user to existing user if user already exists' do
        post appointments_url, params: { appointment: { **valid_attributes[1] } }, as: :turbo_stream
        expect(assigns(:user).email).to eq valid_attributes[1][:email]
      end

      it 'should create a new appointment' do
        expect do
          post appointments_url, params: { appointment: { **valid_attributes[1] } }, as: :turbo_stream
        end.to change(Appointment, :count).by(1)
      end

      it 'should send a mail' do
        expect(InvoiceMailer).to receive_message_chain(:with, :invoice_email, :deliver_later)

        post appointments_url, params: { appointment: { **valid_attributes[1] } }, as: :turbo_stream
      end
    end

    context 'with invalid parameters' do
      it 'should throw validation error' do
        post appointments_url, params: { appointment: { **invalid_attributes } }, as: :turbo_stream
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'DELETE /delete/:id' do
    context 'when appointment is in less than 30 mins' do
      it 'should not cancel the appointments' do
        post appointments_url, params: { appointment: { **valid_attributes[0] } }, as: :turbo_stream
        expect { delete appointment_url(Appointment.last.id) }.to change(Appointment, :count).by(0)
      end
    end

    context 'when appointment is in more than 30 mins' do
      it 'should cancel the appointment' do
        post appointments_url, params: { appointment: { **valid_attributes[1] } }, as: :turbo_stream
        expect { delete appointment_url(Appointment.last.id) }.to change(Appointment, :count).by(-1)
      end
    end
  end
end
