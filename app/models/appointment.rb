class Appointment < ApplicationRecord
  enum currency: {
    'INR' => 0,
    'USD' => 1,
    'EUR' => 2
  }

  belongs_to :doctor
  belongs_to :user
  validate :date_must_be_in_future

  private

  def date_must_be_in_future
    return if date_time >= DateTime.current

    errors.add(:date_time, 'must be in future')
  end
end
