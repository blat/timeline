require 'open-uri'

class Stream

    attr_accessor :options

    def initialize options
        @options = options
    end

    def crawl
        raise 'Need to implement this method'
    end

    protected

    def download url
        result = ''
        begin
            result = open url
            if not result.instance_of? String then
                result = result.read
            end
        rescue
        end
        return result
    end

end
