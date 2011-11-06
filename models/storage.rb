require 'mongo'

class Storage

    def self.set data
        Storage.connect.insert data
    end

    def self.get offset, limit
        query = {}
        options = {
            :skip => offset,
            :limit => limit,
            :sort => [:date, :desc]
        }
        return Storage.connect.find query, options
    end

    def self.reset
        Storage.connect.drop
    end

    private

    def self.connect
        connect = Mongo::Connection.new
        db = connect['timeline']
        collection = db['timeline']
        return collection
    end

end
