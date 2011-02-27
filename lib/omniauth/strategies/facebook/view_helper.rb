# coding: utf-8
module OmniAuth
  module Strategies
    class Facebook
      class ViewHelper
        module PageHelper
          def facebook_login_button(options={})
            defaults = {
              :native => true,
              :title => 'Login with Facebook',
              :image => 'http://static.ak.fbcdn.net/images/fbconnect/login-buttons/connect_light_medium_long.gif',
              :perms => 'email,offline_access'
            }
            options = defaults.merge!(options)
            if options[:native]
              %{
                <div id="fb-root"></div>
                <script src="http://connect.facebook.net/en_US/all.js"></script>
                <script>
                  FB.init({ 
                    appId:#{OmniAuth.config.facebook_app_id},
                    cookie:true,
                    status:true,
                    xfbml:true 
                  });

                  if (jQuery.browser.opera) {
        	          FB.XD._transport="postmessage";
                    FB.XD.PostMessage.init();
        	        }
        	        
        	        function afterFBLogin() {
        	          if ( FB.getSession() != null ) {
        	            window.location='#{OmniAuth.config.path_prefix}/facebook?perms=#{options[:perms]}';
        	          }        	          
        	        };
        	        
                </script>
             
                <fb:login-button onlogin="afterFBLogin();" perms="#{options[:perms]}" >
                  #{options[:title]}                  
                </fb:login-button>
              }
            else
              %{
                <a title="#{options[:title]}" href="#{OmniAuth.config.path_prefix}/facebook?perms=#{options[:perms]}">
                  <img src="#{options[:image]}" alt="#{options[:title]}">
                </a>                  
              }
            end
          end
        end
      end
    end
  end
end
