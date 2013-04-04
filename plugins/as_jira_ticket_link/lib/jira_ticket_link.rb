require 'rest_client'
require 'json'

RestClient.proxy = "http://133.192.24.101:8080/"
class JiraTicketLink < AsakusaSatellite::Filter::Base
  def process(text, opts={})
    begin
      text.gsub!(/#(\w+-\d+)/) do
        login unless ENV["JIRA_COOKIE"]

        uri = "#{ENV['AS_JIRA_URL_ROOT']}/rest/api/latest/issue/#{$1}"
        begin
          response = RestClient.get(uri, :cookie => ENV["JIRA_COOKIE"])
        rescue RestClient::Unauthorized => e
          login
          response = RestClient.get(uri, :cookie => ENV["JIRA_COOKIE"])
        end
        fields = JSON::parse(response)["fields"]

        %(<a href="#{ENV['AS_JIRA_URL_ROOT']}/browse/#{$1}" target="_blank">#{fields["summary"]["value"]}</a>)
      end
      text
    rescue => e
      text
    end
  end

  private
  def login
    uri  = "#{ENV['AS_JIRA_URL_ROOT']}/rest/auth/latest/session"
    body = {"username" => ENV['AS_JIRA_USERNAME'],
            "password" => ENV['AS_JIRA_PASSWORD']}.to_json
    response = RestClient.post(uri, body, :content_type => "application/json")
    ENV["JIRA_COOKIE"] = response.cookies.map{|k,v| "#{k}=#{v}"}.join(';')
  end
end
