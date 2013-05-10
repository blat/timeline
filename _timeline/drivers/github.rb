require 'github_api'
require 'base64'

module Timeline
    class Github
        include Import

        def initialize options
            @username = options['username']
            @github = ::Github.new
        end

        def export
            repos = @github.repos.list user: @username
            repos.each do |repo|
                unless repo['fork'] then
                    name = repo['name']
                    content = get_content name
                    self.import repo['created_at'], name, content, {
                        'title'        => name,
                        'excerpt'      => repo['description'],
                        'update'       => repo['pushed_at'],
                        'source_url'   => repo['html_url'],
                        'source_title' => 'Github',
                    }
                end
            end
        end

        private

        def get_content repo
            readme = @github.repos.contents.readme @username, repo
            Base64.decode64 readme.content
        end

    end
end
