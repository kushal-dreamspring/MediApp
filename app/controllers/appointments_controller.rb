class AppointmentsController < ApplicationController
  helper CurrencyHelper
  before_action :set_appointment, :authorize_user, only: %i[show destroy]
  include DateTimeUtilities

  # GET /appointments or /appointments.json
  def index
    user_id = session[:current_user_id]
    if user_id
      @appointments = Appointment.where(user_id:).all
    else
      redirect_to login_url, notice: I18n.t('login_to_view_your_appointments')
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
    @user = User.find_by(email: user_params[:email])
    @user = User.create(user_params) if @user.nil?
    session[:current_user_id] = @user.id

    @appointment = Appointment.new(**appointment_params,
                                   amount: CurrencyHelper.amount_in_currency(500, appointment_params[:currency]),
                                   user_id: @user.id)

    respond_to do |format|
      if @appointment.save
        InvoiceMailer
          .with(appointment_id: @appointment.id, url: appointment_url(@appointment))
          .invoice_email.deliver_later(wait_until: @appointment.date_time + 2.hours)

        format.turbo_stream do
          FakeServiceJob.set(wait: 1.second).perform_later(@appointment)
        end
      else
        puts @appointment.errors.full_messages
        format.html { redirect_to new_appointment_url, status: :unprocessable_entity, alert: @appointment.errors.messages[:date_time][0] }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    respond_to do |format|
      if @appointment.date_time - DateTime.now > 30.minutes
        @appointment.destroy

        format.html { redirect_to appointments_url, notice: I18n.t('your_appointment_has_been_cancelled') }
      else
        format.html { redirect_to appointments_url, alert: I18n.t('you_can_not_cancel_this_appointment') }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find_by(id: params[:id])

    redirect_to appointments_url, alert: 'Appointment not found. Redirecting to your appointments' if @appointment.nil?
  end

  def authorize_user
    return unless @appointment.user.id != session[:current_user_id]

    redirect_to appointments_url, alert: 'You are not authorised to this URL. Redirecting to your appointments'
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:doctor_id, :date_time, :amount, :currency)
  end

  def user_params
    params.require(:appointment).permit(:name, :email)
  end
end
