require 'omniauth/facebook'

if defined?(Rails)
  ActionController::Base.helper OmniAuth::Strategies::Facebook::ViewHelper::PageHelper
end
