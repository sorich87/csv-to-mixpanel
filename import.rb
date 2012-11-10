require 'rubygems'
require 'base64'
require 'json'
require 'active_support'
require 'csv'
require 'uri'
require 'net/http'

module CSVToMixpanel
  class Import
    def initialize(file, token)
      @token = token
      @file = file
    end

    def perform!
      CSV.foreach(@file, headers: true) do |row|
        import_user(row)
      end
    end

    def import_user(attributes)
      puts "Importing attributes.inspect..."

      params = {
        '$set' => {
          '$created' => attributes['created'],
          '$email' => attributes['email'],
          '$first_name' => attributes['first_name'],
          '$last_name' => attributes['last_name']
        },
        '$token' => @token,
        '$distinct_id' => attributes['id']
      }
      data = Base64.strict_encode64(JSON.generate(params))

      request_uri = "http://api.mixpanel.com/engage/?data=#{data}"
      Net::HTTP.get(URI(request_uri))
    end
  end
end

