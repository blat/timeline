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
        config = YAML.load_file('./config.yml')
        connect = Mongo::Connection.new(config['mongo']['host'], config['mongo']['port'])
        db = connect[config['mongo']['db']]
        collection = db[config['mongo']['collection']]
        return collection
    end

end
