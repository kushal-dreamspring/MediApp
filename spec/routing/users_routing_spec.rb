require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/login').to route_to('users#new')
    end

    it 'routes to #login' do
      expect(post: '/login').to route_to('users#login')
    end
  end
end