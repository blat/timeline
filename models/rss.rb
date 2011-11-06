require './models/stream.rb'
require 'simple-rss'

class Rss < Stream

    def crawl
        body = self.download @options['url']
        uri = URI.parse @options['url']
        result = []
        begin
            rss = SimpleRSS.parse body
            rss.entries.each do |entry|
                content = entry.content_encoded
                while relative_url = content.match(/(src|href)=["'](\/[^"']*)["']/) do
                    relative_url = relative_url[0]
                    url = relative_url.sub('/', "#{uri.scheme}://#{uri.host}/")
                    content = content.sub(relative_url, url)
                end
                data = {
                    :date => entry.pubDate,
                    :link => entry.link,
                    :content => content,
                    :title => entry.title,
                    :type => 'blog'
                }
                result << data
            end
        rescue SimpleRSSError
            puts "RSS Error"
        end
        return result
    end

end
