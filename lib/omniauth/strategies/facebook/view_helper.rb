# coding: utf-8
module OmniAuth
  module Strategies
    class Facebook
      class ViewHelper
        module PageHelper
          def facebook_login_page
            facebook_header +
            facebook_login_button +
            facebook_footer
          end

          def facebook_header
            %{
              <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
              <html xmlns="http://www.w3.org/1999/xhtml"> 
              <head> 
              <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
              <title>Вход в Facebook</title>
              </head> 
              <body>
            }
          end

          def facebook_login_button(value = nil, perms = "email")
            value ||= 'Login with Facebook'
            %{
              <div id="fb-root"></div>
              <script src="http://connect.facebook.net/en_US/all.js"></script>
              <script>
                FB.init({ 
                  appId:#{OmniAuth.config.facebook_app_id}, cookie:true,
                  status:true, xfbml:true 
                });
                
                if (jQuery.browser.opera) {
      	          FB.XD._transport="postmessage";
                  FB.XD.PostMessage.init();
      	        }

                fbSession = {
                  afterLogin: function() {
                    FB.api('/me', function(response) {
                      fbSession.redirectWithPost('#{OmniAuth.config.path_prefix}/facebook/callback', response);
                    });
                  },

                  redirectWithPost: function(url, data) {
                    data = data || {};
                    #{ respond_to?(:request_forgery_protection_token) && respond_to?(:form_authenticity_token) ?
                    "data['#{request_forgery_protection_token}'] = '#{form_authenticity_token}'; var method = 'POST';" :
                    "var method = 'GET';" }
                    var form = document.createElement("form"),
                       input;
                    form.setAttribute("action", url);
                    form.setAttribute("method", method);

                    for (var property in data) {
                     if (data.hasOwnProperty(property)) {
                       var value = data[property];
                       if (property == 'location') {
                         input = document.createElement("input");
                          input.setAttribute("type", "hidden");
                          input.setAttribute("name", property);
                          input.setAttribute("value", value['name']);
                          form.appendChild(input);
                       } else {
                         input = document.createElement("input");
                         input.setAttribute("type", "hidden");
                         input.setAttribute("name", property);
                         input.setAttribute("value", value);
                         form.appendChild(input);
                       }
                     }
                    }
                    document.body.appendChild(form);
                    form.submit();
                    document.body.removeChild(form);
                    },
                 }

              </script>
              <fb:login-button #{perms} onlogin="fbSession.afterLogin();">
                #{value}
              </fb:login-button>
            }
          end

          def facebook_footer
            %{
              </body></html>
            }
          end
        end
      end
    end
  end
end
