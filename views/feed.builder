xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
    xml.channel do
        xml.title @title
        @posts.each do |post|
            xml.item do
                xml.title post.title
                xml.description post.content
                xml.pubDate post.date.rfc2822
                xml.link post.link
                xml.guid post.link
            end
        end
    end
end
