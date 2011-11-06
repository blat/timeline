require './models/stream.rb'
require 'json'

class Lastfm < Stream

    def crawl
        url = "http://ws.audioscrobbler.com/2.0/?method=user.getpastevents&user=#{options['user']}&api_key=#{options['api_key']}&format=json"
        body = self.download url
        result = []
        json = JSON.parse body
        json['events']['event'].each do |event|
            data = {
                :date => event['startDate'],
                :link => event['url'],
                :title => "#{event['title']} @ #{event['venue']['location']['city']} (#{event['venue']['name']})",
                :type => 'event'
            }
            result << data
        end
        return result
    end

end
