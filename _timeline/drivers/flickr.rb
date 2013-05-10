require 'flickraw'

module Timeline
    class Flickr
        include Import

        def initialize options
            @user_id = options['user_id']
            FlickRaw.api_key = options['api_key']
            FlickRaw.shared_secret = ''
        end

        def export
            photosets = flickr.photosets.getList :user_id => @user_id
            photosets.each do |photoset|
                content = get_content photoset
                photos = get_photos photoset
                dates = get_dates photos
                thumbnail = get_thumbnail photos, photoset
                import dates.min, photoset.id, content, {
                    'title'        => photoset.title,
                    'thumbnail'    => thumbnail,
                    'excerpt'      => photos.photo.length.to_s + ' photo(s)',
                    'update'       => dates.max,
                    'source_url'   => "http://www.flickr.com/photos/#{@user_id}/sets/#{photoset.id}",
                    'source_title' => 'Flickr',
                }
            end
        end

        private

        def get_content photoset
            <<END
<object width="100%" height="100%">
    <param name="flashvars" value="offsite=true&lang=fr-fr&page_show_url=%2Fphotos%2F#{@user_id}%2Fsets%2F#{photoset.id}%2Fshow%2F&page_show_back_url=%2Fphotos%2F#{@user_id}%2Fsets%2F#{photoset.id}%2F&set_id=#{photoset.id}&jump_to="></param>
    <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf"></param>
    <embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf" flashvars="offsite=true&lang=fr-fr&page_show_url=%2Fphotos%2F#{@user_id}%2Fsets%2F#{photoset.id}%2Fshow%2F&page_show_back_url=%2Fphotos%2F#{@user_id}%2Fsets%2F#{photoset.id}%2F&set_id=#{photoset.id}&jump_to=" width="100%" height="100%"></embed>
</object>
END
        end

        def get_photos photoset
            flickr.photosets.getPhotos :photoset_id => photoset.id, :extras => 'date_taken,url_m'
        end

        def get_dates photos
            dates = []
            photos.photo.each do |photo|
                date = Time.parse photo.datetaken
                dates << date
            end
            dates
        end

        def get_thumbnail photos, photoset
            thumbnail = false
            photos.photo.each do |photo|
                if photoset.primary == photo.id then
                    thumbnail = photo.url_m
                    break
                end
            end
            thumbnail
        end

    end
end
