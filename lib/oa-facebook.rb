require 'omniauth/strategies/facebook_extensions'

# require 'omniauth/core'

module OmniAuth
  module Strategies
    autoload :Facebook, 'omniauth/strategies/facebook'
  end
end


if defined?(Rails)
  ActionController::Base.helper OmniAuth::Strategies::Facebook::ViewHelper::PageHelper
end
