class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user
  accepts_nested_attributes_for :user

  validates_presence_of :doctor, :user, :date_time, :amount, :conversion_rates
  validates :date_time, comparison: { greater_than: DateTime.current }
  validates_uniqueness_of :date_time, scope: [:user], message: I18n.t('appointments_model.error_messages.user_already_has_a_appointment_at_this_time')
  validates_uniqueness_of :date_time, scope: [:doctor], message: I18n.t('appointments_model.error_messages.doctor_already_has_a_appointment_at_this_time')

  def amount_in_preferred_currency
    (amount * conversion_rates[user.currency_preference]).round(2)
  end
end
