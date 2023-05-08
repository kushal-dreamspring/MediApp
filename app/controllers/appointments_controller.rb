class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    @dates = (0..6).map { |i| Date.today + i }
    @times = {}
    doctor = Doctor.find(params[:doctor_id])
    @booked_appointments = Appointment.where(doctor_id: params[:doctor_id]).map { |ap| ap.date_time }

    @dates.each do |date|
      @times[date] = []
      time = doctor.start_time
      while time < doctor.end_time do
        date_time = Time.zone.at(Time.zone.at(date.to_datetime) + time - Time.zone.local(2000, 1, 1, 0, 0, 0))
        date_time += 3600 if time == doctor.lunch_time || @booked_appointments.include?(date_time)
        @times[date].push({ time: date_time })
        time += 3600
      end
    end
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @user = User.find_by(email: user_params[:email])
    @user = User.create(user_params) if @user.nil?

    @appointment = Appointment.new(**appointment_params,
                                   amount: CurrencyService.amount_in_currency(500, appointment_params[:currency]),
                                   user_id: @user.id)

    respond_to do |format|
      if @appointment.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            :new_appointment,
            partial: 'appointments/appointment_success',
            locals: { appointment_time: @appointment.date_time }
          )
        }
      else
        puts @appointment.errors.full_messages
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    respond_to do |format|
      if @appointment.update(appointment_params)
        format.html { redirect_to appointment_url(@appointment), notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url, notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:doctor_id, :date_time, :amount, :currency)
  end

  def user_params
    params.require(:appointment).permit(:name, :email)
  end
end
