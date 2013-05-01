Timeline
========

A Soup.io like.


Dependances
-----------------

* sinatra
* mongo
* simple-rss
* flickraw
* open-uri
* json


Setup
-----------------

1. Install ruby and all dependancies (see above)

2. Copy config file:

        cp config.yml-dist config.yml

3. Edit `config.yml` to customize linked services

4. Run crawler:

        ruby scripts/crawler.rb

5. Launch application:

        ruby timeline.rb

6. Go to [http://localhost:4567](http://localhost:4567)
