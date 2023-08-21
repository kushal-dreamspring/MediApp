# frozen_string_literal: true

module SessionLogic
  extend ActiveSupport::Concern

  included do
    def session_login(user_id)
      session[:current_user_id] = user_id
    end

    def current_user_id
      session[:current_user_id]
    end
  end
end
