require 'lastfm-client'

module Timeline
    class Lastfm
        include Import

        def initialize options
            LastFM.api_key = options['api_key']
            LastFM.client_name = "Timeline"

        end

        def export
            page = 1

            while true
                events = LastFM::User.get_past_events :user => "saezlive", :page => page

                events['events']['event'].each do |event|
                    title = get_title event
                    excerpt = get_excerpt event
                    content = get_content event

                    import event['startDate'], event['id'], content, {
                        'title'        => title,
                        'excerpt'      => excerpt,
                        'source_url'   => event['url'],
                        'source_title' => 'LastFM',
                    }
                end

                if page == events['events']['@attr']['totalPages'].to_i then
                    break
                end

                page = page + 1
            end
        end

        private

        def get_title event
            "%s @ %s (%s)" % [event['title'], event['venue']['location']['city'], event['venue']['name']]
        end

        def get_excerpt event
            content = event['artists']['artist']
            if content.kind_of?(Array) then
                content = content.join ' + '
            end
            content
        end

        def get_content event
            excerpt = get_excerpt event
            title = get_title event
            thumbnail = get_thumbnail event
            '<h1>' + title + '</h1><p>' + excerpt + '</p><p><img src="' + thumbnail + '" /></p>'
        end

        def get_thumbnail event
            event['image'].each do |image|
                if image['size'] == 'extralarge' then
                    return image['#text']
                end
            end
        end

    end
end
