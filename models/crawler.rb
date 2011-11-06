require './models/storage.rb'
require './models/post.rb'

class Crawler

    def initialize
        @services = []
    end

    def add_service service
        @services << service
    end

    def run
        Storage.reset # FIXME
        @services.each do |service|
            service.crawl.each do |data|
                post = Post.new data
                post.save
            end
        end
    end

end
