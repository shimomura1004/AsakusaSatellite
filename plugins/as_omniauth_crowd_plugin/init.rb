require 'cgi'
require 'rest-client'
require 'json'

module AsakusaSatellite
  module OmniAuth
    class Adapter
      def self.adapt(omniauth_hash)
        begin
          jira_uri = "http://apl.glg.denso.co.jp/itswiki/rest/prototype/1/user/non-system/#{omniauth_hash.uid}"
          response = RestClient::Request.new( :method => :get, :url => jira_uri, :user=>"Jenkins", :password=>"Jenkins", :headers => {:accept => :json}).execute
          profile_image_url = "http://apl.glg.denso.co.jp" + JSON.parse(response)["avatarUrl"]
        rescue
          profile_image_url = nil
        end

        screen_name = user_info(omniauth_hash, :email)
        name = user_info(omniauth_hash, :first_name) + " " +
               user_info(omniauth_hash, :last_name)
        {
          :name => name,
          :screen_name => screen_name,
          :profile_image_url => profile_image_url || "data:image/gif;base64,R0lGODlhEAAQAMQfAFWApnCexR4xU1SApaJ3SlB5oSg9ZrOVcy1HcURok/Lo3iM2XO/i1lJ8o2eVu011ncmbdSc8Zc6lg4212DZTgC5Hcmh3f8OUaDhWg7F2RYlhMunXxqrQ8n6s1f///////yH5BAEAAB8ALAAAAAAQABAAAAVz4CeOXumNKOpprHampAZltAt/q0Tvdrpmm+Am01MRGJpgkvBSXRSHYPTSJFkuws0FU8UBOJiLeAtuer6dDmaN6Uw4iNeZk653HIFORD7gFOhpARwGHQJ8foAdgoSGJA1/HJGRC40qHg8JGBQVe10kJiUpIQA7"
        }
      end

      private
      def self.user_info(hash, key)
        CGI.unescapeHTML(hash.info.send(key) || hash.user_info.send(key))
      end
    end
  end
end
