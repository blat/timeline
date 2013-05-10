require 'wordpress-xmlrpc-api'

module Timeline
    class Wordpress
        include Import

        def initialize options
            @url = options['url']
            @username = options['username']
            if options.key? 'excluded_categories' then
                @excluded_categories = options['excluded_categories']
            else
                @excluded_categories = []
            end
            @blog = 0

            @wp = WordpressXmlRpc.new 'http://' + @url + '/xmlrpc.php', @username, options['password']

            @user_id = 0
            authors = @wp.getAuthors @blog
            authors.each do |author|
                if author['user_login'] == @username then
                    @user_id = author['user_id']
                    break
                end
            end

            data = @wp.getOptions @blog, ['blog_title']
            @source = data['blog_title']['value']
        end

        def export
            offset = 0
            limit = 100
            while true
                posts = get_posts limit, offset
                if posts.empty? then
                    break
                end
                posts = filter_posts posts

                posts.each do |post|
                    content = get_content post
                    excerpt = get_excerpt post
                    thumbnail = get_thumbnail post
                    import post['post_date'].to_time, post['post_name'], content, {
                        'title'        => post['post_title'],
                        'excerpt'      => excerpt,
                        'thumbnail'    => thumbnail,
                        'source_url'   => post['link'],
                        'source_title' => @source,
                    }
                end

                offset += limit
            end
        end

        private

        def get_posts limit, offset
            @wp.getPosts @blog, { :number => limit, :offset => offset }
        end

        def filter_posts posts
            result = []
            posts.each do |post|
                valid = (@user_id == post['post_author'] and post['post_status'] == 'publish' and post['post_type'] == 'post')
                if valid and not @excluded_categories.empty? then
                    post['terms'].each do |term|
                        if term['taxonomy'] == 'category' and (@excluded_categories.include?(term['name']) or @excluded_categories.include?(term['slug'])) then
                            valid = false
                            break
                        end
                    end
                end
                result << post unless not valid
            end
            result
        end

        def get_content post
            content = post['post_content']

            content = content.gsub(/=('|")\//, '=\1*/') .gsub(/\*\//, '//' + @url + '/') # fix relative urls

            if has_thumbnail post then
                content = '<div class="cover"><img src="' + get_thumbnail(post) + '" /></div>' + content
            end

            '<h1>' + post['post_title'] + '</h1>' + content
        end

        def get_excerpt post
            if not post['post_excerpt'].empty? then
                excerpt = post['post_excerpt']
            else
                excerpt = get_content post
            end
        end

        def get_thumbnail post
            if has_thumbnail post then
                post['post_thumbnail']['link']
            else
                false
            end
        end

        def has_thumbnail post
            post.key? 'post_thumbnail' and not post['post_thumbnail'].empty? and post['post_thumbnail'].key? 'link'
        end

    end
end
