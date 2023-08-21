require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    [
      {
        id: 0,
        name: 'John Doe',
        email: 'johndoe@test.com',
        currency_preference: 'USD'
      }
    ]
  end

  let(:invalid_attributes) do
    [
      {
        email: nil,
        currency_preference: 'USD'
      },
      {
        name: nil,
        currency_preference: 'USD'
      },
      {
        name: nil,
        email: nil
      },
      {
        name: 'Hello',
        email: 'kushal@gmail.com',
        currency_preference: 'YEN'
      },
      {
        name: 'Hello123',
        email: 'kushal@gmail.com',
        currency_preference: 'USD'
      },
      {
        name: 'Hello',
        email: 'kushal@gmail',
        currency_preference: 'INR'
      }
    ]
  end

  context 'when attributes are missing' do
    it 'should have validation errors' do
      invalid_attributes[0..2].each do |user|
        expect(User.new(**user).valid?).to be_falsey
      end
    end
  end

  context 'when email is not unique' do
    before do
      User.create(**valid_attributes[0])
    end

    it 'should have validation errors' do
      expect(User.new(**valid_attributes[0]).valid?).to be_falsey
    end
  end

  context 'when currency preference is not valid' do
    it 'should have validation errors' do
      expect { User.new(**invalid_attributes[3]) }.to raise_error ArgumentError
    end
  end

  context 'when name is not valid' do
    it 'should have validation errors' do
      expect(User.new(**invalid_attributes[4]).valid?).to be_falsey
    end
  end

  context 'when email is not valid' do
    it 'should have validation errors' do
      expect(User.new(**invalid_attributes[5]).valid?).to be_falsey
    end
  end
end
