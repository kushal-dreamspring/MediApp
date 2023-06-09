class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show edit update destroy ]

  # GET /doctors or /doctors.json
  def index
    @doctors = Doctor.all
    @next_appointment = {}

    @doctors.each do |doctor|
      dates = (0..6).map { |i| Date.today + i }
      booked_appointments = Appointment.where(doctor_id: doctor.id).map { |ap| ap.date_time }

      dates.each do |date|
        date_time = time_to_datetime(date, doctor.start_time)
        lunch_date_time = time_to_datetime(date, doctor.lunch_time)
        end_date_time = time_to_datetime(date, doctor.end_time)

        while (date_time < end_date_time) && (date_time < Time.now || date_time == lunch_date_time || booked_appointments.include?(date_time)) do
          date_time += 3600
        end

        if date_time < end_date_time
          @next_appointment[doctor.id] = date_time
          break
        end
      end

      @next_appointment[doctor.id] = 'Not Available' unless @next_appointment[doctor.id]
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:name, :image, :start_time, :end_time, :lunch_time)
  end

  def time_to_datetime(date, time)
    Time.zone = 'Kolkata'
    Time.zone.at(Time.zone.at(date.to_datetime) - Time.zone.utc_offset + time - Time.zone.utc_offset - Time.zone.iso8601('2000-01-01T00:00:00'))
  end
end
