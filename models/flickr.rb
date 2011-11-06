require './models/stream.rb'
require 'flickraw'

class Flickr < Stream

    def crawl
        result = []
        FlickRaw.api_key = @options['api_key']
        FlickRaw.shared_secret = ''
        photos = flickr.people.getPublicPhotos :user_id => @options['user_id']
        photos.each do |photo|
            info = flickr.photos.getInfo :photo_id => photo.id, :secret => photo.secret
            content = "<a href='#{FlickRaw.url_b(info)}'><img src='#{FlickRaw.url_z(info)}' /></a><p class='legend'>#{info.title}</p>"
            data = {
                :date => info.dates.taken,
                :link => FlickRaw.url_b(info),
                :content => content,
                :type => 'photo'
            }
            result << data
        end
        return result
    end

end
