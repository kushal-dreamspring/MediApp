class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user
  validate :date_must_be_in_future
  validates_uniqueness_of :date_time, scope: [:user], message: 'User already has a appointment at this time'
  validates_uniqueness_of :date_time, scope: [:doctor], message: 'Doctor already has a appointment at this time'

  private

  def date_must_be_in_future
    return if date_time >= DateTime.current

    errors.add(:date_time, 'must be in future')
  end
end
