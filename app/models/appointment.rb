class Appointment < ApplicationRecord
  enum currency: {
    'INR' => 0,
    'USD' => 1,
    'EUR' => 2
  }

  belongs_to :doctor
  belongs_to :user
end
