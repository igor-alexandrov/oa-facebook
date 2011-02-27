require 'omniauth/strategies/facebook/view_helper'


module OmniAuth
  class Configuration
    attr_accessor :facebook_app_id, :facebook_app_secret
  end
end

module OmniAuth
  module Strategies
    class Facebook < OmniAuth::Strategies::OAuth2      
      def initialize(app, client_id = nil, client_secret = nil, options = {}, &block)
        OmniAuth.config.facebook_app_id = client_id
        OmniAuth.config.facebook_app_secret = client_secret
        
        client_options = {}
        client_options[:site] = 'https://graph.facebook.com/'
        
        super(app, :facebook, client_id, client_secret, client_options, options, &block)
      end
                  
      def request_phase
        request[:perms].nil? ? options[:scope] ||= "email,offline_access" : options[:scope] ||= request[:perms]
        super
      end
      
      def user_info
        {
          'nickname' => user_data["link"].split('/').last,
          'email' => (user_data["email"] if user_data["email"]),
          'first_name' => user_data["first_name"],
          'last_name' => user_data["last_name"],
          'name' => "#{user_data['first_name']} #{user_data['last_name']}",
          'image' => "http://graph.facebook.com/#{user_data['id']}/picture?type=square",
          'urls' => {
            'Facebook' => user_data["link"],
            'Website' => user_data["website"],
          }
        }
      end
    end
  end
end