require 'date'
require 'mongo'

class Post
    attr_accessor :checksum, :title, :date, :link, :content, :image, :type

    def save
        data = {
            :checksum => @checksum,
            :title => @title,
            :date => @date.to_time,
            :link => @link,
            :content => @content,
            :image => @image,
            :type => @type
        }
        Post.connect.insert(data)
    end

    def self.get offset, limit
        query = {}
        options = {
            :skip => offset,
            :limit => limit,
            :sort => [:date, :desc]
        }
        return Post.connect.find(query, options)
    end

    def self.reset
        Post.connect.drop
    end

    private

    def self.connect
        connect = Mongo::Connection.new
        db = connect['slop']
        collection = db['post']
        return collection
    end

end

