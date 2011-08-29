require 'date'
require 'digest/sha1'
require 'flickraw'
require 'simple-rss'
require 'open-uri'
require './models/post'

class Crawler

    def self.run services
        Post.reset
        services.each do |key, service|
        case service['type']
                when 'flickr'
                    self.crawl_flickr service
                when 'rss'
                    self.crawl_rss service
           end
        end
    end

    private

    def self.crawl_flickr service
        FlickRaw.api_key = service['api_key']
        photos = flickr.people.getPublicPhotos :user_id => service['user_id']
        photos.each do |photo|
            info = flickr.photos.getInfo :photo_id => photo.id, :secret => photo.secret
            post = Post.new
            post.checksum = Digest::SHA1.hexdigest(photo.id.to_s)
            post.title = info.title
            post.date = DateTime.parse(info.dates.taken)
            post.image = FlickRaw.url_z(info)
            post.link = FlickRaw.url_b(info)
            post.type = 'image'
            post.save
        end
    end

    def self.crawl_rss service
        rss = SimpleRSS.parse open(service['url'])
        rss.entries.each do |entry|
            post = Post.new
            post.checksum = Digest::SHA1.hexdigest(entry.link)
            post.title = entry.title
            post.date = entry.pubDate
            post.content = entry.content_encoded
            post.link = entry.link
            post.type = 'text'
            post.save
        end
    end

end

