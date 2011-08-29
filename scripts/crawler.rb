#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require './models/crawler'

config = YAML.load_file('./config.yml')

Crawler.run config['services']
