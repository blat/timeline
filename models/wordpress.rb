require './models/stream.rb'
require './models/rss.rb'

class Wordpress < Stream

    def crawl
        result = []
        page = 1
        begin
            options = {
                'url' => "#{@options['url']}/author/#{@options['author']}/feed?paged=#{page}&#{@options['additional_parameters']}"
            }
            rss = Rss.new options
            data = rss.crawl
            result = result + data
            page = page + 1
        end while not data.empty?
        return result
    end

end
