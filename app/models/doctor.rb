class Doctor < ApplicationRecord
  has_many :appointments

  validates_presence_of :name, :image, :address, :start_time, :end_time, :lunch_time
  validates :name, format: { with: /[A-Za-z ]+/i }

  MAX_NUMBER_OF_AVAILABLE_DAYS = 7

  def available_appointments
    booked_appointments = appointments.all.map(&:date_time)
    available_slots = {}

    MAX_NUMBER_OF_AVAILABLE_DAYS.times.map do |i|
      date = Date.today + i.days
      available_slots[date] = []

      date_time = combine_date_and_time(date, start_time)
      lunch_date_time = combine_date_and_time(date, lunch_time)
      end_date_time = combine_date_and_time(date, end_time)

      while date_time < end_date_time
        if date_time > DateTime.now && date_time != lunch_date_time && !booked_appointments.include?(date_time)
          available_slots[date].push(date_time)
        end

        date_time += 1.hours
      end

      available_slots.delete(date) if available_slots[date].empty?
    end.compact

    available_slots
  end

  def next_available_appointment
    available_appointments.first&.at(1)&.at(0)
  end

  private

  def combine_date_and_time(date, time)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min,
      time.sec,
      time.zone
    )
  end
end
