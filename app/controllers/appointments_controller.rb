# frozen_string_literal: true

class AppointmentsController < ApplicationController
  include SessionLogic
  include CurrencyService

  before_action :set_appointment, :authorize_user, only: %i[show destroy]

  APPOINTMENT_PRICE_IN_INR = 500
  INVOICE_EMAIL_WAIT_TIME = 2.hours
  FAKE_SERVICE_WAIT_TIME = 1.second
  APPOINTMENT_DELETE_DEADLINE = 30.minutes

  # GET /appointments or /appointments.json
  def index
    if current_user_id
      @appointments = User.find_by_id(current_user_id).appointments
    else
      redirect_to login_url, notice: I18n.t('appointments_page.notice.login_to_view_your_appointments')
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    respond_to do |format|
      format.csv
      format.html
      format.pdf do
        render layout: 'application',
               pdf: "Appointment No. #{@appointment.id}",
               page_size: 'A5',
               orientation: 'Landscape',
               zoom: 1,
               dpi: 75,
               locals: { appointment: @appointment }
      end
      format.txt
    end
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new(doctor_id: params[:doctor_id])
    @appointment.build_user
    @times = @appointment.doctor.available_appointments
  end

  # POST /appointments or /appointments.json
  def create
    conversion_rates = CurrencyService.exchange_rates

    if conversion_rates.nil?
      redirect_to new_appointment_url, status: :unprocessable_entity, alert: I18n.t('appointments_page.notice.system_issue_message')
      return
    end

    @appointment = Appointment.new(**appointment_params, amount: APPOINTMENT_PRICE_IN_INR, conversion_rates:)
    @appointment.user = User.find_or_initialize_by(email: user_params[:email])
    @appointment.user.update(**user_params)

    respond_to do |format|
      if @appointment.save
        post_create_actions
        format.turbo_stream do
          FakeServiceJob.set(wait: FAKE_SERVICE_WAIT_TIME).perform_later(@appointment)
        end
      else
        @times = @appointment.doctor.available_appointments
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    respond_to do |format|
      if @appointment.date_time - DateTime.now > APPOINTMENT_DELETE_DEADLINE && @appointment.destroy
        format.html { redirect_to appointments_url, notice: I18n.t('appointments_page.notice.successful_cancellation_message') }
      else
        format.html { redirect_to appointments_url, alert: I18n.t('appointments_page.notice.unsuccessful_cancellation_message') }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])

    redirect_to appointments_url, alert: I18n.t('appointments_page.notice.appointment_not_found_message') if @appointment.nil?
  end

  def authorize_user
    return unless @appointment.user.id != current_user_id

    redirect_to appointments_url, alert: I18n.t('appointments_page.notice.not_authorised_message')
  end

  def post_create_actions
    session_login(@appointment.user.id)

    InvoiceMailer
      .with(appointment_id: @appointment.id)
      .invoice_email.deliver_later(wait_until: @appointment.date_time + INVOICE_EMAIL_WAIT_TIME)
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:doctor_id, :date_time, :amount)
  end

  def user_params
    params.require(:appointment).require(:user_attributes).permit(:name, :email, :currency_preference)
  end
end
