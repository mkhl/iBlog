require "net/http"
require "uri"

class Notifier

  def self.dispatch(recipients, subject, body)
    naveed = ENV["IBLOG_NAVEED_URL"]
    token = ENV["IBLOG_NAVEED_TOKEN"]
    return false unless naveed && token

    naveed = URI.parse(naveed)
    http = Net::HTTP.new(naveed.host, naveed.port)
    http.use_ssl = true if naveed.scheme == "https"

    req = Net::HTTP::Post.new(naveed.request_uri)
    req.add_field("Authorization", "Bearer #{token}")
    req.set_form_data({
      "recipient" => recipients,
      "subject" => subject,
      "body" => body
    })

    http.read_timeout = 1
    res = http.request(req) rescue nil
    return res.try(:code) == "202"
  end

end
