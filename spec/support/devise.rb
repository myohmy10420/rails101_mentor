# frozen_string_literal: true
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

module DeviseHelpers
  def set_devise_user_mapping
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
end
