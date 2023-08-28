require 'rails_helper'

RSpec.describe User, type: :model do
  let(:invalid_attributes) do
    {
      name: 'Hello',
      email: 'kushal@gmail.com',
      currency_preference: 'YEN'
    }
  end

  describe 'presence validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:currency_preference) }
  end

  describe 'uniqueness validations' do
    it { should validate_uniqueness_of(:email) }
  end

  xdescribe 'inclusion validations' do
    it { should validate_inclusion_of(:currency_preference).in_array(User::VALID_CURRENCIES) }
  end

  describe 'name format validations' do
    it { should allow_value('John Doe').for(:name) }
    it { should_not allow_value('John123').for(:name) }
  end

  describe 'email format validations' do
    it { should allow_value('email@addresse.foo').for(:email) }
    it { should_not allow_value('foo').for(:email) }
    it { should_not allow_value('foo@gmail').for(:email) }
  end

  context 'when currency preference is not valid' do
    it 'should have validation errors' do
      expect { User.new(**invalid_attributes) }.to raise_error ArgumentError
    end
  end
end
