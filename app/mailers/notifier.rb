require "net/http"
require "uri"

class Notifier

  def self.dispatch(recipients, subject, body)
    username = ENV["IBLOG_NAVEED_USERNAME"]
    password = ENV["IBLOG_NAVEED_PASSWORD"]
    naveed = ENV["IBLOG_NAVEED_URL"]
    token = ENV["IBLOG_NAVEED_TOKEN"]
    return false unless naveed && token

    naveed = URI.parse(naveed)
    http = Net::HTTP.new(naveed.host, naveed.port)

    req = Net::HTTP::Post.new(naveed.request_uri)
    req.basic_auth(username, password) if username && password
    req.add_field("Authorization", "Bearer #{token}")
    req.set_form_data({
      "recipient" => recipients,
      "subject" => subject,
      "body" => body
    })

    res = http.request(req)
    return res.code == "202"
  end

end
