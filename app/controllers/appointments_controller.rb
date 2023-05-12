class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show edit update destroy ]

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.all
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    @appointment = Appointment.all.find(params[:id])

    respond_to do |format|
      format.html
      format.csv
      format.pdf do
        render layout: 'application',
               pdf: "Appointment No. #{@appointment.id}",
               page_size: 'A5',
               orientation: "Landscape",
               zoom: 1,
               dpi: 75,
               locals: { appointment: @appointment }
      end
      format.txt
    end
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    @times = {}

    dates = (0..6).map { |i| Date.today + i }
    doctor = Doctor.find(params[:doctor_id])
    booked_appointments = Appointment.where(doctor_id: params[:doctor_id]).map { |ap| ap.date_time }

    dates.each do |date|
      @times[date] = []

      date_time = time_to_datetime(date, doctor.start_time)
      lunch_date_time = time_to_datetime(date, doctor.lunch_time)
      end_date_time = time_to_datetime(date, doctor.end_time)

      while date_time < end_date_time do
        if date_time < Time.now || date_time == lunch_date_time || booked_appointments.include?(date_time)
          date_time += 3600
          next
        end
        @times[date].push({ time: date_time })
        date_time += 3600
      end

      @times.delete(date) if @times[date].empty?
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
        InvoiceMailer
          .with(appointment_id: @appointment.id, pdf: appointment_url(@appointment, format: :pdf))
          .invoice_email.deliver_later(wait_until: @appointment.date_time + 2.hours)

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

  def time_to_datetime(date, time)
    Time.zone = 'Kolkata'
    Time.zone.at(Time.zone.at(date.to_datetime) - Time.zone.utc_offset + time - Time.zone.utc_offset - Time.zone.iso8601('2000-01-01T00:00:00'))
  end
end
