class OauthUser < ActiveRecord::Base
#################################### FACEBOOK_OAUTH ####################################

  def self.facebookAccessTokenCheckWithCode(code,redirect_uri)

      user = Hash.new
      begin

        response = RestClient.get "#{'https://graph.facebook.com/oauth/access_token?client_id=give_your_client_id&client_secret=give_your_client_secret&redirect_uri='}#{redirect_uri}#{'&code='}#{code}"
        token_res = response.body
        accessToken = (token_res.split("=")[1]).split("&")[0]
        user = facebookAccessTokenCheck(accessToken)
      
      rescue Exception => e
        user["message"] = e.message
        user["status"] = false
      end
      
      return user
  
  end

  def self.facebookAccessTokenCheck(accessToken)
      
      user = Hash.new
      user_info = Hash.new
      details = Hash.new
      
      begin
         
         response = RestClient.get "#{'https://graph.facebook.com/v2.8/me?fields=first_name,last_name,email,picture.type(small)&access_token='}#{accessToken}"
         profile = JSON.parse(response.body)
         details["email"] =  profile['email']
         details["name"] = profile['first_name'] + profile["last_name"]
         details["facebook_access_token"] = accessToken
         details["image"] = profile["picture"]["data"]["url"]
         details["provider"] = "facebook"
         details["status"] = true

      rescue Exception => e
         details = e.message
        user["status"] = false

      end
      
      return details
  
  end

end