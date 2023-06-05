class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show edit update destroy ]

  # GET /doctors or /doctors.json
  def index
    @doctors = Doctor.all
    @next_appointment = {}
    # TODO: Add logic to find next appointment
    @doctors.each do |doctor|
      @next_appointment[doctor.id] = '3:00 PM'
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
end
