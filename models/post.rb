require './models/storage.rb'
require 'date'

class Post

    attr_accessor :data

    def initialize data
        @data = data
    end

    def method_missing id
        return @data[id.to_s]
    end

    def save
        date = @data[:date]
        if date.instance_of? String then
            date = DateTime.parse date
        end
        @data[:date] = date.strftime '%Y-%m-%d %H:%M:%S'
        return Storage.set @data
    end

    def self.load(offset = 0, limit = 20)
        results = []
        rows = Storage.get(offset, limit)
        rows.each do |row|
            row['date'] = DateTime.parse row['date']
            post = Post.new row
            results << post
        end
        return results
    end

end
