Timeline
========

A Soup.io like.


Demo
-----------------

* [blat.fr](http//blat.fr/)


Dependances
-----------------

* bundler
* jekyll
* wordpress-xmlrpc-api
* flickraw
* github_api
* lastfm-client


Setup
-----------------

1. Install Bundler and all dependancies:

        gem install bundler
        bundle install

2. Copy config file:

        cp _config.yml-dist _config.yml

3. Edit `_config.yml` to customize linked services:

        name: Blat
        twitter: mickaelb
        avatar: http://www.gravatar.com/avatar/2f1a6b664834c9197cd9e602598d996a

        timeline:
        - wordpress:
            url: www.example.com
            username: admin
            password:
        - wordpress:
            url: www.example2.com/blog
            username: admin
            password:
        - flickr:
            api_key:
            user_id:  31123500@N08
        - github:
            username: blat
        - lastfm:
            api_key:
            user: saezlive

4. Import data:

        ruby _timeline/import.rb

5. Launch application:

        jekyll --server

6. Go to [http://localhost:4000](http://localhost:4000)
