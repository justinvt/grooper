#!/usr/bin/env ruby -i

require 'lib/grooper.rb'

# Defaults to reading assets.yml in root folder
Grooper.log_level=Logger::INFO
Grooper.log.info Grooper.assets_for(:layout => "content", :filename => "example.erb").inspect