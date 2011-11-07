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
                content = content.gsub(/<br[^>]*>/, '')
                    .gsub(/<\/?div[^>]*>/, '')
                    .gsub(/<img[^>]*>/, '')
                    .gsub(/<ol(.|\n)*ol>/, '')
                    .gsub(/<object(.|\n)*object>/, '')
                    .gsub(/<a[^>]*><\/a>/, '')
                    .gsub(/<p[^>]+>/, '<p>')
                    .gsub(/<p><\/p>/, '')
                    .split('</p>')[0,3].join('</p>')
                uri = URI.parse entry.link
                content += " <a href='#{entry.link}'>[...]</a></p><p><img class='icon' src='http://avatars.netvibes.com/favicon/#{uri.scheme}://#{uri.host}' /> <a href='#{entry.link}'>#{uri.host}</a></p>"
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
