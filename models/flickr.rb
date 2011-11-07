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
            link = FlickRaw.url_photopage(info)
            content = "<a href='#{link}'><img src='#{FlickRaw.url_z(info)}' /></a><p class='legend'>#{info.title}</p>"
            data = {
                :date => info.dates.taken,
                :link => link,
                :content => content,
                :type => 'photo'
            }
            result << data
        end
        return result
    end

end
