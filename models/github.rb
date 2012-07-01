require './models/stream.rb'
require 'json'

class Github < Stream

    def crawl
        url = "https://api.github.com/users/#{options['user']}/repos"
        body = self.download url
        result = []
        json = JSON.parse body
        json.each do |repository|
            if not repository['fork'] then
                content = "<p>#{repository['description']}</p>"
                if not repository['homepage'].empty? then
                    content += "<p><img class='icon' src='http://github.com/favicon.ico' /> <a href='#{repository['homepage']}'>#{URI.parse(repository['homepage']).host}</a></p>"
                end
                data = {
                    :date => repository['created_at'],
                    :link => repository['url'],
                    :content => content,
                    :title => repository['name'],
                    :type => 'project'
                }
                result << data
            end
        end
        return result
    end

end
