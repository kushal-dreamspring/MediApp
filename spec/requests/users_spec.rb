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

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.to raise_error(ActiveRecord::NotNullViolation)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.to raise_error(ActiveRecord::NotNullViolation)
      end
    end
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
