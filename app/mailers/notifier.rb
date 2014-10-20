require "net/http"
require "uri"

class Notifier

  def self.dispatch(recipients, subject, body)
    naveed = ENV["IBLOG_NAVEED_URL"]
    token = ENV["IBLOG_NAVEED_TOKEN"]
    return false unless naveed && token

    naveed = URI.parse(naveed)
    http = Net::HTTP.new(naveed.host, naveed.port)

    req = Net::HTTP::Post.new(naveed.request_uri)
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
