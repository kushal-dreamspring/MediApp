class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user
  accepts_nested_attributes_for :user

  validates_presence_of :doctor, :user, :date_time, :amount, :conversion_rates
  validates :date_time, comparison: { greater_than: DateTime.current }
  validates_uniqueness_of :date_time, scope: [:user], message: 'User already has a appointment at this time'
  validates_uniqueness_of :date_time, scope: [:doctor], message: 'Doctor already has a appointment at this time'
end
