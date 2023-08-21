class User < ApplicationRecord
  enum currency_preference: {
    'INR' => 0,
    'USD' => 1,
    'EUR' => 2
  }

  has_many :appointments

  validates_presence_of :name, :email, :currency_preference
  validates_uniqueness_of :email
  validates_inclusion_of :currency_preference, in: %w[INR EUR USD]
  validates :name, format: { with: /[A-Za-z ]+/i }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
