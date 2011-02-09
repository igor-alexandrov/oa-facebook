require 'omniauth/facebook'
require 'omniauth/strategies/facebook/view_helper'

module OmniAuth
  class Configuration
    attr_accessor :facebook_app_id, :facebook_api_key
  end
end

module OmniAuth
  module Strategies
    class Facebook
      include OmniAuth::Strategy
      include ViewHelper::PageHelper

      def initialize(app, app_id, app_api_key, options = {})
        OmniAuth.config.facebook_app_id = app_id
        OmniAuth.config.facebook_api_key = app_api_key
        @options = options
        super(app, :facebook)
      end

      attr_reader :app_id
      attr_reader :app_api_key
      
      def request_phase
        Rack::Response.new(facebook_login_page).finish
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => request[:id],
          'user_info' => {
            'nickname' => request[:link].split('/').last,
            'email' => (request[:email] if request[:email].present?),
            'name' => request[:name],
            'first_name' => request[:first_name],
            'last_name' => request[:last_name],
            'image' => "http://graph.facebook.com/#{request[:id]}/picture?type=square",
            'location' => request[:location],
            'urls' => {
              'Facebook' => request[:link]
            }
          }
        })
      end
    end
  end
end
