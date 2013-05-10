require 'yaml'
require 'time'

module Import

    def self.run
        config = YAML.load_file('_config.yml')
        config['timeline'].each do |services|
            services.each do |service, options|
                require "./_timeline/drivers/#{service}.rb"
                service = Object.const_get("Timeline::#{service.capitalize}").new options
                service.export
            end
        end
    end

    protected

    def import date, slug, content, data
        data['layout'] = 'post'

        date = format_date date

        if data.key? 'update' and data['update'] then
            data['update'] = format_date data['update']
            data['update'] = filter_update data['update'], date
            data['update'] = format_update data['update']
        end

        if data.key? 'excerpt' and data['excerpt'] then
            data['excerpt'] = filter_excerpt data['excerpt']
        end

        data = data.delete_if { |k,v| not v || v.nil? }.to_yaml

        filename = "%s-%s.markdown" % [date.strftime('%Y-%m-%d'), slug]
        FileUtils.mkdir '_posts' unless File.exists? '_posts'
        File.open("_posts/#{filename}", "w") do |file|
            file.puts data
            file.puts "---"
            file.puts content
        end
    end

    private

    def format_date date
        unless date.kind_of?(Time) then
            date = Time.parse date
        end
        date
    end

    def format_update update
        if update then
            update = update.strftime('%Y-%m-%d')
        end
        update
    end

    def filter_update update, date
        if update.to_date === date.to_date then
            update = false
        end
        update
    end

    def filter_excerpt excerpt
        begin
            excerpt.gsub(/<[^>]*>/ui,'').strip.gsub(/\n/, "<br/>")
        rescue
            false
        end
    end

    def force_content_encoding content
        begin
            if content.encoding.to_s != 'UTF-8' then
                content.force_encoding('UTF-8')
            end
        rescue
            puts 'error'
        end
    end

end

Import.run
