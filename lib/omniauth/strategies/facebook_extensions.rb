require 'omniauth/strategies/oauth2'
require 'omniauth/strategies/facebook'
require 'multi_json'

require 'omniauth/strategies/facebook/view_helper'


# Authenticate to Facebook utilizing OAuth 2.0 and retrieve
# basic user information.
#
# @example Basic Usage
#   use OmniAuth::Strategies::Facebook, 'client_id', 'client_secret'
class OmniAuth::Strategies::Facebook < OmniAuth::Strategies::OAuth2
  # @param [Rack Application] app standard middleware application parameter
  # @param [String] client_id the application id as [registered on Facebook](http://www.facebook.com/developers/)
  # @param [String] client_secret the application secret as registered on Facebook
  # @option options [String] :scope ('email,offline_access') comma-separated extended permissions such as `email` and `manage_pages`
  # def initialize(app, client_id = nil, client_secret = nil, options = {}, &block)
  #   super(app, :facebook, client_id, client_secret, {:site => 'https://graph.facebook.com/'}, options, &block)
  # end
  # 
  # def user_data
  #   @data ||= MultiJson.decode(@access_token.get('/me', {}, { "Accept-Language" => "en-us,en;"}))
  # end
  # 
  # def request_phase
  #   options[:scope] ||= "email,offline_access"
  #   super
  # end

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

  # def auth_hash
  #     OmniAuth::Utils.deep_merge(super, {
  #       'uid' => user_data['id'],
  #       'user_info' => user_info,
  #       'extra' => {'user_hash' => user_data}
  #       })
  #     end
  #   end
end
  # module OmniAuth
  #   class Configuration
  #     attr_accessor :facebook_app_id, :facebook_api_key
  #   end
  # end
  # 
  # module OmniAuth
  #   module Strategies
  #     class Facebook < OAuth2
  #       include OmniAuth::Strategy
  #       include ViewHelper::PageHelper
  # 
  #       def initialize(app, app_id, app_api_key, options = {})
  #         OmniAuth.config.facebook_app_id = app_id
  #         OmniAuth.config.facebook_api_key = app_api_key
  #         @options = options
  #         super(app, :facebook)
  #       end
  # 
  #       attr_reader :app_id
  #       attr_reader :app_api_key
  #       
  #       def request_phase
  #         options[:scope] ||= "email,offline_access"
  #         super
  #       end
  #       
  #       def auth_hash
  #         OmniAuth::Utils.deep_merge(super(), {
  #           'uid' => request[:id],
  #           'user_info' => {
  #             'nickname' => request[:link].split('/').last,
  #             'email' => (request[:email] if request[:email].present?),
  #             'name' => request[:name],
  #             'first_name' => request[:first_name],
  #             'last_name' => request[:last_name],
  #             'image' => "http://graph.facebook.com/#{request[:id]}/picture?type=square",
  #             'location' => request[:location],
  #             'urls' => {
  #               'Facebook' => request[:link]
  #             }
  #           }
  #         })
  #       end
  #     end
  #   end
  # end
