require 'rails_helper'

RSpec.describe '/doctors', type: :request do
  fixtures :doctors

  describe 'GET /index' do
    it 'renders a successful response' do
      get doctors_url
      expect(response).to be_successful
    end

    it 'sets @next_appointment for all doctors' do
      get doctors_url
      expect(assigns(:doctors).size).to be(2)
    end
  end
end
