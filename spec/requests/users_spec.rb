require 'rails_helper'

RSpec.describe '/users', type: :request do

  let(:valid_attributes) do
    {
      id: 0,
      name: 'John Doe',
      email: 'johndoe@test.com'
    }
  end

  let(:invalid_attributes) do
    {
      id: 0,
      name: nil,
      email: nil
    }
  end

  describe 'POST /login' do
    context 'with valid parameters' do
      it 'sets the user session' do
        post login_url, params: { user: valid_attributes }
        expect(session).to have_key(:current_user_id)
      end

      it 'redirects to the my appointments page' do
        post login_url, params: { user: valid_attributes }
        expect(response).to redirect_to(appointments_url)
      end
    end

    context 'with invalid parameters' do
      it 'redirects to the my login page' do
        post login_url, params: { user: invalid_attributes }
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
